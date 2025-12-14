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