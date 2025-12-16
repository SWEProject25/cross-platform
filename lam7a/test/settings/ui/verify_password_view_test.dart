import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/settings/ui/view/account_settings/account_info/change_email_views/verify_password_view.dart';
import 'package:lam7a/features/settings/ui/view/account_settings/account_info/change_email_views/change_email_view.dart';
import 'package:lam7a/features/settings/ui/view/account_settings/account_info/change_email_views/verify_otp_view.dart';
import 'package:lam7a/features/settings/ui/viewmodel/change_email_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/change_email_state.dart';
import 'package:lam7a/features/settings/repository/account_settings_repository.dart';
import 'package:lam7a/core/models/user_model.dart';

class FakeAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    // Used for images, svgs, fonts
    return ByteData.view(Uint8List(0).buffer);
  }

  @override
  Future<T> loadStructuredBinaryData<T>(
    String key,
    FutureOr<T> Function(ByteData data) parser,
  ) async {
    // Critical: AssetManifest.bin must be valid
    final emptyManifest = const StandardMessageCodec().encodeMessage(
      <String, dynamic>{},
    );
    return parser(ByteData.view(emptyManifest!.buffer));
  }
}

class MockAccountSettingsRepository extends Mock
    implements AccountSettingsRepository {}

class FakeAccountViewModel extends AccountViewModel {
  final AccountSettingsRepository repo;
  FakeAccountViewModel(this.repo);

  @override
  UserModel build() => UserModel(
    username: 'test_user',
    email: 'test@mail.com',
    role: '',
    name: '',
    birthDate: '',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '',
  );

  @override
  Future<void> changeEmail(String newEmail) async {
    await repo.changeEmail(newEmail);
    state = state.copyWith(email: newEmail);
  }
}

Widget createTestWidget({ChangeEmailPage? initialPage}) {
  final mockRepo = MockAccountSettingsRepository();

  when(() => mockRepo.validatePassword(any())).thenAnswer((_) async => true);
  when(() => mockRepo.checkEmailExists(any())).thenAnswer((_) async => false);
  when(() => mockRepo.sendOtp(any())).thenAnswer((_) async {});
  when(() => mockRepo.validateOtp(any(), any())).thenAnswer((_) async => true);
  when(() => mockRepo.changeEmail(any())).thenAnswer((_) async {});

  return ProviderScope(
    overrides: [
      accountSettingsRepoProvider.overrideWithValue(mockRepo),
      accountProvider.overrideWith(() => FakeAccountViewModel(mockRepo)),
      if (initialPage != null)
        changeEmailProvider.overrideWith(() {
          final vm = ChangeEmailViewModel();
          vm.state = ChangeEmailState(
            email: 'test@mail.com',
            password: '',
            otp: '',
            currentPage: initialPage,
            isLoading: false,
          );
          return vm;
        }),
    ],
    child: DefaultAssetBundle(
      bundle: FakeAssetBundle(),
      child: const MaterialApp(home: VerifyPasswordView()),
    ),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(''));

  testWidgets('password field is obscured and enables Next on input', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // ✅ Correct: TextFormField (NOT TextField)
    final textField = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const ValueKey('verify_password_textfield')),
        matching: find.byType(TextField),
      ),
    );
    expect(textField.obscureText, isTrue);
    await tester.enterText(
      find.byKey(const ValueKey('verify_password_textfield')),
      'password123',
    );
    await tester.pumpAndSettle();

    final nextButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('next_or_button')),
    );

    expect(nextButton.onPressed, isNotNull);
  });

  // =====================================================
  // CHANGE EMAIL
  // =====================================================
  testWidgets('entering email enables Next and shows email in UI', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(initialPage: ChangeEmailPage.changeEmail),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('change_email_textfield')),
      'new@test.com',
    );
    await tester.pumpAndSettle();

    expect(find.text('new@test.com'), findsOneWidget);

    final nextButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('next_or_button')),
    );
    expect(nextButton.onPressed, isNotNull);
  });

  // =====================================================
  // VERIFY OTP
  // =====================================================
  testWidgets('OTP enables Verify and resend works after cooldown', (
    tester,
  ) async {
    await tester.pumpWidget(
      createTestWidget(initialPage: ChangeEmailPage.verifyOtp),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('otp_textfield')),
      '123456',
    );
    await tester.pumpAndSettle();

    final verifyButton = tester.widget<FilledButton>(
      find.byKey(const ValueKey('next_or_button')),
    );
    expect(verifyButton.onPressed, isNotNull);

    await tester.pump(const Duration(seconds: 60));
    await tester.tap(find.byKey(const ValueKey('resend_otp_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('60'), findsOneWidget);
  });

  // =====================================================
  // FULL FLOW
  // =====================================================
  testWidgets('complete change email flow works end-to-end', (tester) async {
    await tester.pumpWidget(createTestWidget());
    await tester.pumpAndSettle();

    // password
    await tester.enterText(
      find.byKey(const ValueKey('verify_password_textfield')),
      'password123',
    );
    await tester.tap(find.byKey(const ValueKey('next_or_button')));
    await tester.pumpAndSettle();

    expect(find.byType(ChangeEmailView), findsOneWidget);

    // email
    await tester.enterText(
      find.byKey(const ValueKey('change_email_textfield')),
      'new@test.com',
    );
    await tester.tap(find.byKey(const ValueKey('next_or_button')));
    await tester.pumpAndSettle();

    expect(find.byType(VerifyOtpView), findsOneWidget);

    // otp
    await tester.enterText(
      find.byKey(const ValueKey('otp_textfield')),
      '123456',
    );
    await tester.tap(find.byKey(const ValueKey('next_or_button')));
    await tester.pumpAndSettle();
  });
}
