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

  group("Update Methods Tests", () {
    test("updateName should update name and validation state", () {
      final notifier = getNotifier();

      notifier.updateName("John Doe");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, "John Doe");
      expect(state.isValidName, true);
    });

    test("updateName should set isValidName to false for invalid name", () {
      final notifier = getNotifier();

      notifier.updateName("");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.name, "");
      expect(state.isValidName, false);
    });

    test("updateName should not affect login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(identifier: "test@example.com");

      notifier.updateName("John Doe");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, "test@example.com");
    });

    test("updateEmail should update email and validation state", () {
      final notifier = getNotifier();

      notifier.updateEmail("test@example.com");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.email, "test@example.com");
      expect(state.isValidEmail, true);
    });

    test("updateEmail should set isValidEmail to false for invalid email", () {
      final notifier = getNotifier();

      notifier.updateEmail("invalid-email");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.email, "invalid-email");
      expect(state.isValidEmail, false);
    });

    test("updateEmail should not affect login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(identifier: "test@example.com");

      notifier.updateEmail("new@example.com");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, "test@example.com");
    });

    test("updateDateTime should update date and validation state", () {
      final notifier = getNotifier();

      notifier.updateDateTime("15-05-2000");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.date, "15-05-2000");
      expect(state.isValidDate, true);
    });

    test("updateDateTime should set isValidDate to false for invalid date", () {
      final notifier = getNotifier();

      notifier.updateDateTime("");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.date, "");
      expect(state.isValidDate, false);
    });

    test("updateDateTime should not affect login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(identifier: "test@example.com");

      notifier.updateDateTime("15-05-2000");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, "test@example.com");
    });

    test("updateVerificationCode should update code and validation state", () {
      final notifier = getNotifier();

      notifier.updateVerificationCode("123456");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.code, "123456");
      expect(state.isValidCode, true);
    });

    test("updateVerificationCode should set isValidCode to false for invalid code", () {
      final notifier = getNotifier();

      notifier.updateVerificationCode("");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.code, "");
      expect(state.isValidCode, false);
    });

    test("updateVerificationCode should not affect login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(identifier: "test@example.com");

      notifier.updateVerificationCode("123456");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, "test@example.com");
    });


 
    test("updatePassword should update password and validation state", () {
      final notifier = getNotifier();

      notifier.updatePassword("Test1234!");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordSignup, "Test1234!");
      expect(state.isValidSignupPassword, true);
    });

    test("updatePassword should set isValidSignupPassword to false for invalid password", () {
      final notifier = getNotifier();

      notifier.updatePassword("weak");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordSignup, "weak");
      expect(state.isValidSignupPassword, false);
    });

    test("updatePassword should not affect login state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login(
        identifier: "test@example.com",
        passwordLogin: "oldpassword",
      );

      notifier.updatePassword("Test1234!");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordLogin, "oldpassword");
    });

    test("updatePasswordLogin should update login password", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login();

      notifier.updatePasswordLogin("Test1234!");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordLogin, "Test1234!");
    });

    test("updatePasswordLogin should not affect signup state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(passwordSignup: "oldpassword");

      notifier.updatePasswordLogin("Test1234!");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.passwordSignup, "oldpassword");
    });

    test("updateIdentifier should update login identifier", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.login();

      notifier.updateIdentifier("test@example.com");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.identifier, "test@example.com");
    });

    test("updateIdentifier should not affect signup state", () {
      final notifier = getNotifier();

      notifier.state = const AuthenticationState.signup(email: "signup@example.com");

      notifier.updateIdentifier("login@example.com");

      final state = container.read(authenticationViewmodelProvider);
      expect(state.email, "signup@example.com");
    });
  });
}