import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/settings/ui/view/account_settings/change_password/change_password_view.dart';
import 'package:lam7a/features/settings/ui/viewmodel/change_password_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/features/settings/repository/account_settings_repository.dart';
import 'package:lam7a/core/models/user_model.dart';

class FakeAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    return ByteData.view(Uint8List(0).buffer);
  }

  @override
  Future<T> loadStructuredBinaryData<T>(
    String key,
    FutureOr<T> Function(ByteData data) parser,
  ) async {
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
}

Widget createTestWidget(MockAccountSettingsRepository mockRepo) {
  return ProviderScope(
    overrides: [
      accountSettingsRepoProvider.overrideWithValue(mockRepo),
      accountProvider.overrideWith(() => FakeAccountViewModel(mockRepo)),
    ],
    child: DefaultAssetBundle(
      bundle: FakeAssetBundle(),
      child: MaterialApp(
        home: const ChangePasswordView(),
        routes: {
          '/forgot_password': (context) => const Scaffold(
            body: Center(child: Text('Forgot Password Screen')),
          ),
        },
      ),
    ),
  );
}

void main() {
  late MockAccountSettingsRepository mockRepo;

  setUp(() {
    mockRepo = MockAccountSettingsRepository();
  });

  testWidgets('renders all password fields and submit button', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('change_password_current_field')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('change_password_new_field')), findsOneWidget);
    expect(
      find.byKey(const Key('change_password_confirm_field')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('change_password_submit_button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('change_password_forgot_button')),
      findsOneWidget,
    );
    expect(find.text('test_user'), findsOneWidget);
  });

  testWidgets('password fields are obscured by default', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    final currentField = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('change_password_current_field')),
        matching: find.byType(TextField),
      ),
    );
    final newField = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('change_password_new_field')),
        matching: find.byType(TextField),
      ),
    );
    final confirmField = tester.widget<TextField>(
      find.descendant(
        of: find.byKey(const Key('change_password_confirm_field')),
        matching: find.byType(TextField),
      ),
    );

    expect(currentField.obscureText, isTrue);
    expect(newField.obscureText, isTrue);
    expect(confirmField.obscureText, isTrue);
  });

  testWidgets('submit button is disabled when fields are empty', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('change_password_submit_button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('submit button enabled when all fields valid', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_current_field')),
      'OldPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'NewPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_confirm_field')),
      'NewPass123!',
    );
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('change_password_submit_button')),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('shows error when new password is too short', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'Short1!',
    );

    // Trigger focus change to validate
    await tester.tap(find.byKey(const Key('change_password_confirm_field')));
    await tester.pumpAndSettle();

    expect(find.text('Password must be at least 8 characters'), findsOneWidget);
  });

  testWidgets('shows error when passwords do not match', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'NewPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_confirm_field')),
      'DifferentPass123!',
    );

    // Trigger focus change
    await tester.tap(find.byKey(const Key('change_password_current_field')));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('shows error when new password missing required characters', (
    tester,
  ) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'onlylowercase',
    );

    await tester.tap(find.byKey(const Key('change_password_confirm_field')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Password must include:'), findsOneWidget);
  });

  testWidgets('successful password change shows snackbar and pops', (
    tester,
  ) async {
    when(() => mockRepo.changePassword(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_current_field')),
      'OldPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'NewPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_confirm_field')),
      'NewPass123!',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('change_password_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Password changed successfully'), findsOneWidget);
    verify(
      () => mockRepo.changePassword('OldPass123!', 'NewPass123!'),
    ).called(1);
  });

  testWidgets('failed password change shows error dialog', (tester) async {
    when(
      () => mockRepo.changePassword(any(), any()),
    ).thenThrow(Exception('Invalid password'));

    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('change_password_current_field')),
      'WrongPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_new_field')),
      'NewPass123!',
    );
    await tester.enterText(
      find.byKey(const Key('change_password_confirm_field')),
      'NewPass123!',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('change_password_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect Password'), findsOneWidget);
    expect(
      find.text('Please enter the correct current password.'),
      findsOneWidget,
    );

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    verify(
      () => mockRepo.changePassword('WrongPass123!', 'NewPass123!'),
    ).called(1);
  });

  testWidgets('toggle visibility icons work correctly', (tester) async {
    await tester.pumpWidget(createTestWidget(mockRepo));
    await tester.pumpAndSettle();

    // Find visibility toggle for current password field
    final visibilityIcons = find.byIcon(Icons.visibility_off);
    expect(visibilityIcons, findsNWidgets(3));

    // Tap first toggle (current password)
    await tester.tap(visibilityIcons.first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
  });

  // testWidgets('forgot password button navigates correctly', (tester) async {
  //   await tester.pumpWidget(createTestWidget(mockRepo));
  //   await tester.pumpAndSettle();

  //   await tester.tap(find.byKey(const Key('change_password_forgot_button')));
  //   await tester.pumpAndSettle();

  //   expect(find.text('Forgot Password Screen'), findsOneWidget);
  // });
}
