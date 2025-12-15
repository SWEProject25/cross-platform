import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/features/settings/repository/account_settings_repository.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';

/// Mock Account Settings Repository
class MockAccountSettingsRepository extends Mock
    implements AccountSettingsRepository {}

/// Mock Authentication Notifier
class MockAuthenticationNotifier extends Mock implements Authentication {}

/// Fake Authentication State
class FakeAuthentication extends Authentication {
  UserModel? _user;

  FakeAuthentication({UserModel? initialUser})
    : _user =
          initialUser ??
          UserModel(
            username: 'test_user',
            email: 'test@mail.com',
            role: 'user',
            name: 'Test User',
            birthDate: '2000-01-01',
            profileImageUrl: '',
            bannerImageUrl: '',
            bio: 'Test bio',
            location: 'Test location',
            website: 'https://test.com',
            createdAt: '2024-01-01',
          );

  @override
  AuthState build() {
    return AuthState(isAuthenticated: true, user: _user);
  }

  void updateUser(UserModel user) {
    _user = user;
    state = AuthState(isAuthenticated: true, user: user);
  }
}

void main() {
  late ProviderContainer container;
  late MockAccountSettingsRepository mockRepo;
  late FakeAuthentication fakeAuth;

  setUpAll(() {
    registerFallbackValue('');
  });

  setUp(() {
    mockRepo = MockAccountSettingsRepository();
    fakeAuth = FakeAuthentication();

    container = ProviderContainer(
      overrides: [
        accountSettingsRepoProvider.overrideWithValue(mockRepo),
        authenticationProvider.overrideWith(() => fakeAuth),
      ],
    );
  });

  tearDown(() => container.dispose());

  group('AccountViewModel - Initial State', () {
    test('builds initial state from authentication provider', () {
      final state = container.read(accountProvider);

      expect(state.username, 'test_user');
      expect(state.email, 'test@mail.com');
      expect(state.role, 'user');
      expect(state.name, 'Test User');
      expect(state.birthDate, '2000-01-01');
      expect(state.bio, 'Test bio');
      expect(state.location, 'Test location');
      expect(state.website, 'https://test.com');
    });

    test('loads user from authenticationProvider', () {
      final customUser = UserModel(
        username: 'custom_user',
        email: 'custom@mail.com',
        role: 'admin',
        name: 'Custom User',
        birthDate: '1990-05-15',
        profileImageUrl: 'profile.jpg',
        bannerImageUrl: 'banner.jpg',
        bio: 'Custom bio',
        location: 'Custom location',
        website: 'https://custom.com',
        createdAt: '2023-01-01',
      );

      final customAuth = FakeAuthentication(initialUser: customUser);

      final customContainer = ProviderContainer(
        overrides: [
          accountSettingsRepoProvider.overrideWithValue(mockRepo),
          authenticationProvider.overrideWith(() => customAuth),
        ],
      );
      addTearDown(customContainer.dispose);

      final state = customContainer.read(accountProvider);

      expect(state.username, 'custom_user');
      expect(state.email, 'custom@mail.com');
      expect(state.role, 'admin');
    });
  });

  group('AccountViewModel - Update Email', () {
    test('changeEmail updates repository and local state', () async {
      when(
        () => mockRepo.changeEmail('new@mail.com'),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(accountProvider.notifier);
      await notifier.changeEmail('new@mail.com');

      verify(() => mockRepo.changeEmail('new@mail.com')).called(1);

      final state = container.read(accountProvider);
      expect(state.email, 'new@mail.com');
    });

    test('changeEmail updates authentication provider', () async {
      when(
        () => mockRepo.changeEmail('updated@mail.com'),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(accountProvider.notifier);
      await notifier.changeEmail('updated@mail.com');

      final authState = container.read(authenticationProvider);
      expect(authState.user?.email, 'updated@mail.com');
    });

    test('changeEmail throws error when repository fails', () async {
      when(
        () => mockRepo.changeEmail('fail@mail.com'),
      ).thenThrow(Exception('Email already exists'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changeEmail('fail@mail.com'),
        throwsA(isA<Exception>()),
      );

      verify(() => mockRepo.changeEmail('fail@mail.com')).called(1);
    });

    test('changeEmail does not update state when repository fails', () async {
      final originalEmail = container.read(accountProvider).email;

      when(
        () => mockRepo.changeEmail('fail@mail.com'),
      ).thenThrow(Exception('Email already exists'));

      final notifier = container.read(accountProvider.notifier);

      try {
        await notifier.changeEmail('fail@mail.com');
      } catch (_) {
        // Expected to throw
      }

      final state = container.read(accountProvider);
      expect(state.email, originalEmail);
    });
  });

  group('AccountViewModel - Update Username', () {
    test('changeUsername updates repository and local state', () async {
      when(
        () => mockRepo.changeUsername('new_username'),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(accountProvider.notifier);
      await notifier.changeUsername('new_username');

      verify(() => mockRepo.changeUsername('new_username')).called(1);

      final state = container.read(accountProvider);
      expect(state.username, 'new_username');
    });

    test('changeUsername updates authentication provider', () async {
      when(
        () => mockRepo.changeUsername('updated_username'),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(accountProvider.notifier);
      await notifier.changeUsername('updated_username');

      final authState = container.read(authenticationProvider);
      expect(authState.user?.username, 'updated_username');
    });

    test('changeUsername throws error when repository fails', () async {
      when(
        () => mockRepo.changeUsername('taken_username'),
      ).thenThrow(Exception('Username already taken'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changeUsername('taken_username'),
        throwsA(isA<Exception>()),
      );

      verify(() => mockRepo.changeUsername('taken_username')).called(1);
    });

    test(
      'changeUsername does not update state when repository fails',
      () async {
        final originalUsername = container.read(accountProvider).username;

        when(
          () => mockRepo.changeUsername('taken_username'),
        ).thenThrow(Exception('Username already taken'));

        final notifier = container.read(accountProvider.notifier);

        try {
          await notifier.changeUsername('taken_username');
        } catch (_) {
          // Expected to throw
        }

        final state = container.read(accountProvider);
        expect(state.username, originalUsername);
      },
    );
  });

  group('AccountViewModel - Update Password', () {
    test('changePassword calls repository with correct parameters', () async {
      when(
        () => mockRepo.changePassword('oldpass123', 'newpass456'),
      ).thenAnswer((_) async => Future.value());

      final notifier = container.read(accountProvider.notifier);
      await notifier.changePassword('oldpass123', 'newpass456');

      verify(
        () => mockRepo.changePassword('oldpass123', 'newpass456'),
      ).called(1);
    });

    test(
      'changePassword throws error when old password is incorrect',
      () async {
        when(
          () => mockRepo.changePassword('wrongpass', 'newpass'),
        ).thenThrow(Exception('Incorrect old password'));

        final notifier = container.read(accountProvider.notifier);

        expect(
          () => notifier.changePassword('wrongpass', 'newpass'),
          throwsA(isA<Exception>()),
        );

        verify(() => mockRepo.changePassword('wrongpass', 'newpass')).called(1);
      },
    );

    test('changePassword throws error when new password is invalid', () async {
      when(
        () => mockRepo.changePassword('oldpass', 'weak'),
      ).thenThrow(Exception('Password too weak'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changePassword('oldpass', 'weak'),
        throwsA(isA<Exception>()),
      );

      verify(() => mockRepo.changePassword('oldpass', 'weak')).called(1);
    });

    test(
      'changePassword completes successfully with valid passwords',
      () async {
        when(
          () => mockRepo.changePassword('OldPass123!', 'NewPass456!'),
        ).thenAnswer((_) async => Future.value());

        final notifier = container.read(accountProvider.notifier);

        await expectLater(
          notifier.changePassword('OldPass123!', 'NewPass456!'),
          completes,
        );

        verify(
          () => mockRepo.changePassword('OldPass123!', 'NewPass456!'),
        ).called(1);
      },
    );
  });

  group('AccountViewModel - Local State Updaters', () {
    test('updateUsernameLocalState updates username in state', () {
      final notifier = container.read(accountProvider.notifier);
      notifier.updateUsernameLocalState('local_user');

      final state = container.read(accountProvider);
      expect(state.username, 'local_user');
    });

    test('updateUsernameLocalState updates authentication provider', () {
      final notifier = container.read(accountProvider.notifier);
      notifier.updateUsernameLocalState('local_user');

      final authState = container.read(authenticationProvider);
      expect(authState.user?.username, 'local_user');
    });

    test('updateEmailLocalState updates email in state', () {
      final notifier = container.read(accountProvider.notifier);
      notifier.updateEmailLocalState('local@mail.com');

      final state = container.read(accountProvider);
      expect(state.email, 'local@mail.com');
    });

    test('updateEmailLocalState updates authentication provider', () {
      final notifier = container.read(accountProvider.notifier);
      notifier.updateEmailLocalState('local@mail.com');

      final authState = container.read(authenticationProvider);
      expect(authState.user?.email, 'local@mail.com');
    });

    test('multiple local updates preserve all changes', () {
      final notifier = container.read(accountProvider.notifier);

      notifier.updateUsernameLocalState('multi_user');
      notifier.updateEmailLocalState('multi@mail.com');

      final state = container.read(accountProvider);
      expect(state.username, 'multi_user');
      expect(state.email, 'multi@mail.com');

      final authState = container.read(authenticationProvider);
      expect(authState.user?.username, 'multi_user');
      expect(authState.user?.email, 'multi@mail.com');
    });
  });

  group('AccountViewModel - Error Handling', () {
    test('changeEmail prints error message and rethrows', () async {
      when(
        () => mockRepo.changeEmail('error@mail.com'),
      ).thenThrow(Exception('Database error'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changeEmail('error@mail.com'),
        throwsA(isA<Exception>()),
      );
    });

    test('changeUsername prints error message and rethrows', () async {
      when(
        () => mockRepo.changeUsername('error_user'),
      ).thenThrow(Exception('Database error'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changeUsername('error_user'),
        throwsA(isA<Exception>()),
      );
    });

    test('changePassword rethrows repository errors', () async {
      when(
        () => mockRepo.changePassword('old', 'new'),
      ).thenThrow(Exception('Database error'));

      final notifier = container.read(accountProvider.notifier);

      expect(
        () => notifier.changePassword('old', 'new'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
