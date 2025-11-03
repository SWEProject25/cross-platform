// lib/features/settings/viewmodel/change_email_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_email_state.dart';
import 'account_viewmodel.dart';
import '../../utils/validators.dart';
import '../../repository/my_user_repository.dart';

class ChangeEmailViewModel extends Notifier<ChangeEmailState> {
  @override
  ChangeEmailState build() {
    final account = ref.read(accountProvider);
    return ChangeEmailState(
      currentPage: ChangeEmailPage.verifyPassword,
      email: account.email!,
    );
  }

  //////////////////////////////////////////////////////////
  ///  updating fields
  /////////////////////////////////////////////////////////
  void updatePassword(String value) {
    state = state.copyWith(password: value);
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value);
  }

  void updateOtp(String value) {
    state = state.copyWith(otp: value);
  }

  ////////////////////////////////////////////////////////////
  ///     navigation
  ///////////////////////////////////////////////////////////

  Future<void> goToChangeEmail(BuildContext context) async {
    if (await validatePassword(context)) {
      state = state.copyWith(currentPage: ChangeEmailPage.changeEmail);
    }
  }

  Future<void> goToOtpVerification(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      if (Validators.isValidEmail(state.email)) {
        final accountRepo = ref.read(myUserRepositoryProvider);
        if (!await accountRepo.checkEmailExists(state.email)) {
          state = state.copyWith(currentPage: ChangeEmailPage.verifyOtp);
          await accountRepo.sendOtp(state.email);
        }
      } else {
        throw Exception("wrong email form");
      }
    } catch (e) {
      // handle error later
      _showErrorDialog(context);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void goToVerifyPassword() {
    state = state.copyWith(currentPage: ChangeEmailPage.verifyPassword);
  }

  //////////////////////////////////////////////////////////////////////
  ///           api service
  /////////////////////////////////////////////////////////////////////
  Future<void> validateOtp(BuildContext context) async {
    final accountVM = ref.read(myUserRepositoryProvider);
    final validOtp = await accountVM.validateOtp(state.email, state.otp);
    if (validOtp) {
      saveEmail();
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      _showErrorDialog(context);
    }
  }

  Future<void> saveEmail() async {
    ref.read(accountProvider.notifier).changeEmail(state.email);
  }

  Future<void> ResendOtp() async {
    try {
      final accountRepo = ref.read(myUserRepositoryProvider);
      await accountRepo.sendOtp(state.email);
    } catch (e) {
      // Handle error
      print('Error resending OTP in viewmodel');
    }
  }

  Future<bool> validatePassword(BuildContext context) async {
    final accountRepo = ref.read(myUserRepositoryProvider);
    final isValid = await accountRepo.validatePassword(state.password);
    if (!isValid) {
      _showErrorDialog(context);
    }
    return isValid;
  }

  /// error handling (here for now)
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
