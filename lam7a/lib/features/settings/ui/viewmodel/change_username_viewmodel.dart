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
    );
  }

  void updateUsername(String value) {
    final isValid = _validateUsername(value);
    state = state.copyWith(newUsername: value, isValid: isValid);
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty;
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
      // Handle error (e.g., show a snackbar)
      print('Error changing username: $e');
    }
    // 🔗 Update global account provider

    // 🔄 Update local state
  }
}

final changeUsernameProvider =
    NotifierProvider.autoDispose<ChangeUsernameViewModel, ChangeUsernameState>(
      ChangeUsernameViewModel.new,
    );
