import 'package:flutter/material.dart';
import 'package:lam7a/features/authentication/model/user_credential_model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/user_data_model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_repository.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_password_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_user_data_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/user_name_screen/user_name_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_otp_code_Step.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'authentication_viewmodel.g.dart';

@riverpod
List<Widget> signUpFlow(Ref ref) {
  return [
    UserDataSignUp(),
    VerificationCode(),
    PasswordScreen(),
    ProfilePicture(),
    UserNameScreen(),
  ];
}

@riverpod
List<Widget> loginFlow(Ref ref) {
  return [UniqueIdentifier(), PasswordLogin()];
}

@riverpod
class AuthenticationViewmodel extends _$AuthenticationViewmodel {
  static const maxSignupScreens = 4;
  static const maxLoginScreens = 1;
  final Validator validator = Validator();
  final repo = AuthenticationRepository();
  
  // the initial state of my state is signup
  @override
  AuthenticationState build() => const AuthenticationState.signup();
  
  // check for the validation to enable step button
  bool enableNext() {
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
        }
      return false;
  }

  // check for email if it exists in data base and call the generate otp method from backend
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
        if (state.isValidEmail) {
          final genrateStatus = await repo.verificationOTP(state.email);
          state = state.map(
            login: (login) => login,
            signup: (signup) => signup.copyWith(isLoadingSignup: false),
          );
          gotoNextSignupStep();
        } else {
          state = state.map(
            login: (login) => login,
            signup: (signup) => signup.copyWith(isLoadingSignup: false),
          );
        }
      }
    } catch (e) {
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
      );
    }
  }

  // check the validation of the typed otp code from the user and then allow him to continue
  Future<void> checkValidCode() async {
    try {
      if (state.isValidCode) {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: true),
        );
        bool isValidCode = await repo.verifyOTP(state.email, state.code);
        state = state.map(
          login: (login) => login,
          signup: (signup) =>
              signup.copyWith(isValidCode: isValidCode, isLoadingSignup: false),
        );
        if (state.isValidCode) {
          gotoNextSignupStep();
        }
      }
    } catch (e) {
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
      );
    }
  }
  // register the user to data base and add him
  Future<void> newUser() async {
    try {
      if (state.isValidCode && state.isValidEmail) {
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: true),
        );
        int message = await repo.register(
          AuthenticationUserDataModel(
            name: state.name,
            email: state.email,
            password: state.passwordSignup,
            birth_date: state.date,
          ),
        );
        state = state.map(
          login: (login) => login,
          signup: (signup) => signup.copyWith(isLoadingSignup: false),
        );
        if (message < 300) {
          gotoNextSignupStep();
        }
      }
    } catch (e) {
      state = state.map(
        login: (login) => login,
        signup: (signup) => signup.copyWith(isLoadingSignup: false),
      );
    }
  }

  void registrationProgress() {
    switch (state.currentSignupStep) {
      case userData:
        checkValidEmail();
        break;
      case OTPCode:
        checkValidCode();
        break;
      case passwordScreen:
        newUser();
        break;
    }
  }

  //this is the code of login authentication
  //TO DO need to revisit for some editing
  void login() async {
    state = state.map(
      login: (login) => login.copyWith(isLoadingLogin: true),
      signup: (signup) => signup,
    );
    int status = await repo.login(
      AuthenticationUserCredentialsModel(
        email: state.identifier,
        password: state.passwordLogin,
      ),
    );
    state = state.map(
      login: (login) => login.copyWith(isLoadingLogin: false),
      signup: (signup) => signup,
    );
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
////////////////////////////////////////////
  void gotoPrevSignupStep() {
    state = state.map(
      login: (loginState) => loginState,
      signup: (signupState) {
        if (signupState.currentSignupStep > 0) {
          return signupState.copyWith(
            currentSignupStep: signupState.currentSignupStep - 1,
          );
        }
        return signupState;
      },
    );
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
