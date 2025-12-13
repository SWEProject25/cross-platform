import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/model/user_dto_model.dart';
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

  group("registrationProgress Tests", () {
    test("should call checkValidEmail when on userData step", () async {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.userData,
        isValidEmail: true,
        name: "farouk",
        email: "far222@example.com",
        date: "20-11-2003",
        isValidDate: true,
        isValidName: true,
      );

      when(() => authRepoMock.checkEmail(any())).thenAnswer((_) async => true);
      when(() => authRepoMock.verificationOTP(any())).thenAnswer((_) async => true);

      await notifier.registrationProgress();

      verify(() => authRepoMock.checkEmail(any())).called(1);
      verify(() => authRepoMock.verificationOTP(any())).called(1);
    });

    test("should call checkValidCode when on OTPCode step", () async {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.OTPCode,
        isValidCode: true,
        email: "far222@example.com",
        code: "123456",
      );

      when(() => authRepoMock.verifyOTP(any(), any())).thenAnswer((_) async => true);

      await notifier.registrationProgress();

      verify(() => authRepoMock.verifyOTP(any(), any())).called(1);
    });

    test("should call newUser when on passwordScreen step", () async {
      final mockUser = UserModel(name: 'farouk', email: "far222@example.com");
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: AuthenticationConstants.passwordScreen,
        isValidCode: true,
        isValidEmail: true,
        name: "farouk",
        email: "far222@example.com",
        passwordSignup: "Test1234!",
        date: "20-11-2003",
      );

      when(() => authRepoMock.register(any())).thenAnswer((_) async => User(
            id: 123,
            username: "name",
            email: "far123@exmple.com",
            role: "User",
            profile: Profile(name: "faroukk", profileImageUrl: "/img"),
          ),);

      await notifier.registrationProgress();

      verify(() => authRepoMock.register(any())).called(1);
    });
  });
}