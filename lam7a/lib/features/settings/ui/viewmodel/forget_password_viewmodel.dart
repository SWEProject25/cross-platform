import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/forget_password_state.dart';
import '../../utils/validators.dart';
import '../../repository/my_user_repository.dart';
import 'account_viewmodel.dart';

class ForgetPasswordNotifier extends Notifier<ForgetPasswordState> {
  @override
  ForgetPasswordState build() {
    final otpCode = '';
    final newPasswordController = TextEditingController();
    final newPasswordAgainController = TextEditingController();
    final newFocus = FocusNode();
    final againFocus = FocusNode();

    // Attach listeners to validate on losing focus
    newFocus.addListener(() {
      if (!newFocus.hasFocus) {
        _validateNewPassword();
      }
    });
    againFocus.addListener(() {
      if (!againFocus.hasFocus) {
        _validateAgainPassword();
      }
    });

    ref.onDispose(() {
      newPasswordController.dispose();
      newPasswordAgainController.dispose();
      newFocus.dispose();
      againFocus.dispose();
    });

    return ForgetPasswordState(
      otpCode: otpCode,
      newPasswordController: newPasswordController,
      newPasswordAgainController: newPasswordAgainController,
      newFocus: newFocus,
      againFocus: againFocus,
      isValid: false,
    );
  }

  void updateOtp(String value) {
    state = state.copyWith(otpCode: value);
  }

  void updateAgain(String value) {
    _updateButtonState();
  }

  void updateCurrent(String value) {
    _updateButtonState();
  }

  void _updateButtonState() {
    final newPass = state.newPasswordController.text.trim();
    final confirm = state.newPasswordAgainController.text.trim();

    final isValid =
        newPass.isNotEmpty &&
        confirm.isNotEmpty &&
        newPass.length >= 8 &&
        confirm.length >= 8 &&
        newPass == confirm;

    state = state.copyWith(isValid: isValid);
  }

  void _validateNewPassword() {
    final newPass = state.newPasswordController.text;
    String? error;

    final PasswordStrength passStrength = Validators.getPasswordStrength(
      newPass,
    );

    switch (passStrength) {
      case PasswordStrength.weak:
        error = 'Password is too weak';
        break;
      case PasswordStrength.medium:
        error = 'try adding numbers or special characters'; // Acceptable
        break;
      case PasswordStrength.strong:
        error = null; // Acceptable
        break;

      default:
        error = 'Password must be at least 8 characters';
    }

    state = state.copyWith(
      newPasswordError: error,
      passwordStrength: passStrength,
    );
    _updateButtonState();
  }

  void _validateAgainPassword() {
    final confirmPass = state.newPasswordAgainController.text;
    final newPass = state.newPasswordController.text;
    String? error;

    if (confirmPass.isEmpty) {
      error = 'Please confirm your password';
    } else if (confirmPass != newPass) {
      error = 'Passwords do not match';
    } else {
      error = null;
    }

    state = state.copyWith(againPasswordError: error);
    _updateButtonState();
  }

  // Simulate backend password check
  Future<void> sendOtp() async {
    try {
      final accountRepo = ref.read(myUserRepositoryProvider);
      final account = ref.read(accountProvider);
      await accountRepo.sendOtp(account.email!);
    } catch (e) {
      // handle error
    }
  }

  Future<void> validateOtp(BuildContext context) async {
    // TO DO: connect to backend
    return Future.delayed(const Duration(seconds: 2));
  }

  Future<void> resetPassword(BuildContext context) async {
    // TO DO: connect to backend
    return Future.delayed(const Duration(seconds: 2));
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(Icons.lock_outline_rounded, color: Colors.blue),
          title: const Text('Incorrect Password'),
          content: const Text('Please enter the correct current password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

final forgetPasswordProvider =
    NotifierProvider.autoDispose<ForgetPasswordNotifier, ForgetPasswordState>(
      ForgetPasswordNotifier.new,
    );
