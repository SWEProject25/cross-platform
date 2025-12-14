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
              // Verify auth state is authenticated
toastMessage: "Some error message",
      );      // Verify auth state is authenticated


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