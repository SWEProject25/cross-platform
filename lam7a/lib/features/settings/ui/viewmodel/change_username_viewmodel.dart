import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_username_state.dart';
import 'account_viewmodel.dart';
import 'package:flutter/material.dart';

class ChangeUsernameViewModel extends Notifier<ChangeUsernameState> {
  @override
  ChangeUsernameState build() {
    final account = ref.read(accountProvider);
    return ChangeUsernameState(
      currentUsername: account.username!,
      newUsername: '',
      isValid: false,
      isLoading: false,
      errorMessage: null,
    );
  }

  void updateUsername(String value) {
    final isValid = _validateUsername(value);
    state = state.copyWith(newUsername: value, isValid: isValid);
  }

  bool _validateUsername(String username) {
    if (username.isEmpty) return false;

    if (username == ref.read(accountProvider).username) {
      state = state.copyWith(errorMessage: 'New username must be different');
      return false;
    }
    if (username.length < 3 || username.length > 50) {
      state = state.copyWith(
        errorMessage: 'Username must be between 3 and 50 characters',
      );
      return false;
    }
    final regex = RegExp(r'^[a-zA-Z](?!.*[_.]{2})[a-zA-Z0-9._]+$');
    if (!regex.hasMatch(username)) {
      state = state.copyWith(
        errorMessage:
            'Username can only contain letters, numbers, dots, and underscores',
      );
      return false;
    }

    state = state.copyWith(errorMessage: "");
    return true;
  }

  Future<void> saveUsername(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    try {
      await ref
          .read(accountProvider.notifier)
          .changeUsername(state.newUsername);

      // Force authenticationProvider to reload user info

      state = state.copyWith(
        currentUsername: state.newUsername,
        newUsername: '',
        isValid: false,
        isLoading: false,
      );
      if (!ref.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Username updated')));
    } catch (e) {
      print('Error changing username: $e');
      state = state.copyWith(isLoading: false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Username already taken')));
    }
  }
}

final changeUsernameProvider =
    NotifierProvider.autoDispose<ChangeUsernameViewModel, ChangeUsernameState>(
      ChangeUsernameViewModel.new,
    );
