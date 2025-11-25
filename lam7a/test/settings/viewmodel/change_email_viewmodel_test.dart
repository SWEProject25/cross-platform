import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/settings/ui/viewmodel/change_email_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/change_email_state.dart';
import 'package:lam7a/features/settings/repository/account_settings_repository.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';

/// ---------------- MOCKS ----------------
class MockAccountSettingsRepository extends Mock
    implements AccountSettingsRepository {}

/// Fake BuildContext for non-widget tests
class FakeBuildContext extends Fake implements BuildContext {}

/// Fake AccountViewModel override
class FakeAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: '',
    email: 'old@mail.com',
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
  UserModel build() => _state;

  @override
  Future<void> changeEmail(String newEmail) async {
    _state = _state.copyWith(email: newEmail);
  }
}

void main() {
  late ProviderContainer container;
  late MockAccountSettingsRepository mockRepo;

  setUpAll(() {
    registerFallbackValue("");
  });

  setUp(() {
    mockRepo = MockAccountSettingsRepository();

    container = ProviderContainer(
      overrides: [
        accountProvider.overrideWith(() => FakeAccountViewModel()),
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  // ---------------------------------------------------------
  test('Initial State should have default email and first page', () {
    final state = container.read(changeEmailProvider);

    expect(state.email, "old@mail.com");
    expect(state.currentPage, ChangeEmailPage.verifyPassword);
  });

  test('Updating password/email/otp should modify state', () {
    final notifier = container.read(changeEmailProvider.notifier);

    notifier.updatePassword("1234");
    expect(container.read(changeEmailProvider).password, "1234");

    notifier.updateEmail("new@mail.com");
    expect(container.read(changeEmailProvider).email, "new@mail.com");

    notifier.updateOtp("9999");
    expect(container.read(changeEmailProvider).otp, "9999");
  });

  // ---------------------------------------------------------
  test(
    'goToChangeEmail should move to next page when password valid',
    () async {
      when(
        () => mockRepo.validatePassword("1234"),
      ).thenAnswer((_) async => true);

      final context = FakeBuildContext();
      final notifier = container.read(changeEmailProvider.notifier);

      notifier.updatePassword("1234");
      await notifier.goToChangeEmail(context);

      expect(
        container.read(changeEmailProvider).currentPage,
        ChangeEmailPage.changeEmail,
      );
    },
  );

  // ---------------------------------------------------------
  test(
    'goToOtpVerification should send OTP and navigate when email valid',
    () async {
      final context = FakeBuildContext();

      when(
        () => mockRepo.checkEmailExists("new@mail.com"),
      ).thenAnswer((_) async => false);

      when(
        () => mockRepo.sendOtp("new@mail.com"),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(changeEmailProvider.notifier);
      notifier.updateEmail("new@mail.com");

      await notifier.goToOtpVerification(context);

      expect(
        container.read(changeEmailProvider).currentPage,
        ChangeEmailPage.verifyOtp,
      );

      verify(() => mockRepo.sendOtp("new@mail.com")).called(1);
    },
  );

  testWidgets(
    'goToOtpVerification should NOT navigate AND should show error dialog when email invalid',
    (tester) async {
      final testContainer = ProviderContainer(
        overrides: [
          accountProvider.overrideWith(() => FakeAccountViewModel()),
          accountSettingsRepoProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(testContainer.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: testContainer,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      final notifier = ref.read(changeEmailProvider.notifier);
                      return ElevatedButton(
                        key: const Key('trigger-invalid-email'),
                        onPressed: () {
                          notifier.updateEmail("bad-email");
                          notifier.goToOtpVerification(context);
                        },
                        child: const Text("Trigger invalid email"),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('trigger-invalid-email')));
      await tester.pumpAndSettle();

      expect(
        testContainer.read(changeEmailProvider).currentPage,
        ChangeEmailPage.verifyPassword,
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Invalid Email Format'), findsOneWidget);
    },
  );

  testWidgets('should show error dialog when email already exists', (
    tester,
  ) async {
    when(
      () => mockRepo.checkEmailExists(any<String>()),
    ).thenAnswer((_) async => true); // email exists

    when(
      () => mockRepo.sendOtp(any<String>()),
    ).thenAnswer((_) async => Future.value());

    final providerContainer = ProviderContainer(
      overrides: [
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
        accountProvider.overrideWith(() => FakeAccountViewModel()),
      ],
    );
    addTearDown(providerContainer.dispose);

    final notifier = providerContainer.read(changeEmailProvider.notifier);

    notifier.state = notifier.state.copyWith(email: "test@example.com");

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: providerContainer,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => notifier.goToOtpVerification(context),
                child: const Text("Change Email"),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text("Change Email"));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text("Email Already Exists"), findsOneWidget);
  });

  test('ResendOtp should call repository sendOtp', () async {
    when(
      () => mockRepo.sendOtp("old@mail.com"),
    ).thenAnswer((_) async => Future.value());

    final notifier = container.read(changeEmailProvider.notifier);
    await notifier.ResendOtp();

    verify(() => mockRepo.sendOtp("old@mail.com")).called(1);
  });
}
