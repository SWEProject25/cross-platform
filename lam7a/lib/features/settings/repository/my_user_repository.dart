import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/account_model.dart';
import '../services/account_api_service.dart';

part 'my_user_repository.g.dart';

@riverpod
MyUserRepository myUserRepository(Ref ref) {
  return MyUserRepository(ref.read(accountApiServiceProvider));
}

class MyUserRepository {
  final AccountApiService _api;

  MyUserRepository(this._api);

  Future<AccountModel> fetchMyInfo() => _api.getMyInfo();
  Future<void> changeEmail(String newEmail) => _api.changeEmail(newEmail);
  Future<void> changePassword(String newPassword) =>
      _api.changePassword(newPassword);
  Future<void> changeUsername(String newUsername) =>
      _api.changeUsername(newUsername);
  Future<void> deactivateAccount() => _api.deactivateAccount();
}
