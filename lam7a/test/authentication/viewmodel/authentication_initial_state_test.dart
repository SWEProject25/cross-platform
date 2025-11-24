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

  group("Initial State Tests", () {
    test("should initialize with signup state", () {
      final state = container.read(authenticationViewmodelProvider);

      expect(state.maybeMap(signup: (_) => true, orElse: () => false), true);
    });

    test("should have currentSignupStep as 0 initially", () {
      final state = container.read(authenticationViewmodelProvider);

      expect(state.currentSignupStep, 0);
    });

    test("should initialize repository and auth controller", () {
      final notifier = container.read(authenticationViewmodelProvider.notifier);
      
      container.read(authenticationViewmodelProvider);

      expect(notifier.repo, isA<AuthenticationRepositoryImpl>());
      expect(notifier.authController, isA<Authentication>());
    });

    test("should initialize validator", () {
      final notifier = container.read(authenticationViewmodelProvider.notifier);
      
      expect(notifier.validator, isNotNull);
    });

    test("should have correct maxSignupScreens constant", () {
      expect(AuthenticationViewmodel.maxSignupScreens, 4);
    });

    test("should have correct maxLoginScreens constant", () {
      expect(AuthenticationViewmodel.maxLoginScreens, 1);
    });
  });
}