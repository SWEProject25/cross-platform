import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
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

  group("State Management Tests", () {
    test("should change state to login", () {
      final notifier = getNotifier();

      notifier.changeToLogin();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.maybeMap(login: (_) => true, orElse: () => false), true);
    });

    test("should change state to signup", () {
      final notifier = getNotifier();

      notifier.changeToLogin();
      notifier.changeToSignup();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.maybeMap(signup: (_) => true, orElse: () => false), true);
    });

    test("clearMessage should clear toast message", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        toastMessage: "Some error message",
      );

      notifier.clearMessage();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.toastMessage, null);
    });

    test("goToHome should reset login step to 0", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 1);

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 0);
    });

    test("goToHome should reset signup step to 0", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(currentSignupStep: 2);

      notifier.goToHome();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 0);
    });
  });
}