import 'dart:async';
import '../models/account_model.dart';
import 'account_api_service.dart';

class AccountApiServiceMock implements AccountApiService {
  final AccountModel _mockAccount = AccountModel(
    handle: 'mockuser',
    email: 'mockuser@example.com',
    country: 'Mockland',
    password: 'password123', // this is not the final implementation
  );

  @override
  Future<AccountModel> getMyInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockAccount;
  }

  @override
  Future<void> changeEmail(String newEmail) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockAccount.email = newEmail;
  }

  @override // temporary mock implementation
  Future<void> changePassword(String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockAccount.password = newPassword;
  }

  @override
  Future<void> changeUsername(String newUsername) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockAccount.handle = newUsername;
  }

  @override
  Future<void> deactivateAccount() async {
    await Future.delayed(const Duration(seconds: 2));
    // In a real implementation, this would deactivate the account.
  }
}
