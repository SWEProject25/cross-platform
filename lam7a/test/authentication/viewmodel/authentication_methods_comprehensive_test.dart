import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthentication extends Authentication {
  UserModel? lastAuthenticatedUser;
  int authenticateUserCallCount = 0;

  @override
  AuthState build() {
    return AuthState();
  }

  @override
  void authenticateUser(UserDtoAuth? user) {
    lastAuthenticatedUser = userDtoToUserModel(user!);
    authenticateUserCallCount++;
    state = state.copyWith(
      token: null,
      isAuthenticated: true,
      user: lastAuthenticatedUser,
    );
  }

  @override
  Future<void> isAuthenticated() async {
    authenticateUser(
      UserDtoAuth(
        id: 1,
        userId: 1,
        name: "Test User",
        birthDate: DateTime(2003),
        bannerImageUrl: "/path",
        bio: "hello",
        location: "place",
        website: "web",
        isDeactivated: false,
        createdAt: DateTime(2000),
        updatedAt: DateTime(2000),
        user: UserDash(
          id: 1,
          email: "test@example.com",
          role: "USER",
          createdAt: DateTime(2003),
          username: "testuser",
        ),
        followersCount: 1,
        followingCount: 1,
        isFollowedByMe: false,
      ),
    );
    authenticateUserCallCount++;
  }

  @override
  UserModel userDtoToUserModel(UserDtoAuth dto) {
    return UserModel(
      id: dto.id,
      username: dto.user?.username ?? null,
      email: dto.user?.email ?? null,
      role: dto.user?.role ?? null,
      name: dto.name,
      profileImageUrl: dto.profileImageUrl?.toString(),
      bannerImageUrl: dto.bannerImageUrl?.toString(),
      bio: dto.bio?.toString(),
      location: dto.location?.toString(),
      website: dto.website?.toString(),
      createdAt: dto.createdAt?.toIso8601String(),
      followersCount: dto.followersCount,
      followingCount: dto.followingCount,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepositoryImpl mockRepo;
  late FakeAuthentication fakeAuth;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();
    fakeAuth = FakeAuthentication();

    container = ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
        authenticationProvider.overrideWith(() => fakeAuth),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  AuthenticationViewmodel getNotifier() {
    final notifier = container.read(authenticationViewmodelProvider.notifier);
    container.read(authenticationViewmodelProvider);
    return notifier;
  }

  group('AuthenticationViewmodel - shouldEnableNext Method Coverage', () {
    test(
        'shouldEnableNext returns true when all signup fields are valid at step 0',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: true,
        isValidName: true,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test(
        'shouldEnableNext returns false when email is invalid at step 0',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: false,
        isValidName: true,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test(
        'shouldEnableNext returns false when name is invalid at step 0',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: true,
        isValidName: false,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test(
        'shouldEnableNext returns false when date is invalid at step 0',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: true,
        isValidName: true,
        isValidDate: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test(
        'shouldEnableNext returns true when code is valid at step 1',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidCode: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test(
        'shouldEnableNext returns false when code is invalid at step 1',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidCode: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test(
        'shouldEnableNext returns true when password is valid at step 2',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidSignupPassword: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test(
        'shouldEnableNext returns false when password is invalid at step 2',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidSignupPassword: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test(
        'shouldEnableNext returns true for transition screen at step 3',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 3,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test(
        'shouldEnableNext returns false for unknown step',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 99,
      );

      expect(notifier.shouldEnableNext(), false);
    });
  });

  group('AuthenticationViewmodel - shouldEnableNextLogin Method Coverage', () {
    test('shouldEnableNextLogin true at step 0 with valid email', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
        identifier: 'test@example.com',
      );

      expect(notifier.shouldEnableNextLogin(), true);
    });

    test('shouldEnableNextLogin false at step 0 with invalid email', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
        identifier: 'invalid',
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });

    test('shouldEnableNextLogin false at step 0 with empty email', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
        identifier: '',
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });

    test('shouldEnableNextLogin true at step 1 with valid password', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        passwordLogin: 'ValidPassword123!',
      );

      expect(notifier.shouldEnableNextLogin(), true);
    });

    test('shouldEnableNextLogin false at step 1 with weak password', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        passwordLogin: 'weak',
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });

    test('shouldEnableNextLogin false at step 1 with empty password', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        passwordLogin: '',
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });
  });

  group('AuthenticationViewmodel - Update Methods Coverage', () {
    test('updateName updates name and validation in signup', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup();

      notifier.updateName('John Doe');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals('John Doe'));
      expect(state.isValidName, true);
    });

    test('updateName invalidates empty name in signup', () {
      final notifier = getNotifier();

      notifier.updateName('');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals(''));
      expect(state.isValidName, false);
    });

    test('updateEmail updates email and validation in signup', () {
      final notifier = getNotifier();

      notifier.updateEmail('test@example.com');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.email, equals('test@example.com'));
      expect(state.isValidEmail, true);
    });

    test('updateEmail invalidates invalid email in signup', () {
      final notifier = getNotifier();

      notifier.updateEmail('invalid');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.email, equals('invalid'));
      expect(state.isValidEmail, false);
    });

    test('updateDateTime updates date and validation in signup', () {
      final notifier = getNotifier();

      notifier.updateDateTime('2000-01-15');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.date, equals('2000-01-15'));
      expect(state.isValidDate, true);
    });

    test('updateDateTime validates invalid date in signup', () {
      final notifier = getNotifier();

      notifier.updateDateTime('valid-date');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidDate, true);
    });

    test('updateVerificationCode updates code and validation in signup', () {
      final notifier = getNotifier();

      notifier.updateVerificationCode('123456');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.code, equals('123456'));
      expect(state.isValidCode, true);
    });

    test('updateVerificationCode invalidates invalid code in signup', () {
      final notifier = getNotifier();

      notifier.updateVerificationCode('123');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidCode, false);
    });

    test('updateUserName updates username and validation in signup', () {
      final notifier = getNotifier();

      notifier.updateUserName('testuser');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidUsername, true);
    });

    test('updatePassword updates password and validation in signup', () {
      final notifier = getNotifier();

      notifier.updatePassword('ValidPassword123!');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordSignup, equals('ValidPassword123!'));
      expect(state.isValidSignupPassword, true);
    });

    test('updatePassword invalidates weak password in signup', () {
      final notifier = getNotifier();

      notifier.updatePassword('weak');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidSignupPassword, false);
    });

    test('updatePasswordLogin updates login password', () {
      final notifier = getNotifier();
      notifier.changeToLogin();

      notifier.updatePasswordLogin('LoginPassword123!');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordLogin, equals('LoginPassword123!'));
    });

    test('updateIdentifier updates login identifier', () {
      final notifier = getNotifier();
      notifier.changeToLogin();

      notifier.updateIdentifier('test@example.com');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
    });
  });

  group('AuthenticationViewmodel - Navigation Steps Coverage', () {
    test('gotoNextSignupStep increments step when valid', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: true,
        isValidName: true,
        isValidDate: true,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(1));
    });

    test('gotoNextSignupStep does not exceed max steps', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 4,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, lessThanOrEqualTo(4));
    });

    test('gotoPrevSignupStep decrements step', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(1));
    });

    test('gotoPrevSignupStep resets at step 0', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(0));
    });

    test('gotoPrevSignupStep clears password validity', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidSignupPassword: true,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidSignupPassword, false);
    });

    test('gotoPrevSignupStep clears code validity', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidCode: true,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidCode, false);
    });

    test('gotoNextLoginStep increments step', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
      );

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(1));
    });

    test('gotoNextLoginStep does not exceed max steps', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
      );

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, lessThanOrEqualTo(1));
    });

    test('gotoPrevLoginStep decrements step', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
      );

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
    });

    test('gotoPrevLoginStep does not go below 0', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
      );

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
    });
  });

  group('AuthenticationViewmodel - State Transitions', () {
    test('changeToLogin transitions to login state', () {
      final notifier = getNotifier();

      notifier.changeToLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
    });

    test('changeToSignup transitions to signup state', () {
      final notifier = getNotifier();
      notifier.changeToLogin();

      notifier.changeToSignup();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(0));
    });

    test('goToHome from signup state resets step', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 3,
      );

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(0));
    });

    test('goToHome from login state resets step', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
      );

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
    });
  });
}
