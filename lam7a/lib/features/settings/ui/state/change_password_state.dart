import 'package:flutter/material.dart';

class ChangePasswordState {
  final TextEditingController currentController;
  final TextEditingController newController;
  final TextEditingController confirmController;
  final FocusNode newFocus;
  final FocusNode confirmFocus;
  final bool isValid;
  final String? newPasswordError;
  final String? confirmPasswordError;
  final String? errorMessage;

  const ChangePasswordState({
    required this.currentController,
    required this.newController,
    required this.confirmController,
    required this.newFocus,
    required this.confirmFocus,
    this.isValid = false,
    this.newPasswordError,
    this.confirmPasswordError,
    this.errorMessage,
  });

  ChangePasswordState copyWith({
    bool? isValid,
    String? newPasswordError,
    String? confirmPasswordError,
    String? errorMessage,
  }) {
    return ChangePasswordState(
      currentController: currentController,
      newController: newController,
      confirmController: confirmController,
      newFocus: newFocus,
      confirmFocus: confirmFocus,
      isValid: isValid ?? this.isValid,
      newPasswordError: newPasswordError ?? this.newPasswordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
