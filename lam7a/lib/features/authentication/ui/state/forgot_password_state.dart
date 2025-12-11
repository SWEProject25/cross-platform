import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_state.freezed.dart';

@freezed
abstract class ForgotPasswordState with _$ForgotPasswordState {
  const ForgotPasswordState._();
  const factory ForgotPasswordState({
    @Default(0) int currentForgotPasswordStep,
    @Default("") String email,
    @Default(false) bool isValidEmail,
    @Default(false) bool isValidPassword,
    @Default(false) bool isValidRePassword,
    @Default("") String password,
    @Default("") String reTypePassword
  }) = _ForgotPasswordState;
}

