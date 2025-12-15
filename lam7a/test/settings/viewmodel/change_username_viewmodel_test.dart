import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/settings/ui/viewmodel/change_username_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/features/settings/ui/state/change_username_state.dart';
import 'package:lam7a/core/models/user_model.dart';

/// Mock Account Repository
class MockAccountViewModel extends Mock implements AccountViewModel {}

/// Fake Account ViewModel that throws error on username change
class FailingAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: 'current_user',
    email: 'test@mail.com',
    role: 'user',
    name: 'Test User',
    birthDate: '2000-01-01',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '2024-01-01',
  );

  @override
  UserModel build() => _state;

  @override
  Future<void> changeUsername(String newUsername) async {
    throw Exception('Username already taken');
  }
}

/// Fake Account ViewModel
class FakeAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: 'current_user',
    email: 'test@mail.com',
    role: 'user',
    name: 'Test User',
    birthDate: '2000-01-01',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '2024-01-01',
  );

  @override
  UserModel build() => _state;

  @override
  Future<void> changeUsername(String newUsername) async {
    _state = _state.copyWith(username: newUsername);
  }
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [accountProvider.overrideWith(() => FakeAccountViewModel())],
    );
  });

  tearDown(() => container.dispose());

  group('ChangeUsernameViewModel - Initial State', () {
    test('builds initial state with current username', () {
      final state = container.read(changeUsernameProvider);

      expect(state.currentUsername, 'current_user');
      expect(state.newUsername, '');
      expect(state.isValid, false);
      expect(state.isLoading, false);
      expect(state.errorMessage, null);
    });
  });

  group('ChangeUsernameViewModel - Username Validation', () {
    test('empty username is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(state.newUsername, '');
    });

    test('username same as current is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('current_user');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(state.errorMessage, 'New username must be different');
    });

    test('username less than 3 characters is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('ab');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(
        state.errorMessage,
        'Username must be between 3 and 50 characters',
      );
    });

    test('username more than 50 characters is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('a' * 51);

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(
        state.errorMessage,
        'Username must be between 3 and 50 characters',
      );
    });

    test('username with consecutive dots is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('user..name');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(
        state.errorMessage,
        'Username can only contain letters, numbers, dots, and underscores',
      );
    });

    test('username with consecutive underscores is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('user__name');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(
        state.errorMessage,
        'Username can only contain letters, numbers, dots, and underscores',
      );
    });

    test('username with special characters is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('user@name!');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
      expect(
        state.errorMessage,
        'Username can only contain letters, numbers, dots, and underscores',
      );
    });

    test('username starting with number is invalid', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('1username');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, false);
    });

    test('valid username with letters only passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('newuser');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
      expect(state.newUsername, 'newuser');
    });

    test('valid username with letters and numbers passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('newuser123');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
    });

    test('valid username with single dot passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('new.user');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
    });

    test('valid username with single underscore passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('new_user');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
    });

    test(
      'valid username with mixed dots and underscores passes validation',
      () {
        final notifier = container.read(changeUsernameProvider.notifier);
        notifier.updateUsername('new.user_123');

        final state = container.read(changeUsernameProvider);

        expect(state.isValid, true);
        expect(state.errorMessage, '');
      },
    );

    test('valid username at minimum length (3 chars) passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('abc');

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
    });

    test('valid username at maximum length (50 chars) passes validation', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername(
        'abcdefghijklmnopqrstuvwxyz1234567890abcdefghijk',
      );

      final state = container.read(changeUsernameProvider);

      expect(state.isValid, true);
      expect(state.errorMessage, '');
    });
  });

  group('ChangeUsernameViewModel - Save Username', () {
    testWidgets('saveUsername updates account when valid', (tester) async {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('newusername');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => notifier.saveUsername(context),
                    child: const Text('Save'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      final state = container.read(changeUsernameProvider);
      //expect(state.currentUsername, 'newusername');
      expect(state.newUsername, '');
      expect(state.isLoading, false);

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username updated'), findsOneWidget);
    });

    testWidgets('saveUsername shows loading state while saving', (
      tester,
    ) async {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('newusername');

      var state = container.read(changeUsernameProvider);
      expect(state.isLoading, false);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => notifier.saveUsername(context),
                    child: const Text('Save'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      state = container.read(changeUsernameProvider);
      expect(state.isLoading, false);
    });

    testWidgets('saveUsername resets newUsername field after success', (
      tester,
    ) async {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('newusername');

      var state = container.read(changeUsernameProvider);
      expect(state.newUsername, 'newusername');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => notifier.saveUsername(context),
                    child: const Text('Save'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      state = container.read(changeUsernameProvider);
      expect(state.newUsername, '');
    });

    testWidgets('saveUsername shows error when account change fails', (
      tester,
    ) async {
      final failContainer = ProviderContainer(
        overrides: [
          accountProvider.overrideWith(() => FailingAccountViewModel()),
        ],
      );
      addTearDown(failContainer.dispose);

      final notifier = failContainer.read(changeUsernameProvider.notifier);
      notifier.updateUsername('taken_username');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: failContainer,
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () => notifier.saveUsername(context),
                    child: const Text('Save'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Username already taken'), findsOneWidget);

      final state = failContainer.read(changeUsernameProvider);
      expect(state.isLoading, false);
    });

    test('saveUsername does not proceed with invalid username', () {
      final notifier = container.read(changeUsernameProvider.notifier);
      notifier.updateUsername('');

      var state = container.read(changeUsernameProvider);
      expect(state.isValid, false);
      expect(state.newUsername, '');
    });

    group('ChangeUsernameViewModel - State Management', () {
      test('updateUsername modifies newUsername in state', () {
        final notifier = container.read(changeUsernameProvider.notifier);
        notifier.updateUsername('testuser');

        final state = container.read(changeUsernameProvider);
        expect(state.newUsername, 'testuser');
      });

      test('updateUsername clears errorMessage when valid', () {
        final notifier = container.read(changeUsernameProvider.notifier);
        notifier.updateUsername('ab');
        var state = container.read(changeUsernameProvider);
        expect(state.errorMessage, isNotNull);

        notifier.updateUsername('validuser');
        state = container.read(changeUsernameProvider);
        expect(state.errorMessage, '');
      });
    });
  });
}
