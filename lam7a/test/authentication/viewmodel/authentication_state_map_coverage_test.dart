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

  group('AuthenticationViewmodel - State.map coverage (login => login branch)', () {
    test(
        'updateName in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        passwordLogin: 'Password123!',
      );

      // Call updateName which uses state.map with login => login
      notifier.updateName('John Doe');

      final state = container.read(authenticationViewmodelProvider);
      // State should remain login with same values
      expect(state.identifier, equals('test@example.com'));
      expect(state.passwordLogin, equals('Password123!'));
    });

    test(
        'updateEmail in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'old@example.com',
        passwordLogin: 'Password123!',
      );

      notifier.updateEmail('new@example.com');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('old@example.com'));
      expect(state.passwordLogin, equals('Password123!'));
    });

    test(
        'updateDateTime in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        passwordLogin: 'Password123!',
      );

      notifier.updateDateTime('2000-01-01');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
      expect(state.passwordLogin, equals('Password123!'));
    });

    test(
        'updateVerificationCode in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
      );

      notifier.updateVerificationCode('123456');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
    });

    test(
        'updateUserName in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
      );

      notifier.updateUserName('newusername');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
    });

    test(
        'updatePassword in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        passwordLogin: 'OldPassword123!',
      );

      notifier.updatePassword('NewPassword123!');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
      expect(state.passwordLogin, equals('OldPassword123!'));
    });

    test(
        'clearMessage in login state should not affect login state (login => login)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        toastMessageLogin: 'Error message',
      );

      notifier.clearMessage();

      final state = container.read(authenticationViewmodelProvider);
      // clearMessage only clears signup toast, not login toast
      expect(state.toastMessageLogin, equals('Error message'));
    });

    test(
        'gotoNextSignupStep in login state should not change login state (login => loginState)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        currentLoginStep: 0,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
      expect(state.identifier, equals('test@example.com'));
    });

    test(
        'gotoPrevSignupStep in login state should not change login state (login => loginState)',
        () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        currentLoginStep: 1,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(1));
      expect(state.identifier, equals('test@example.com'));
    });
  });

  group('AuthenticationViewmodel - State.map coverage (signup => signup branch)', () {
    test(
        'updateIdentifier in signup state should not affect signup state (signup => signup)',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        email: 'john@example.com',
      );

      notifier.updateIdentifier('newemail@example.com');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals('John Doe'));
      expect(state.email, equals('john@example.com'));
    });

    test(
        'updatePasswordLogin in signup state should not affect signup state (signup => signup)',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        passwordSignup: 'SignupPassword123!',
        name: 'John Doe',
      );

      notifier.updatePasswordLogin('LoginPassword123!');

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordSignup, equals('SignupPassword123!'));
      expect(state.name, equals('John Doe'));
    });

    test(
        'gotoNextLoginStep in signup state should not change signup state (signup => signupState)',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        currentSignupStep: 1,
      );

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(1));
      expect(state.name, equals('John Doe'));
    });

    test(
        'gotoPrevLoginStep in signup state should not change signup state (signup => signupState)',
        () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        currentSignupStep: 2,
      );

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(2));
      expect(state.name, equals('John Doe'));
    });
  });

  group('AuthenticationViewmodel - clearMessage coverage', () {
    test('clearMessage should clear signup toast message', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        toastMessage: 'Test signup message',
      );

      notifier.clearMessage();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.toastMessage, isNull);
    });

    test('clearMessage should preserve other signup fields', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        email: 'john@example.com',
        toastMessage: 'Test message',
      );

      notifier.clearMessage();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals('John Doe'));
      expect(state.email, equals('john@example.com'));
      expect(state.toastMessage, isNull);
    });
  });

  group('AuthenticationViewmodel - setLoadingLogin/setLoadedLogin', () {
    test('setLoadingLogin should set isLoadingLogin to true in login state', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        isLoadingLogin: false,
      );

      notifier.setLoadingLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isLoadingLogin, true);
    });

    test('setLoadedLogin should set isLoadingLogin to false in login state', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        isLoadingLogin: true,
      );

      notifier.setLoadedLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isLoadingLogin, false);
    });

    test('setLoadingLogin in signup state should not affect signup', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        isLoadingSignup: false,
      );

      notifier.setLoadingLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals('John Doe'));
      expect(state.isLoadingSignup, false);
    });

    test('setLoadedLogin in signup state should not affect signup', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        name: 'John Doe',
        isLoadingSignup: true,
      );

      notifier.setLoadedLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, equals('John Doe'));
      expect(state.isLoadingSignup, true);
    });
  });

  group('AuthenticationViewmodel - setLoadingSignUp/setLoadedSignUp', () {
    test('setLoadingSignUp should set isLoadingSignup to true in signup state', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        isLoadingSignup: false,
      );

      notifier.setLoadingSignUp();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isLoadingSignup, true);
    });

    test('setLoadedSignUp should set isLoadingSignup to false in signup state', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        isLoadingSignup: true,
      );

      notifier.setLoadedSignUp();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isLoadingSignup, false);
    });

    test('setLoadingSignUp in login state should not affect login', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        isLoadingLogin: false,
      );

      notifier.setLoadingSignUp();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
      expect(state.isLoadingLogin, false);
    });

    test('setLoadedSignUp in login state should not affect login', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        identifier: 'test@example.com',
        isLoadingLogin: true,
      );

      notifier.setLoadedSignUp();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, equals('test@example.com'));
      expect(state.isLoadingLogin, true);
    });
  });

  group('AuthenticationViewmodel - goToHome resets both states', () {
    test('goToHome resets signup step to 0', () {
      final notifier = getNotifier();
      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 3,
        name: 'John Doe',
      );

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, equals(0));
      expect(state.name, equals('John Doe'));
    });

    test('goToHome resets login step to 0', () {
      final notifier = getNotifier();
      notifier.changeToLogin();
      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        identifier: 'test@example.com',
      );

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, equals(0));
      expect(state.identifier, equals('test@example.com'));
    });
  });

  group('AuthenticationViewmodel - normalizeEmail edge cases', () {
    test('normalizeEmail handles multiple spaces', () {
      final notifier = getNotifier();
      final result = notifier.normalizeEmail('   TEST@EXAMPLE.COM   ');
      expect(result, equals('test@example.com'));
    });

    test('normalizeEmail handles mixed case with special chars', () {
      final notifier = getNotifier();
      final result = notifier.normalizeEmail('  TeSt+Tag@ExAmPlE.cOm  ');
      expect(result, equals('test+tag@example.com'));
    });

    test('normalizeEmail handles already normalized', () {
      final notifier = getNotifier();
      final result = notifier.normalizeEmail('test@example.com');
      expect(result, equals('test@example.com'));
    });
  });
}
