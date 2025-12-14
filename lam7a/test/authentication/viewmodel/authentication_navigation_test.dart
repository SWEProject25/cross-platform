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

  group("Signup Navigation Tests", () {
    test("gotoNextSignupStep should increment step when validations pass", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: true,
        isValidName: true,
        isValidDate: true,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 1);
    });

    test("gotoNextSignupStep should increment when code is valid", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 1,
        isValidCode: true,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 2);
    });

    test("gotoNextSignupStep should increment when password is valid", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidSignupPassword: true,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 3);
    });

    test("gotoNextSignupStep should not increment when at max step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 4,
        isValidSignupPassword: true,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 4);
    });

    test("gotoNextSignupStep should not increment when validations fail", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        isValidEmail: false,
        isValidName: false,
        isValidDate: false,
      );

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 0);
    });

    test("gotoPrevSignupStep should decrement step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(currentSignupStep: 2);

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 1);
    });

    test("gotoPrevSignupStep should reset validations", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 2,
        isValidCode: true,
        isValidSignupPassword: true,
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.isValidCode, false);
      expect(state.isValidSignupPassword, false);
    });

    test("gotoPrevSignupStep should reset to initial state when at step 0", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        currentSignupStep: 0,
        email: "test@example.com",
      );

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 0);
      expect(state.email, "");
    });

    test("gotoNextSignupStep should not change login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 0);

      notifier.gotoNextSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 0);
    });

    test("gotoPrevSignupStep should not change login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 1);

      notifier.gotoPrevSignupStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 1);
    });
  });

  group("Login Navigation Tests", () {
    test("gotoNextLoginStep should increment step when not at max", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 0);

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 1);
    });

    test("gotoNextLoginStep should not increment when at max step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 1);

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 1);
    });

    test("gotoPrevLoginStep should decrement step", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 1);

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 0);
    });

    test("gotoPrevLoginStep should not go below 0", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(currentLoginStep: 0);

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentLoginStep, 0);
    });

    test("gotoNextLoginStep should not change signup state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(currentSignupStep: 0);

      notifier.gotoNextLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 0);
    });

    test("gotoPrevLoginStep should not change signup state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(currentSignupStep: 2);

      notifier.gotoPrevLoginStep();

      final state = container.read(authenticationViewmodelProvider);
      expect(state.currentSignupStep, 2);
    });
    test("should enable next in the first step true", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: true,
        currentSignupStep: 0,
        isValidDate: true,
        isValidName: true,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, true);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: false,
        currentSignupStep: 0,
        isValidDate: true,
        isValidName: true,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: false,
        currentSignupStep: 0,
        isValidDate: false,
        isValidName: true,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: false,
        currentSignupStep: 0,
        isValidDate: false,
        isValidName: false,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: true,
        currentSignupStep: 0,
        isValidDate: false,
        isValidName: true,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: true,
        currentSignupStep: 0,
        isValidDate: false,
        isValidName: false,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
    test("should enable next in the first step false", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(
        isValidEmail: true,
        currentSignupStep: 0,
        isValidDate: true,
        isValidName: false,
      );

      bool answer = notifier.shouldEnableNext();
      expect(answer, false);
    });
  });
}
