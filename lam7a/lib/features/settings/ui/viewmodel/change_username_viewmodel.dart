import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_username_state.dart';
import 'account_viewmodel.dart';

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
    final regex = RegExp(r'^[a-z0-9_@]+$');
    if (!regex.hasMatch(username)) {
      state = state.copyWith(
        errorMessage:
            'Username can only contain lowercase letters, numbers, underscores, and @ symbol',
      );
      return false;
    }

    state = state.copyWith(errorMessage: "");
    return true;
  }

  Future<void> saveUsername() async {
    state = state.copyWith(isLoading: true);

    try {
      await ref
          .read(accountProvider.notifier)
          .changeUsername(state.newUsername);

      state = state.copyWith(
        currentUsername: state.newUsername,
        newUsername: '',
        isValid: false,
        isLoading: false,
      );
    } catch (e) {
      print('Error changing username: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}

final changeUsernameProvider =
    NotifierProvider.autoDispose<ChangeUsernameViewModel, ChangeUsernameState>(
      ChangeUsernameViewModel.new,
    );
