import 'package:fluttertoast/fluttertoast.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/model/user_dto_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'authentication_viewmodel.g.dart';

/////////////////////////////////////////////////////////////////////////
void showToastMessage(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Pallete.toastBgColor,
    textColor: Pallete.toastColor,
  );
}

@riverpod
class AuthenticationViewmodel extends _$AuthenticationViewmodel {
  static const maxSignupScreens = 4;
  static const maxLoginScreens = 1;
  final Validator validator = Validator();
  late AuthenticationRepositoryImpl repo;
  late Authentication authController;
  // the initial state of my state is signup
  @override
  AuthenticationState build() {
    repo = ref.read(authenticationImplRepositoryProvider);
    authController = ref.read(authenticationProvider.notifier);
    return const AuthenticationState.signup();
  }

  // check for the validation to enable step button
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  bool shouldEnableNext() {
    if (state.currentSignupStep == AuthenticationConstants.userData &&
        state.isValidEmail &&
        state.isValidName &&
        state.isValidDate) {
      return true;
    } else if (state.currentSignupStep == AuthenticationConstants.OTPCode &&
        state.isValidCode) {
      return true;
    } else if (state.currentSignupStep ==
            AuthenticationConstants.passwordScreen &&
        state.isValidSignupPassword) {
      return true;
    } else if (state.currentSignupStep ==
        AuthenticationConstants.transisionScreen) {
      return true;
    }
    return false;
  }

  ////////////////////////////////////////////////////
  ///        Registration Steps                    ///
  ///////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  // check for email if it exists in data base and call the generate otp method from backend
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> checkValidEmail() async {
    try {
      if (state.isValidEmail) {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: true),
        );
        bool checkValid = await repo.checkEmail(state.email);
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isValidEmail: checkValid),
        );
        if (checkValid) {
          //generate otp and send it to user email
          final genrateStatus = await repo.verificationOTP(state.email);
          if (genrateStatus) {
            state = state.map(
              login: (login) => login,
              signup: (signup) => signup.copyWith(
                isLoadingSignup: false,
                toastMessage: AuthenticationConstants.otpSentMessage,
              ),
            );
            gotoNextSignupStep();
          }
        } else {
          state = state.map(
            login: (login) => login,
            signup: (signup) => AuthenticationState.signup(
              toastMessage: AuthenticationConstants.errorEmailMessage,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
      // showToastMessage("this email is already taken");
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(
          isLoadingSignup: false,
          toastMessage: AuthenticationConstants.errorEmailMessage,
        ),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  // check the validation of the typed otp code from the user and then allow him to continue
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> checkValidCode() async {
    try {
      if (state.isValidCode) {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: true),
        );
        bool isValidCode = await repo.verifyOTP(state.email, state.code);
        if (isValidCode) {
          gotoNextSignupStep();
        } else {
          state = state.map(
            login: (login) => login,
            signup: (signup) => signup.copyWith(
              toastMessage: AuthenticationConstants.wrongOtpMessage,
            ),
          );
        }
        state = state.map(
          login: (login) => login,
          signup: (signup) =>
              signup.copyWith(isValidCode: isValidCode, isLoadingSignup: false),
        );
      }
    } catch (e) {
      print(e);
      // showToastMessage("the code is wrong");
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(
          isLoadingSignup: false,
          toastMessage: AuthenticationConstants.wrongOtpMessage,
        ),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  //TO DO need to implement and test this
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> resendOTP() async {
    try {
      bool isSuccessed = await repo.resendOTP(state.email);
      if (!isSuccessed) {
        state = state.map(
          login: (login) => login,
          signup: (signup) =>
              signup.copyWith(toastMessage: "this service isn't available"),
        );
      } else {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(
            isLoadingSignup: false,
            toastMessage: AuthenticationConstants.otpSentMessage,
          ),
        );
      }
    } catch (e) {
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(
          isLoadingSignup: false,
          toastMessage: "this service isn't available",
        ),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  // register the user to data base and add him
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> newUser() async {
    try {
      if (state.isValidCode && state.isValidEmail) {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: true),
        );
        User? user = await repo.register(
          AuthenticationUserDataModel(
            name: state.name,
            email: state.email,
            password: state.passwordSignup,
            birthDate: state.date,
          ),
        );
        if (user != null) {
          // showToastMessage("user signed up successfully");
          authController.authenticateUser(user.mapToUserDtoAuth());
        }
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: false),
        );
      }
    } catch (e) {
      print(e);
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> registrationProgress() async {
    switch (state.currentSignupStep) {
      case AuthenticationConstants.userData:
        await checkValidEmail();
        break;
      case AuthenticationConstants.OTPCode:
        await checkValidCode();
        break;
      case AuthenticationConstants.passwordScreen:
        await newUser();
        break;
    }
  }

  void clearMessage() {
    state = state.map(
      login: (login) => login,
      signup: (signup) {
        return signup.copyWith(toastMessage: null);
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  //      this is the code of login authentication
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<bool> login() async {
    try {
      bool isSuccessed = false;
      state = state.map(
        login: (login) => login.copyWith(isLoadingLogin: true),
        signup: (signup) => signup,
      );
      RootData? myData = await repo.login(
        AuthenticationUserCredentialsModel(
          email: state.identifier,
          password: state.passwordLogin,
        ),
      );
      if (myData.user.username != null &&
          myData.user.email == state.identifier) {
        authController.authenticateUser(myData.user.mapToUserDtoAuth());
        print("user status");
        print(myData.onboardingStatus.hasCompeletedInterests.toString());
        print(myData.onboardingStatus.hasCompeletedFollowing.toString());
        print("user status");

        state = state.map(
          login: (login) => login.copyWith(
            identifier: "",
            passwordLogin: "",
            isLoadingLogin: false,
            hasCompeletedFollowing:
                myData.onboardingStatus.hasCompeletedFollowing,
            hasCompeletedInterests:
                myData.onboardingStatus.hasCompeletedInterests,
          ),
          signup: (signup) => signup.copyWith(email: "", passwordSignup: ""),
        );
        isSuccessed = true;
      } else {
        state = state.map(
          login: (login) => login.copyWith(
            toastMessageLogin: "the email or password is wrong",
            isLoadingLogin: false
          ),
          signup: (signup) => signup,
        );
      }
      return isSuccessed;
    } catch (e) {
      print(e);
      // showToastMessage("the email or password is wrong");
      state = state.map(
        login: (login) => login.copyWith(
          isLoadingLogin: false,
          toastMessageLogin: "the email or password is wrong",
        ),
        signup: (signup) => signup,
      );
      return false;
    }
  }
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  void gotoNextSignupStep() {
    state = state.map(
      login: (loginState) => loginState,
      signup: (signupState) {
        if (signupState.currentSignupStep < maxSignupScreens &&
                (state.isValidEmail &&
                    state.isValidName &&
                    state.isValidDate) ||
            (state.isValidCode) ||
            (state.isValidSignupPassword)) {
          return signupState.copyWith(
            currentSignupStep: signupState.currentSignupStep == maxSignupScreens
                ? signupState.currentSignupStep
                : signupState.currentSignupStep + 1,
          );
        }
        return signupState;
      },
    );
  }
  Future<String> oAuthLoginRedirect() async {
    String html = await repo.oAuthGoogleRedirect();
    return html;
  }

  ///////////////////////////////////////////////
  ///    this part is to manage my state       //
  ///////////////////////////////////////////////
  void changeToLogin() {
    state = AuthenticationState.login();
  }

  void changeToSignup() {
    state = AuthenticationState.signup();
  }

  ////////////////////////////////////////////////////////////////////////
  void gotoPrevSignupStep() {
    state = state.map(
      login: (loginState) => loginState,
      signup: (signupState) {
        if (signupState.currentSignupStep > 0) {
          return signupState.copyWith(
            currentSignupStep: signupState.currentSignupStep - 1,
            isValidSignupPassword: false,
            isValidCode: false,
          );
        } else {
          return AuthenticationState.signup();
        }
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
  bool shouldEnableNextLogin() {
    if (state.currentLoginStep == 0 &&
        validator.validateEmail(state.identifier)) {
      return true;
    } else if (state.currentLoginStep == 1 &&
        validator.validatePassword(state.passwordLogin)) {
      return true;
    }
    return false;
  }

  void gotoNextLoginStep() {
    state = state.map(
      signup: (signupState) {
        return signupState;
      },
      login: (loginState) {
        if (loginState.currentLoginStep < maxLoginScreens) {
          return loginState.copyWith(
            currentLoginStep: loginState.currentLoginStep + 1,
          );
        }
        return loginState;
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
  void gotoPrevLoginStep() {
    state = state.map(
      signup: (signupState) {
        return signupState;
      },
      login: (loginState) {
        if (loginState.currentLoginStep > 0) {
          return loginState.copyWith(
            currentLoginStep: loginState.currentLoginStep - 1,
          );
        }
        return loginState;
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
  void goToHome() {
    state = state.map(
      login: (loginState) {
        return loginState.copyWith(currentLoginStep: 0);
      },
      signup: (signupState) {
        return signupState.copyWith(currentSignupStep: 0);
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateName(String name) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        return signup.copyWith(
          name: name,
          isValidName: validator.validateName(name),
        );
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateEmail(String email) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        signup = signup.copyWith(
          email: email,
          isValidEmail: validator.validateEmail(email),
        );
        return signup;
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateDateTime(String date) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        return signup.copyWith(
          date: date,
          isValidDate: validator.validateDate(date),
        );
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateVerificationCode(String code) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        return signup.copyWith(
          code: code,
          isValidCode: validator.validateCode(code),
        );
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateUserName(String name) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        return signup.copyWith(
          username: name,
          isValidUsername: validator.validateName(name),
        );
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updatePassword(String password) {
    state = state.map(
      login: (login) {
        return login;
      },
      signup: (signup) {
        return signup.copyWith(
          passwordSignup: password,
          isValidSignupPassword: validator.validatePassword(password),
        );
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updatePasswordLogin(String password) {
    state = state.map(
      signup: (signup) {
        return signup;
      },
      login: (login) {
        return login.copyWith(passwordLogin: password);
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////

  void updateIdentifier(String identifier) {
    state = state.map(
      signup: (signup) {
        return signup;
      },
      login: (login) {
        return login.copyWith(identifier: identifier);
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////
