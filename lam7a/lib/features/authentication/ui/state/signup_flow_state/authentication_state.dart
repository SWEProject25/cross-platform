import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const AuthenticationState._();
  const factory AuthenticationState.login({
    @Default("") String identifier,
    @Default("") String passwordLogin,
    @Default(0) int currentLoginStep,
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
  }) = _SignupState;
  int get currentSignupStep {
    return mapOrNull(
          signup: (signupState) {
            return signupState.currentSignupStep;
          },
        ) ??
        0;
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

  // bool get isValidSignupPassword => isValidSignupPassword;
}
