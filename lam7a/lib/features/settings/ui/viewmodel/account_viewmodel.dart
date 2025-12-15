import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../repository/account_settings_repository.dart';
import '../../../../core/providers/authentication.dart';

class AccountViewModel extends Notifier<UserModel> {
  late final AccountSettingsRepository _repo;

  @override
  UserModel build() {
    _repo = ref.read(accountSettingsRepoProvider);

    // initial empty state before data is loaded

    final authState = ref.read(authenticationProvider);
    state = authState.user!;

    return state;
  }

  /// 🔹 Fetch account info from the mock DB

  // =========================================================
  // 🟩 LOCAL STATE UPDATERS
  // =========================================================

  // this logic maybe changed later

  void updateUsernameLocalState(String newUsername) {
    state = state.copyWith(username: newUsername);
    ref.read(authenticationProvider.notifier).updateUser(state);
  }

  void updateEmailLocalState(String newEmail) {
    state = state.copyWith(email: newEmail);
    ref.read(authenticationProvider.notifier).updateUser(state);
  }

  /// Update email both in backend and state
  Future<void> changeEmail(String newEmail) async {
    try {
      await _repo.changeEmail(newEmail);
      updateEmailLocalState(newEmail);
    } catch (e) {
      print("error in account view model change email");
      rethrow;
    }
  }

  /// Update password both in backend and state
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _repo.changePassword(oldPassword, newPassword);
    } catch (e) {
      // handle or rethrow error
      rethrow;
    }
  }

  /// Update username both in backend and state
  Future<void> changeUsername(String newUsername) async {
    try {
      await _repo.changeUsername(newUsername);

      updateUsernameLocalState(newUsername);
    } catch (e) {
      print("error in account view model change username");
      rethrow;
    }
  }
}

// 🔹 Global provider
final accountProvider =
    NotifierProvider.autoDispose<AccountViewModel, UserModel>(
      AccountViewModel.new,
    );
