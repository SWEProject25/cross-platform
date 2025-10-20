import 'package:flutter/material.dart';
import 'package:lam7a/features/authentication/ui/state/signup_flow_state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login/password_login.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier/unique_identifier.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/password/password_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_data/user_data.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_name_screen/user_name_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/verification_code/verification_code.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/validator.dart';
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
  @override
  AuthenticationState build() => const AuthenticationState.signup();
  void gotoNextSignupStep() {
    state = state.map(
      login: (loginState) => loginState,
      signup: (signupState) {
        if (signupState.currentSignupStep < maxSignupScreens &&
(            state.isValidEmail &&
            state.isValidName &&
            state.isValidDate)
            || (state.isValidCode) || (state.isValidSignupPassword))
          return signupState.copyWith(
            currentSignupStep: signupState.currentSignupStep + 1,
          );
        return signupState;
      },
    );
  }
  void changeToLogin()
  {
    state = AuthenticationState.login();
  }
  void changeToSignup()
  {
    state = AuthenticationState.signup();
  }

  void gotoPrevSignupStep() {
    state = state.map(
      login: (loginState) => loginState,
      signup: (signupState) {
        if (signupState.currentSignupStep > 0)
          return signupState.copyWith(
            currentSignupStep: signupState.currentSignupStep - 1,
          );
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
        if (loginState.currentLoginStep < maxLoginScreens)
          return loginState.copyWith(
            currentLoginStep: loginState.currentLoginStep + 1,
          );
        return loginState;
      },
    );
  }

  void gotoPrevLoginStep() {
    state = state.map(
      signup: (signupState) {
        return signupState;
      },
      login: (loginState) {
        if (loginState.currentLoginStep > 0)
          return loginState.copyWith(
            currentLoginStep: loginState.currentLoginStep - 1,
          );
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
        print(signup.isValidEmail);
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
          name: code,
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
          isValidSignupPassword: validator.validateName(password),
        );
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
