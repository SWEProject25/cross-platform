// FILE: test/viewmodels/change_password_notifier_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/settings/ui/viewmodel/change_password_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/change_password_state.dart';
import 'package:lam7a/features/settings/repository/account_settings_repository.dart';

/// -------------------------------
/// MOCKS
/// -------------------------------
class MockAccountRepo extends Mock implements AccountSettingsRepository {}

/// Wrapper widget so we can use BuildContext in tests
class TestApp extends StatelessWidget {
  final Widget child;
  const TestApp(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: child));
  }
}

void main() {
  late ProviderContainer container;
  late MockAccountRepo mockRepo;

  setUpAll(() {
    registerFallbackValue("");
  });

  setUp(() {
    mockRepo = MockAccountRepo();

    container = ProviderContainer(
      overrides: [accountSettingsRepoProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  ChangePasswordNotifier _getNotifier() =>
      container.read(changePasswordProvider.notifier);

  ChangePasswordState _getState() => container.read(changePasswordProvider);

  group('ChangePasswordNotifier - State Management', () {
    test('should initialize with correct default state', () {
      final state = _getState();

      expect(state.isValid, isFalse);
      expect(state.currentController.text, isEmpty);
      expect(state.newController.text, isEmpty);
      expect(state.confirmController.text, isEmpty);
      expect(state.newPasswordError, isNull);
      expect(state.confirmPasswordError, isNull);
    });

    test('should validate when all fields are correctly filled', () {
      final notifier = _getNotifier();

      notifier.state.currentController.text = "OldPass123!";
      notifier.state.newController.text = "NewPass123!";
      notifier.state.confirmController.text = "NewPass123!";

      notifier.updateNew("NewPass123!");

      expect(notifier.state.isValid, isTrue);
    });

    test('should invalidate with empty fields', () {
      final notifier = _getNotifier();

      notifier.state.currentController.text = "";
      notifier.state.newController.text = "NewPass123!";
      notifier.state.confirmController.text = "NewPass123!";

      notifier.updateNew("NewPass123!");

      expect(notifier.state.isValid, isFalse);
    });
  });

  group('ChangePasswordNotifier - Validation', () {
    test('should detect invalid new password (missing requirements)', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "aaaaaaa";
      notifier.updateNew("aaaaaaa");

      notifier.state.newFocus.unfocus();

      expect(notifier.state.newPasswordError, isNotNull);
      expect(notifier.state.newPasswordError, isNotEmpty);
    });

    test('should accept valid new password', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "ValidPass123!";
      notifier.updateNew("ValidPass123!");

      // Assuming validation happens on update
      expect(notifier.state.newPasswordError == "", isTrue);
    });

    test('should show error when passwords do not match', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "NewPass123!";
      notifier.state.confirmController.text = "WrongPass";

      notifier.updateConfirm("WrongPass");

      expect(notifier.state.confirmPasswordError, "Passwords do not match");
    });

    test('should clear error when passwords match', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "NewPass123!";
      notifier.state.confirmController.text = "NewPass123!";

      notifier.updateConfirm("NewPass123!");

      expect(notifier.state.confirmPasswordError, isEmpty);
    });
  });

  group('ChangePasswordNotifier - Missing requirements message', () {
    test('shows message when missing uppercase', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "validpass123!";
      notifier.updateNew("validpass123!"); // triggers _validateNewPassword

      expect(
        notifier.state.newPasswordError,
        "Password must include: uppercase letter",
      );
    });

    test('shows message when missing lowercase', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "VALIDPASS123!";
      notifier.updateNew("VALIDPASS123!");

      expect(
        notifier.state.newPasswordError,
        "Password must include: lowercase letter",
      );
    });

    test('shows message when missing number', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "ValidPass!!!";
      notifier.updateNew("ValidPass!!!");

      expect(notifier.state.newPasswordError, "Password must include: number");
    });

    test('shows message when missing special character', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "ValidPass123";
      notifier.updateNew("ValidPass123");

      expect(
        notifier.state.newPasswordError,
        "Password must include: special character",
      );
    });

    test('shows combined message when multiple requirements are missing', () {
      final notifier = _getNotifier();

      // Missing uppercase and special
      notifier.state.newController.text = "validpass123";
      notifier.updateNew("validpass123");

      expect(
        notifier.state.newPasswordError,
        "Password must include: uppercase letter, special character",
      );
    });

    test('no message when all requirements are met', () {
      final notifier = _getNotifier();

      notifier.state.newController.text = "ValidPass123!";
      notifier.updateNew("ValidPass123!");

      expect(notifier.state.newPasswordError, "");
    });
  });

  group('ChangePasswordNotifier - Integration', () {
    testWidgets(
      'should call repository and show success snackbar on successful password change',
      (tester) async {
        when(
          () => mockRepo.changePassword(any(), any()),
        ).thenAnswer((_) async => Future.value());

        late ChangePasswordNotifier notifier;

        // -------------------------------------------------
        // Create container and prevent autoDispose cleanup
        // -------------------------------------------------
        final container = ProviderContainer(
          overrides: [accountSettingsRepoProvider.overrideWithValue(mockRepo)],
        );
        addTearDown(container.dispose);

        container.listen(
          changePasswordProvider,
          (_, __) {},
          fireImmediately: true,
        );

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: TestApp(
              Builder(
                builder: (context) {
                  return Consumer(
                    builder: (context, ref, _) {
                      notifier = ref.read(changePasswordProvider.notifier);

                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => notifier.changePassword(context),
                            child: const Text("Change Password"),
                          ),
                          ElevatedButton(
                            onPressed: () => notifier.updateButtonState(),
                            child: const Text("Validate"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );

        notifier.state.currentController.text = "old12345!";
        notifier.state.newController.text = "NewPass123!";
        notifier.state.confirmController.text = "NewPass123!";

        notifier.updateCurrent("old12345!");
        notifier.updateNew("NewPass123!");
        notifier.updateConfirm("NewPass123!");

        await tester.pump();

        await tester.tap(find.text("Validate"));
        await tester.pump();

        await tester.tap(find.text("Change Password"));
        await tester.pump();
        await tester.pumpAndSettle();

        verify(
          () => mockRepo.changePassword("old12345!", "NewPass123!"),
        ).called(1);

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets('should show error dialog on failed password change', (
      tester,
    ) async {
      // Mock failure
      when(
        () => mockRepo.changePassword(any(), any()),
      ).thenThrow(Exception("Wrong password"));

      // Create container with mock repository override
      final container = ProviderContainer(
        overrides: [accountSettingsRepoProvider.overrideWithValue(mockRepo)],
      );

      addTearDown(container.dispose);

      // Read the notifier
      final notifier = container.read(changePasswordProvider.notifier);

      // Fill controllers
      notifier.state.currentController.text = "old123!";
      notifier.state.newController.text = "NewPass123!";
      notifier.state.confirmController.text = "NewPass123!";

      // Trigger validation logic
      notifier.updateCurrent("old123!");
      notifier.updateNew("NewPass123!");
      notifier.updateConfirm("NewPass123!");

      // Fake a BuildContext using a widget tester
      await tester.pumpWidget(
        ProviderScope(
          overrides: [accountSettingsRepoProvider.overrideWithValue(mockRepo)],
          child: TestAppFail(
            Builder(
              builder: (context) {
                return Consumer(
                  builder: (context, ref, _) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () => notifier.changePassword(context),
                          child: const Text("Change Password"),
                        ),
                        ElevatedButton(
                          onPressed: () => notifier.updateButtonState(),
                          child: const Text("Validate"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text("Change Password"));
      await tester.pumpAndSettle();

      // EXPECTATIONS
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Incorrect Password"), findsOneWidget);
    });

    testWidgets('should not call repository when form is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [accountSettingsRepoProvider.overrideWithValue(mockRepo)],
          child: const TestApp(_ChangePasswordButton()),
        ),
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(_ChangePasswordButton)),
      );
      final notifier = container.read(changePasswordProvider.notifier);

      // Leave fields empty or invalid
      notifier.state.currentController.text = "";
      notifier.state.newController.text = "";

      await tester.tap(find.text("Change Password"));
      await tester.pumpAndSettle();

      verifyNever(() => mockRepo.changePassword(any(), any()));
    });
  });
}

/// Helper widget for testing changePassword function
class _ChangePasswordButton extends ConsumerWidget {
  const _ChangePasswordButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(changePasswordProvider.notifier);
    return Center(
      child: ElevatedButton(
        onPressed: () => notifier.changePassword(context),
        child: const Text("Change Password"),
      ),
    );
  }
}

class TestAppFail extends StatelessWidget {
  final Widget child;
  const TestAppFail(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: child));
  }
}
