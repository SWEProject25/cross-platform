import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
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

// Create a Fake Authentication class that extends the real one
class FakeAuthentication extends Authentication {
  // Track calls for verification
  UserModel? lastAuthenticatedUser;
  int authenticateUserCallCount = 0;

  @override
  AuthState build() {
    // Return initial unauthenticated state
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

  Future<void> isAuthenticated() async {
    // try {
    //   final response = await _apiService.get(
    //     endpoint: ServerConstant.profileMe,
    //   );
    //   print(response['data']);
    //   if (response['data'] != null) {
    //     UserDtoAuth user = UserDtoAuth.fromJson(response['data']);
    //     print("this is my user ${user}");
    //     authenticateUser(user);
    //   }
    // } catch (e) {
    //   print(e);
    // }
    authenticateUserCallCount++;
    state = state.copyWith(
      token: null,
      isAuthenticated: true,
      user: lastAuthenticatedUser,
    );
  }

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
        // Override with the fake implementation
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

  group("checkValidEmail Tests", () {
    test("check a new email ant the otpcode is sent", () async {
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
      int lastIdx = 0;
      when(() => authRepoMock.checkEmail(any())).thenAnswer((_) async => true);
      when(
        () => authRepoMock.verificationOTP(any()),
      ).thenAnswer((_) async => true);
      // Act
      await notifier.checkValidEmail();

      // Assert
      verify(() => authRepoMock.checkEmail(any())).called(1);
      verify(() => authRepoMock.verificationOTP(any())).called(1);
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isValidEmail, true);
      expect(finalState.currentSignupStep, 1);
    });

    test("check for exist email", () async {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        name: "farouk",
        email: "far222@example.com",
        passwordSignup: "Test1234!",
        date: "20-11-2003",
        isValidCode: true,
        isValidEmail: true,
      );

      when(() => authRepoMock.checkEmail(any())).thenAnswer((_) async => false);

      await notifier.checkValidEmail();
      final finalState = container.read(authenticationViewmodelProvider);
      expect(finalState.isValidEmail, false);
      expect(finalState.currentSignupStep, 0);
      expect(
        finalState.toastMessage,
        AuthenticationConstants.errorEmailMessage,
      );
    });

    test(
      "should set loading to false when registration throws exception",
      () async {
        final notifier = getNotifier();

        notifier.state = const AuthenticationState.signup(isValidEmail: true);

        when(
          () => authRepoMock.checkEmail(any()),
        ).thenThrow(Exception('Registration failed'));

        await notifier.checkValidEmail();

        final finalState = container.read(authenticationViewmodelProvider);
      },
    );
  });
}
