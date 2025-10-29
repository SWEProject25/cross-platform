import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/account_model.dart';
import 'account_api_service_mock.dart';

part 'account_api_service.g.dart';

@riverpod
AccountApiService accountApiService(Ref ref) {
  return AccountApiServiceMock(); // Replace later with real backend API
}

abstract class AccountApiService {
  Future<AccountModel> getMyInfo();
  Future<void> changeEmail(String newEmail);
  Future<void> changePassword(String newPassword);
  Future<void> deactivateAccount();
  Future<void> changeUsername(String newUsername);
}
