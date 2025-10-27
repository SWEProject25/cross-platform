import 'package:fluttertoast/fluttertoast.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
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

@Riverpod(keepAlive: true)
class AuthenticationViewmodel extends _$AuthenticationViewmodel {
  static const maxSignupScreens = 4;
  static const maxLoginScreens = 1;
  final Validator validator = Validator();
  final repo = AuthenticationRepositoryImpl();

  // the initial state of my state is signup
  @override
  AuthenticationState build() => const AuthenticationState.signup();

  // check for the validation to enable step button
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  bool shouldEnableNext() {
    if (state.currentSignupStep == userData &&
        state.isValidEmail &&
        state.isValidName &&
        state.isValidDate) {
      return true;
    } else if (state.currentSignupStep == OTPCode && state.isValidCode) {
      return true;
    } else if (state.currentSignupStep == passwordScreen &&
        state.isValidSignupPassword) {
      return true;
    } else if (state.currentSignupStep == transisionScreen) {
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
        bool checkValid = await repo.checkEmail(state.email, ref);
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isValidEmail: checkValid),
        );
        if (checkValid) {
          //generate otp and send it to user email
          final genrateStatus = await repo.verificationOTP(state.email, ref);
          if (genrateStatus) {
            state = state.map(
              login: (login) => login,
              signup: (signup) => signup.copyWith(isLoadingSignup: false),
            );
            gotoNextSignupStep();
            showToastMessage("code sent to your email");
          }
        } else {
          showToastMessage("this email is already taken");
          state = state.map(
            login: (login) => login,
            signup: (signup) => AuthenticationState.signup(),
          );
        }
      }
    } catch (e) {
      print(e);
      showToastMessage("this email is already taken");
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
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
        bool isValidCode = await repo.verifyOTP(state.email, state.code, ref);
        if (isValidCode) {
          gotoNextSignupStep();
        } else {
          showToastMessage("the code is wrong");
        }
        state = state.map(
          login: (login) => login,
          signup: (signup) =>
              signup.copyWith(isValidCode: isValidCode, isLoadingSignup: false),
        );
      }
    } catch (e) {
      print(e);
          showToastMessage("the code is wrong");
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
      );
    }
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  //TO DO need to implement and test this
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<void> resendOTP() async {
    bool isSuccessed = await repo.resendOTP(state.email, ref);
    if (!isSuccessed) {
      showToastMessage("this service isn't available now");
    } else {
      showToastMessage("the code is sent to your accont");
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
        UserModel user = await repo.register(
          AuthenticationUserDataModel(
            name: state.name,
            email: state.email,
            password: state.passwordSignup,
            birth_date: state.date,
          ),
          ref,
        );
        if (user != null) {
          final authController = ref.watch(authenticationProvider.notifier);

          showToastMessage("user signed up successfully");
          await authController.authenticateUser("success", user);
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
      case userData:
        checkValidEmail();
        break;
      case OTPCode:
        checkValidCode();
        break;
      case passwordScreen:
        await newUser();
    }
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
      UserModel? myUser = await repo.login(
        AuthenticationUserCredentialsModel(
          email: state.identifier,
          password: state.passwordLogin,
        ),
        ref,
      );
      if (myUser.name != null) {
        final authController = ref.watch(authenticationProvider.notifier);
        await authController.authenticateUser("success", myUser);
        final authState = ref.watch(authenticationProvider);
        print(myUser);
        state = state.map(
          login: (login) => login.copyWith(
            identifier: "",
            passwordLogin: "",
            isLoadingLogin: false,
          ),
          signup: (signup) => signup.copyWith(email: "", passwordSignup: ""),
        );
        isSuccessed = true;
      } else {
        showToastMessage("the email or password is wrong");
      }
      state = state.map(
        login: (login) => login.copyWith(isLoadingLogin: false),
        signup: (signup) => signup,
      );
      return isSuccessed;
    } catch (e) {
      print(e);
      showToastMessage("the email or password is wrong");
      state = state.map(
        login: (login) => login.copyWith(isLoadingLogin: false),
        signup: (signup) => signup,
      );
      return false;
    }
  }
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  void logout() {
    final authController = ref.watch(authenticationProvider);
    authController.logout();
  }

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
            currentSignupStep: signupState.currentSignupStep + 1,
          );
        }
        return signupState;
      },
    );
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
  bool shouldEnableNextLogin()
  {
    if (state.currentLoginStep == 0 && validator.validateEmail(state.identifier))
    {
      return true;
    }
    else if (state.currentLoginStep == 1 && validator.validatePassword(state.passwordLogin))
    {
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
