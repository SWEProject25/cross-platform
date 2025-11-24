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

  group("checkValidCode Tests", () {
    test("check the otpcode is valid", () async {
      
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
      when(() => authRepoMock.checkEmail(any()))
          .thenAnswer((_) async => true);
      when(() => authRepoMock.verifyOTP(any(), any())).thenAnswer((_) async => true);
      await notifier.checkValidCode();
      
      verify(() => authRepoMock.verifyOTP(any(), any())).called(1);
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isLoadingSignup, false);
      expect(finalState.currentSignupStep, 1);
    });

    test("check for Wrong otpCode", () async {

      
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        name: "farouk",
        email: "far222@example.com",
        passwordSignup: "Test1234!",
        date: "20-11-2003",
        isValidCode: true,
        isValidEmail: true,
      );
      
      when(() => authRepoMock.verifyOTP(any(), any()))
          .thenAnswer((_) async => false);
      
      await notifier.checkValidCode();
      verify(() => authRepoMock.verifyOTP(any(), any())).called(1);
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.currentSignupStep, 0);
      expect(finalState.toastMessage, AuthenticationConstants.wrongOtpMessage);
    });

  

    test("should set loading to false when registration throws exception", () async {
      final notifier = getNotifier();
      
      notifier.state = const AuthenticationState.signup(
        isValidEmail: true,
        isValidCode: true
      );
      
      when(() => authRepoMock.verifyOTP(any(), any()))
          .thenThrow(Exception('Registration failed'));
      
      await notifier.checkValidCode();
      
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.toastMessage, AuthenticationConstants.wrongOtpMessage);
      expect(finalState.isLoadingSignup, false);
      expect(finalState.currentSignupStep, 0);
    });

  });

}