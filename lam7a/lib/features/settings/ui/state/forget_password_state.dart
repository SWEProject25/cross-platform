import 'package:flutter/material.dart';
import '../../utils/validators.dart';

class ForgetPasswordState {
  final String otpCode;
  final TextEditingController newPasswordController;
  final TextEditingController newPasswordAgainController;
  final FocusNode newFocus;
  final FocusNode againFocus;
  final bool? isValid;
  final String? newPasswordError;
  final String? againPasswordError;
  final String? errorMessage;
  final PasswordStrength? passwordStrength;

  const ForgetPasswordState({
    this.otpCode = '',
    required this.newPasswordController,
    required this.newPasswordAgainController,
    required this.newFocus,
    required this.againFocus,
    this.isValid = false,
    this.newPasswordError,
    this.againPasswordError,
    this.errorMessage,
    this.passwordStrength,
  });

  ForgetPasswordState copyWith({
    String? otpCode,
    TextEditingController? newPasswordController,
    TextEditingController? newPasswordAgainController,
    FocusNode? newFocus,
    FocusNode? againFocus,
    bool? isValid,
    String? newPasswordError,
    String? againPasswordError,
    String? errorMessage,
    PasswordStrength? passwordStrength,
  }) {
    return ForgetPasswordState(
      otpCode: otpCode ?? this.otpCode,
      newPasswordController:
          newPasswordController ?? this.newPasswordController,
      newPasswordAgainController:
          newPasswordAgainController ?? this.newPasswordAgainController,
      newFocus: newFocus ?? this.newFocus,
      againFocus: againFocus ?? this.againFocus,
      isValid: isValid,
      newPasswordError: newPasswordError,
      againPasswordError: againPasswordError,
      errorMessage: errorMessage,
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }
}
