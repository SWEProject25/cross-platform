import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import '../state/change_password_state.dart';
import 'account_viewmodel.dart';
import '../../repository/my_user_repository.dart';

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
      error = null;
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
  Future<void> ChangePassword(BuildContext context) async {
    final current = state.currentController.text.trim();
    final newPassword = state.newController.text.trim();

    final accountRepo = ref.read(myUserRepositoryProvider);
    try {
      await accountRepo.changePassword(current, newPassword);
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
