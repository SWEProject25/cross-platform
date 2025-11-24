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
    _validateNewPassword(); // this line shouldn't be here , unit testing only
    updateButtonState();
  }

  void updateConfirm(String value) {
    _validateConfirmPassword(); // this line shouldn't be here , unit testing only
    updateButtonState();
  }

  void updateCurrent(String value) {
    updateButtonState();
  }

  void updateButtonState() {
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
    String? error = "";

    if (newPass.isEmpty) {
      error = 'Enter a new password';
    } else if (newPass.length < 8) {
      error = 'Password must be at least 8 characters';
    } else {
      final hasUpper = RegExp(r'[A-Z]').hasMatch(newPass);
      final hasLower = RegExp(r'[a-z]').hasMatch(newPass);
      final hasDigit = RegExp(r'\d').hasMatch(newPass);
      final hasSpecial = RegExp(r'[\W_]').hasMatch(newPass);

      List<String> missing = [];
      if (!hasUpper) missing.add("uppercase letter");
      if (!hasLower) missing.add("lowercase letter");
      if (!hasDigit) missing.add("number");
      if (!hasSpecial) missing.add("special character");

      if (missing.isNotEmpty) {
        error = "Password must include: ${missing.join(", ")}";
      }
    }
    print(error != "" ? 'New Password Error: $error' : 'New Password Valid');

    state = state.copyWith(newPasswordError: error);

    updateButtonState();
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
      error = "";
    }

    state = state.copyWith(confirmPasswordError: error);
    updateButtonState();
  }

  Future<void> changePassword(BuildContext context) async {
    if (state.isValid == false) return;

    final current = state.currentController.text.trim();
    final newPassword = state.newController.text.trim();
    final accountRepo = ref.read(accountSettingsRepoProvider);

    try {
      await accountRepo.changePassword(current, newPassword);

      if (!ref.mounted) return; // ← ADD THIS
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (!ref.mounted) return; // ← AND THIS
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
