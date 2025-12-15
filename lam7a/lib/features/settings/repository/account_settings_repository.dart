// coverage:ignore-file
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import '../services/account_api_service.dart';

part 'account_settings_repository.g.dart';

@riverpod
AccountSettingsRepository accountSettingsRepo(Ref ref) {
  return AccountSettingsRepository(ref.read(accountApiServiceImplProvider));
}

class AccountSettingsRepository {
  final AccountApiService _api;

  AccountSettingsRepository(this._api);

  Future<UserModel> fetchMyInfo() => _api.getMyInfo();
  Future<void> changeEmail(String newEmail) => _api.changeEmail(newEmail);
  Future<void> changePassword(String oldPassword, String newPassword) =>
      _api.changePassword(oldPassword, newPassword);
  Future<void> changeUsername(String newUsername) =>
      _api.changeUsername(newUsername);
  Future<bool> validatePassword(String password) =>
      _api.validatePassword(password);
  Future<bool> checkEmailExists(String email) => _api.checkEmailExists(email);
  Future<bool> validateOtp(String email, String otp) =>
      _api.validateOtp(email, otp);
  Future<void> sendOtp(String email) => _api.sendOtp(email);
  Future<void> resendOtp(String email) => _api.resendOtp(email);
}
