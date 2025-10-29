import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/account_model.dart';
import '../../repository/my_user_repository.dart';

class AccountViewModel extends Notifier<AccountModel> {
  late final MyUserRepository _repo;

  @override
  AccountModel build() {
    _repo = ref.read(myUserRepositoryProvider);

    // initial empty state before data is loaded
    _loadAccountInfo();

    return AccountModel(handle: '', email: '', country: '', password: '');
  }

  /// 🔹 Fetch account info from the mock DB
  Future<void> _loadAccountInfo() async {
    try {
      final info = await _repo.fetchMyInfo();
      state = info;
    } catch (e) {
      // you can log or add an error handling mechanism here later
    }
  }

  // =========================================================
  // 🟩 LOCAL STATE UPDATERS
  // =========================================================

  void updateHandle(String newHandle) {
    state = state.copyWith(handle: newHandle);
  }

  void updateEmail(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateCountry(String newCountry) {
    state = state.copyWith(country: newCountry);
  }

  void updatePassword(String newPassword) {
    state = state.copyWith(password: newPassword);
  }

  /// Update email both in backend and state
  Future<void> changeEmail(String newEmail) async {
    try {
      await _repo.changeEmail(newEmail);
      updateEmail(newEmail);
    } catch (e) {
      // handle or rethrow error
    }
  }

  /// Update password both in backend and state
  Future<void> changePassword(String newPassword) async {
    try {
      await _repo.changePassword(newPassword);
      updatePassword(newPassword);
    } catch (e) {
      // handle or rethrow error
    }
  }

  /// Update username both in backend and state
  Future<void> changeUsername(String newUsername) async {
    try {
      await _repo.changeUsername(newUsername);
      updateHandle(newUsername);
    } catch (e) {
      // handle or rethrow error
    }
  }

  Future<void> changeCountry(String newCountry) async {
    try {
      // assuming the backend supports it, otherwise just update locally
      // updateCountry(newCountry);
    } catch (e) {
      // handle or log
    }
  }

  /// Deactivate account
  Future<void> deactivateAccount() async {
    try {
      await _repo.deactivateAccount();

      state = AccountModel(handle: '', email: '', country: '', password: '');
    } catch (e) {}
  }

  Future<void> refresh() async {
    await _loadAccountInfo();
  }
}

// 🔹 Global provider
final accountProvider = NotifierProvider<AccountViewModel, AccountModel>(
  AccountViewModel.new,
);
