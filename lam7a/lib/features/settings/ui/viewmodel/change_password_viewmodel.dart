import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_password_state.dart';
import '../../repository/account_settings_repository.dart';
import '../../utils/validators.dart';

class ChangePasswordNotifier extends Notifier<ChangePasswordState> {
  @override
  ChangePasswordState build() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();
    final newFocus = FocusNode();
    final confirmFocus = FocusNode();

    // Attach listeners to validate on losing focus
    newFocus.addListener(() {
      if (!newFocus.hasFocus) {
        _validateNewPassword();
      }
    });
    confirmFocus.addListener(() {
      if (!confirmFocus.hasFocus) {
        _validateConfirmPassword();
      }
    });

    ref.onDispose(() {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
      newFocus.dispose();
      confirmFocus.dispose();
    });

    return ChangePasswordState(
      currentController: currentController,
      newController: newController,
      confirmController: confirmController,
      newFocus: newFocus,
      confirmFocus: confirmFocus,
    );
  }

  void updateNew(String value) {
    _updateButtonState();
  }

  void updateConfirm(String value) {
    _updateButtonState();
  }

  void updateCurrent(String value) {
    _updateButtonState();
  }

  void _updateButtonState() {
    final current = state.currentController.text.trim();
    final newPass = state.newController.text.trim();
    final confirm = state.confirmController.text.trim();

    final isValid =
        current.isNotEmpty &&
        newPass.isNotEmpty &&
        confirm.isNotEmpty &&
        newPass.length >= 8 &&
        confirm.length >= 8 &&
        newPass == confirm;

    state = state.copyWith(isValid: isValid);
  }

  void _validateNewPassword() {
    final newPass = state.newController.text;
    String? error;

    if (newPass.isEmpty) {
      error = 'Enter a new password';
    } else if (newPass.length < 8) {
      error = 'Password must be at least 8 characters';
    } else {
      final strength = Validators.getPasswordStrength(newPass);

      switch (strength) {
        case PasswordStrength.weak:
          error = 'Password is too weak — add more variety and length.';
          break;
        case PasswordStrength.medium:
          error =
              'please add at least one uppercase letter, lowercase letter, number, and symbol';
          break;
        case PasswordStrength.strong:
          error = null; // acceptable strength
          break;
        case PasswordStrength.veryStrong:
          error = null; // best case
          break;
      }
    }
    state = state.copyWith(newPasswordError: error);
    _updateButtonState();
  }

  void _validateConfirmPassword() {
    final confirmPass = state.confirmController.text;
    final newPass = state.newController.text;
    String? error;

    if (confirmPass.isEmpty) {
      error = 'Please confirm your password';
    } else if (confirmPass.length < 8) {
      error = 'Password must be at least 8 characters';
    } else if (confirmPass != newPass) {
      error = 'Passwords do not match';
    } else {
      error = null;
    }
    state = state.copyWith(confirmPasswordError: error);
    _updateButtonState();
  }

  // Simulate backend password check
  Future<void> changePassword(BuildContext context) async {
    final current = state.currentController.text.trim();
    final newPassword = state.newController.text.trim();

    final accountRepo = ref.read(accountSettingsRepoProvider);
    try {
      await accountRepo.changePassword(current, newPassword);
      // On success, you might want to show a success message or navigate away
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.of(context).pop(); // Go back after successful change
    } catch (e) {
      _showErrorDialog(context);
    }
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

final changePasswordProvider =
    NotifierProvider.autoDispose<ChangePasswordNotifier, ChangePasswordState>(
      ChangePasswordNotifier.new,
    );
