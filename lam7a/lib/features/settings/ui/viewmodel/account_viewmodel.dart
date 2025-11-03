import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../repository/account_settings_repository.dart';

class AccountViewModel extends Notifier<UserModel> {
  late final AccountSettingsRepository _repo;

  @override
  UserModel build() {
    _repo = ref.read(accountSettingsRepoProvider);

    // initial empty state before data is loaded
    _loadAccountInfo();

    return UserModel(
      username: '',
      email: '',
      role: '',
      name: '',
      birthDate: '',
      profileImageUrl: '',
      bannerImageUrl: '',
      bio: '',
      location: '',
      website: '',
      createdAt: '',
    );
  }

  /// 🔹 Fetch account info from the mock DB
  Future<void> _loadAccountInfo() async {
    try {
      final info = await _repo.fetchMyInfo();
      state = info;
    } catch (e) {
      rethrow;
    }
  }

  // =========================================================
  // 🟩 LOCAL STATE UPDATERS
  // =========================================================

  // this logic maybe changed later

  void updateUsernameLocalState(String newUsername) {
    state = state.copyWith(username: newUsername);
  }

  void updateEmailLocalState(String newEmail) {
    state = state.copyWith(email: newEmail);
  }

  void updateLocationLocalState(String newLocation) {
    state = state.copyWith(location: newLocation);
  }

  /// Update email both in backend and state
  Future<void> changeEmail(String newEmail) async {
    try {
      await _repo.changeEmail(newEmail);

      updateEmailLocalState(newEmail);
    } catch (e) {
      // handle or rethrow error
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

  /// Deactivate account
  Future<void> deactivateAccount() async {
    try {
      await _repo.deactivateAccount();

      state = UserModel(
        username: '',
        email: '',
        role: '',
        name: '',
        birthDate: '',
        profileImageUrl: '',
        bannerImageUrl: '',
        bio: '',
        location: '',
        website: '',
        createdAt: '',
      );
    } catch (e) {}
  }

  Future<void> refresh() async {
    await _loadAccountInfo();
  }
}

// 🔹 Global provider
final accountProvider = NotifierProvider<AccountViewModel, UserModel>(
  AccountViewModel.new,
);
