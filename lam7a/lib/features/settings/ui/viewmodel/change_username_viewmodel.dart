import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/change_username_state.dart';
import 'account_viewmodel.dart';

class ChangeUsernameViewModel extends Notifier<ChangeUsernameState> {
  @override
  ChangeUsernameState build() {
    final account = ref.read(accountProvider);
    return ChangeUsernameState(currentUsername: account.handle);
  }

  void updateUsername(String value) {
    final isValid = _validateUsername(value);
    state = state.copyWith(newUsername: value, isValid: isValid);
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty && username.startsWith('@');
  }

  Future<void> saveUsername() async {
    if (!state.isValid) return;

    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(seconds: 1));

    // 🔗 Update global account provider
    ref.read(accountProvider.notifier).updateHandle(state.newUsername);

    // 🔄 Update local state
    state = state.copyWith(
      currentUsername: state.newUsername,
      newUsername: '',
      isValid: false,
      isLoading: false,
    );
  }
}

final changeUsernameProvider =
    NotifierProvider.autoDispose<ChangeUsernameViewModel, ChangeUsernameState>(
      ChangeUsernameViewModel.new,
    );
