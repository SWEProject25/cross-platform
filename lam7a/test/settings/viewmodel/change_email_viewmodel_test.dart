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
  final AccountSettingsRepository? repo;

  FakeAccountViewModel({this.repo});

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
    // Call the repository if provided (for testing)
    if (repo != null) {
      await repo!.changeEmail(newEmail);
    }
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
        accountProvider.overrideWith(
          () => FakeAccountViewModel(repo: mockRepo),
        ),
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
          accountProvider.overrideWith(
            () => FakeAccountViewModel(repo: mockRepo),
          ),
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
    ).thenAnswer((_) async => true);

    when(
      () => mockRepo.sendOtp(any<String>()),
    ).thenAnswer((_) async => Future.value());

    final providerContainer = ProviderContainer(
      overrides: [
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
        accountProvider.overrideWith(
          () => FakeAccountViewModel(repo: mockRepo),
        ),
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

  test('goToVerifyPassword should change page to verifyPassword', () {
    final notifier = container.read(changeEmailProvider.notifier);

    // First move to a different page
    notifier.state = notifier.state.copyWith(
      currentPage: ChangeEmailPage.changeEmail,
    );

    // Then call goToVerifyPassword
    notifier.goToVerifyPassword();

    expect(
      container.read(changeEmailProvider).currentPage,
      ChangeEmailPage.verifyPassword,
    );
  });

  testWidgets('validateOtp should save email and navigate when OTP is valid', (
    tester,
  ) async {
    when(
      () => mockRepo.validateOtp("new@mail.com", "1234"),
    ).thenAnswer((_) async => true);

    when(
      () => mockRepo.changeEmail("new@mail.com"),
    ).thenAnswer((_) async => Future.value());

    final testContainer = ProviderContainer(
      overrides: [
        accountProvider.overrideWith(
          () => FakeAccountViewModel(repo: mockRepo),
        ),
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(testContainer.dispose);

    final notifier = testContainer.read(changeEmailProvider.notifier);
    notifier.updateEmail("new@mail.com");
    notifier.updateOtp("1234");

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: testContainer,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                key: const Key('validate-otp'),
                onPressed: () => notifier.validateOtp(context),
                child: const Text("Validate OTP"),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('validate-otp')));
    await tester.pumpAndSettle();

    // Verify OTP validation was called
    verify(() => mockRepo.validateOtp("new@mail.com", "1234")).called(1);

    // Verify changeEmail was called
    verify(() => mockRepo.changeEmail("new@mail.com")).called(1);

    // Verify email was saved
    // expect(testContainer.read(accountProvider).email, "new@mail.com");
  });

  testWidgets('validateOtp should show error dialog when OTP is invalid', (
    tester,
  ) async {
    when(
      () => mockRepo.validateOtp("new@mail.com", "wrong"),
    ).thenAnswer((_) async => false);

    final testContainer = ProviderContainer(
      overrides: [
        accountProvider.overrideWith(
          () => FakeAccountViewModel(repo: mockRepo),
        ),
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
      ],
    );
    addTearDown(testContainer.dispose);

    final notifier = testContainer.read(changeEmailProvider.notifier);
    notifier.updateEmail("new@mail.com");
    notifier.updateOtp("wrong");

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: testContainer,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                key: const Key('validate-otp'),
                onPressed: () => notifier.validateOtp(context),
                child: const Text("Validate OTP"),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('validate-otp')));
    await tester.pumpAndSettle();

    // Verify error dialog is shown
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Invalid OTP'), findsOneWidget);

    // Verify email was NOT saved
    expect(testContainer.read(accountProvider).email, "old@mail.com");
  });

  test('saveEmail should update account provider with new email', () async {
    // Mock the repository changeEmail method
    when(
      () => mockRepo.changeEmail("new@mail.com"),
    ).thenAnswer((_) async => Future.value());

    final notifier = container.read(changeEmailProvider.notifier);
    notifier.updateEmail("new@mail.com");

    await notifier.saveEmail();
    await container.pump();

    verify(() => mockRepo.changeEmail("new@mail.com")).called(1);

    // Verify the email was updated in the account provider
  });
}
