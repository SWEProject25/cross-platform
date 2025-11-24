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

  group("newUser Tests", () {
    test("should register user successfully when validations pass", () async {
      final mockUser = UserModel(
        name: 'farouk',
        email: "far222@example.com",
      );
      
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        code: "",
        isValidCode: true,
        isValidEmail: true,
        name: "farouk",
        email: "far222@example.com",
        isValidDate: true,
        isLoadingSignup: false,
        username: "fa1234",
        passwordSignup: "Test1234!",
        isValidName: true,
        date: "20-11-2003",
        imgPath: "/path",
      );
      
      when(() => authRepoMock.register(any()))
          .thenAnswer((_) async => mockUser);
      
      await notifier.newUser();
      
      verify(() => authRepoMock.register(any())).called(1);
      
      expect(fakeAuth.authenticateUserCallCount, 1);
      expect(fakeAuth.lastAuthenticatedUser, mockUser);
      
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isLoadingSignup, false);
      
      final authState = container.read(authenticationProvider);
      expect(authState.isAuthenticated, true);
    });

    test("should verify correct data is passed to register", () async {
      final mockUser = UserModel(
        name: 'John Doe',
        email: 'john@example.com',
      );
      
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        name: "farouk",
        email: "far222@example.com",
        passwordSignup: "Test1234!",
        date: "20-11-2003",
        isValidCode: true,
        isValidEmail: true,
      );
      
      when(() => authRepoMock.register(any()))
          .thenAnswer((_) async => mockUser);
      
      await notifier.newUser();
      
      final captured = verify(() => authRepoMock.register(captureAny())).captured;
      final capturedModel = captured.first as AuthenticationUserDataModel;
      
      expect(capturedModel.name, "farouk");
      expect(capturedModel.email, "far222@example.com");
      expect(capturedModel.password, "Test1234!");
      expect(capturedModel.birthDate, "20-11-2003");
    });

    test("should set loading to false when registration throws exception", () async {
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        isValidCode: true,
        isValidEmail: true,
      );
      
      when(() => authRepoMock.register(any()))
          .thenThrow(Exception('Registration failed'));
      
      await notifier.newUser();
      
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isLoadingSignup, false);
      expect(fakeAuth.authenticateUserCallCount, 0);
      final authState = container.read(authenticationProvider);
      expect(authState.isAuthenticated, false);
    });

    test("should not register when isValidCode is false", () async {
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        isValidCode: false,
        isValidEmail: true,
      );
      
      await notifier.newUser();
      
      verifyNever(() => authRepoMock.register(any()));
      expect(fakeAuth.authenticateUserCallCount, 0);
    });

    test("should not authenticate when user is null", () async {
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        isValidCode: true,
        isValidEmail: true,
      );
      
      when(() => authRepoMock.register(any()))
          .thenAnswer((_) async => null);
      
      await notifier.newUser();
      
      verify(() => authRepoMock.register(any())).called(1);
      expect(fakeAuth.authenticateUserCallCount, 0);
      expect(fakeAuth.lastAuthenticatedUser, null);
    });
  });
}