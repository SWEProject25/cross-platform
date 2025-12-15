// coverage:ignore-file
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const AuthenticationState._();
  const factory AuthenticationState.login({
    @Default("") String identifier,
    @Default("") String passwordLogin,
    @Default(0) int currentLoginStep,
    @Default(false) bool isLoadingLogin,
    @Default(false) bool hasCompeletedFollowing,
    @Default(false) bool hasCompeletedInterests,
    String? toastMessageLogin,

  }) = _LoginState;

  const factory AuthenticationState.signup({
    @Default("") String name,
    @Default(false) bool isValidName,
    @Default("") String email,
    @Default(false) bool isValidEmail,
    @Default("") String passwordSignup,
    @Default(false) bool isValidSignupPassword,
    @Default("") String code,
    @Default(false) bool isValidCode,
    @Default("") String username,
    @Default(false) bool isValidUsername,
    @Default("") String date,
    @Default(false) bool isValidDate,
    @Default("") String imgPath,
    @Default(0) int currentSignupStep,
    @Default(false) bool isLoadingSignup,
    @Default(false) bool isNextEnabled,
    @Default(false) bool hasCompeletedFollowingSignUp,
    @Default(false) bool hasCompeletedInterestsSignUp,
    String? toastMessage,
  }) = _SignupState;
  int get currentSignupStep {
    return mapOrNull(
          signup: (signupState) {
            return signupState.currentSignupStep;
          },
        ) ??
        0;
  }

  bool get isLoadingLogin {
    return mapOrNull(
          login: (login) {
            return login.isLoadingLogin;
          },
        ) ??
        false;
  }

  bool get isNextEnabled {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isNextEnabled;
          },
        ) ??
        false;
  }

  int get currentLoginStep {
    return mapOrNull(
          login: (loginstate) {
            return loginstate.currentLoginStep;
          },
        ) ??
        0;
  }

  bool get isValidSignupPassword {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidSignupPassword;
          },
        ) ??
        false;
  }

  bool get isValidName {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidName;
          },
        ) ??
        false;
  }

  bool get isValidEmail {
    return mapOrNull(
          signup: (signupState) {
            print(signupState.isValidEmail);
            return signupState.isValidEmail;
          },
        ) ??
        false;
  }

  bool get isValidDate {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidDate;
          },
        ) ??
        false;
  }

  bool get isValidCode {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidCode;
          },
        ) ??
        false;
  }

  bool get isValidUsername {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidUsername;
          },
        ) ??
        false;
  }

  String get identifier {
    return mapOrNull(
          login: (login) {
            return login.identifier;
          },
        ) ??
        "";
  }
    String? get toastMessage {
    return mapOrNull(
          signup: (signup) {
            return signup.toastMessage;
          },
        ) ??
        null;
  }
      String? get toastMessageLogin {
    return mapOrNull(
          login: (login) {
            return login.toastMessageLogin;
          },
        ) ??
        null;
  }
    String get passwordLogin {
    return mapOrNull(
          login: (login) {
            return login.passwordLogin;
          },
        ) ??
        "";
  }
  bool get isLoadingSignup {
    return mapOrNull(
          signup: (signupState) {
            return signupState.isValidUsername;
          },
        ) ??
        false;
  }

  String get email {
    return mapOrNull(
          signup: (s) {
            return s.email;
          },
        ) ??
        "";
  }

  String get code {
    return mapOrNull(
          signup: (s) {
            return s.code;
          },
        ) ??
        "";
  }

  String get name {
    return mapOrNull(
          signup: (s) {
            return s.name;
          },
        ) ??
        "";
  }

  String get passwordSignup {
    return mapOrNull(
          signup: (s) {
            return s.passwordSignup;
          },
        ) ??
        "";
  }

  String get date {
    return mapOrNull(
          signup: (s) {
            return s.date;
          },
        ) ??
        "";
  }

  bool get hasCompeletedFollowing {
    return mapOrNull(
          login: (loginstate) {
            return loginstate.hasCompeletedFollowing;
          },
        ) ??
        false;
  }
  bool get hasCompeletedInterests {
    return mapOrNull(
          login: (loginstate) {
            return loginstate.hasCompeletedInterests;
          },
        ) ??
        false;
  }
    bool get hasCompeletedFollowingSignUp {
    return mapOrNull(
          signup: (signupState) {
            return signupState.hasCompeletedFollowing;
          },
        ) ??
        false;
  }
  bool get hasCompeletedInterestsSignUp {
    return mapOrNull(
          signup: (signupState) {
            return signupState.hasCompeletedInterests;
          },
        ) ??
        false;
  }
}
