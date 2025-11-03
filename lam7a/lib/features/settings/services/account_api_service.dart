import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/api_service.dart';
import 'account_api_service_implementation.dart';
import '../../../core/models/user_model.dart';
import 'account_api_service_mock.dart';

part 'account_api_service.g.dart';

@riverpod
AccountApiService accountApiService(Ref ref) {
  return AccountApiServiceMock(); // Replace later with real backend API
}

@riverpod
AccountApiService accountApiServiceImpl(Ref ref) {
  return AccountApiServiceImpl(ref.read(apiServiceProvider));
}

abstract class AccountApiService {
  Future<UserModel> getMyInfo();
  Future<void> changeEmail(String newEmail);
  Future<void> changePassword(String oldPassword, String newPassword);
  Future<void> deactivateAccount();
  Future<void> changeUsername(String newUsername);
  Future<bool> validatePassword(String password);
  Future<bool> checkEmailExists(String email);
  Future<bool> validateOtp(String email, String otp);
  Future<void> sendOtp(String email);
  Future<void> resendOtp(String email);
}
