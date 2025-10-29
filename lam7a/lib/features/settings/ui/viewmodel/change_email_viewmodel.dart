// lib/features/settings/viewmodel/change_email_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_email_state.dart';
import 'account_viewmodel.dart';

class ChangeEmailViewModel extends Notifier<ChangeEmailState> {
  late final String currentPassword;
  @override
  ChangeEmailState build() {
    final account = ref.read(accountProvider);
    currentPassword = account.password;
    return ChangeEmailState(
      currentPage: ChangeEmailPage.verifyPassword,
      email: account.email,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void goToChangeEmail(BuildContext context) {
    if (validatePassword(context)) {
      state = state.copyWith(currentPage: ChangeEmailPage.changeEmail);
    }
  }

  bool validatePassword(BuildContext context) {
    if (state.password == currentPassword) {
      state = state.copyWith(currentPage: ChangeEmailPage.changeEmail);
      return true;
    } else {
      _showErrorDialog(context);
      return false;
    }
  }

  void goToVerifyPassword() {
    state = state.copyWith(currentPage: ChangeEmailPage.verifyPassword);
  }

  bool isValidEmail(String email) {
    // Basic email pattern (covers most cases)
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> saveEmail() async {
    // pretend to verify password first, then update
    if (isValidEmail(state.email)) {
      await Future.delayed(const Duration(seconds: 1));

      // ✅ Update global account provider
      ref.read(accountProvider.notifier).updateEmail(state.email);
    } else {}
    // Show error dialog for invalid email
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

final changeEmailProvider =
    NotifierProvider.autoDispose<ChangeEmailViewModel, ChangeEmailState>(
      ChangeEmailViewModel.new,
    );
