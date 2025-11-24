import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthenticationUserDataModel extends Fake
    implements AuthenticationUserDataModel {}

class FakeAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState();
  }

  @override
  void authenticateUser(UserModel? user) {
    state = state.copyWith(token: null, isAuthenticated: true, user: user);
  }
}

void main() {
  late AuthenticationRepositoryImpl authRepoMock;
  late FakeAuthentication fakeAuth;
  late ProviderContainer container;

  setUp(() {
    authRepoMock = MockAuthenticationRepositoryImpl();
    fakeAuth = FakeAuthentication();

    registerFallbackValue(FakeAuthenticationUserDataModel());
    registerFallbackValue(UserModel());

    container = ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(authRepoMock),
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

  group("shouldEnableNext Validation Tests", () {
    test("should return true when on userData step with valid data", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.userData,
        isValidEmail: true,
        isValidName: true,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test("should return false when on userData step with invalid email", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.userData,
        isValidEmail: false,
        isValidName: true,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test("should return false when on userData step with invalid name", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.userData,
        isValidEmail: true,
        isValidName: false,
        isValidDate: true,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test("should return false when on userData step with invalid date", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.userData,
        isValidEmail: true,
        isValidName: true,
        isValidDate: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test("should return true when on OTPCode step with valid code", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.OTPCode,
        isValidCode: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test("should return false when on OTPCode step with invalid code", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.OTPCode,
        isValidCode: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test("should return true when on passwordScreen step with valid password", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.passwordScreen,
        isValidSignupPassword: true,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test("should return false when on passwordScreen step with invalid password", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.passwordScreen,
        isValidSignupPassword: false,
      );

      expect(notifier.shouldEnableNext(), false);
    });

    test("should return true when on transitionScreen step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.transisionScreen,
      );

      expect(notifier.shouldEnableNext(), true);
    });

    test("should return false for unknown step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 999,
      );

      expect(notifier.shouldEnableNext(), false);
    });
  });

  group("shouldEnableNextLogin Validation Tests", () {
    test("should return true when on step 0 with valid identifier", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
        identifier: "test@example.com",
      );

      expect(notifier.shouldEnableNextLogin(), true);
    });

    test("should return false when on step 0 with invalid identifier", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        currentLoginStep: 0,
        identifier: "invalid-email",
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });

    test("should return true when on step 1 with valid password", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        passwordLogin: "Test1234!",
      );

      expect(notifier.shouldEnableNextLogin(), true);
    });

    test("should return false when on step 1 with invalid password", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        currentLoginStep: 1,
        passwordLogin: "weak",
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });

    test("should return false for unknown login step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        currentLoginStep: 999,
        identifier: "test@example.com",
      );

      expect(notifier.shouldEnableNextLogin(), false);
    });
  });
}