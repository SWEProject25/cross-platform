import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthenticationCredentialsModel extends Fake
    implements AuthenticationUserCredentialsModel {}

class FakeAuthentication extends Authentication {
  UserModel? lastAuthenticatedUser;
  int authenticateUserCallCount = 0;

  @override
  AuthState build() {
    return AuthState();
  }

  @override
  void authenticateUser(UserModel? user) {
    lastAuthenticatedUser = user;
    authenticateUserCallCount++;
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

    registerFallbackValue(FakeAuthenticationCredentialsModel());
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

  group("newUser Tests", () {
    test("check user is logged in successfully", () async {
      final mockUser = UserModel(name: 'farouk', email: "far123@example.com");

      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        identifier: "far123@example.com",
        passwordLogin: "Test1234!",
      );

      when(() => authRepoMock.login(any())).thenAnswer((_) async => mockUser);

      bool success = await notifier.login();

      verify(() => authRepoMock.login(any())).called(1);

      expect(fakeAuth.authenticateUserCallCount, 1);
      expect(fakeAuth.lastAuthenticatedUser, mockUser);

      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isLoadingSignup, false);
      expect(success, true);
      // Verify auth state is authenticated
      final authState = container.read(authenticationProvider);
      expect(authState.isAuthenticated, true);
    });

    test("check the same user credentials", () async {
      final mockUser = UserModel(name: "john", email: "john@exmpl.com");

      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        identifier: "far222@example.com",
        passwordLogin: "Test1234!",
      );

      when(() => authRepoMock.login(any())).thenAnswer((_) async => mockUser);

      bool success = await notifier.login();

      final captured = verify(() => authRepoMock.login(captureAny())).captured;
      final capturedModel =
          captured.first as AuthenticationUserCredentialsModel;
      expect(success, false);
      expect(capturedModel.email, "far222@example.com");
      expect(fakeAuth.authenticateUserCallCount, 0);
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.toastMessageLogin, "the email or password is wrong");
    });

    test("should set loading to false when login throws exception", () async {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        identifier: "far@example.com",
        passwordLogin: "Test1234!",
      );

      when(
        () => authRepoMock.login(any()),
      ).thenThrow(Exception('Registration failed'));

      await notifier.login();

            final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.toastMessageLogin, "the email or password is wrong");
      expect(finalState.isLoadingLogin, false);
      expect(fakeAuth.authenticateUserCallCount, 0);
      final authState = container.read(authenticationProvider);
      expect(authState.isAuthenticated, false);
      expect(finalState.toastMessageLogin, "the email or password is wrong");
    });

    test("should not authenticate when user name is null", () async {
      final notifier = getNotifier();

      final mockUser = UserModel(
        name: null, 
        email: "far@example.com",
      );

      notifier.state = const AuthenticationState.login(
        identifier: "far@example.com",
        passwordLogin: "Test1234!",
      );

      when(() => authRepoMock.login(any())).thenAnswer((_) async => mockUser);

      bool success = await notifier.login();

      verify(() => authRepoMock.login(any())).called(1);
      expect(fakeAuth.authenticateUserCallCount, 0);
      expect(success, false);

      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.toastMessageLogin, "the email or password is wrong");
    });
  });
}
