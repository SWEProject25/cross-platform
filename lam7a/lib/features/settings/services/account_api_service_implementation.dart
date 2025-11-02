import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'account_api_service.dart';
import 'package:lam7a/core/constants/server_constant.dart';

/// The real API service implementation using ApiService (Dio)
class AccountApiServiceImpl implements AccountApiService {
  final ApiService _api;

  AccountApiServiceImpl(this._api);

  @override
  Future<UserModel> getMyInfo() async {
    // return _mockUser;
    try {
      final result = await _api.get<UserModel>(
        endpoint: ServerConstant.me, // dummy endpoint for now
        fromJson: (data) => UserModel.fromJson(data['data']),
      );
      return result;
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  @override
  Future<void> changeEmail(String newEmail) async {
    try {
      await _api.post(
        endpoint: ServerConstant.checkEmailEndPoint,
        data: {'email': newEmail},
      );
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _api.post(
        endpoint: ServerConstant.changePassword,
        data: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
    } catch (e) {
      // Handle error
    }
  }

  @override // to be made
  Future<void> deactivateAccount() async {
    try {
      await _api.post(endpoint: '/user/deactivate');
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> changeUsername(String newUsername) async {
    try {
      await _api.post(
        endpoint: ServerConstant.changeUsername,
        data: {'username': newUsername},
      );
    } catch (e) {
      // Handle error
    }
  }

  @override // to be made
  Future<bool> validatePassword(String password) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        endpoint: '/user/validate-password',
        data: {'password': password},
      );
      return response['isValid'] ?? false;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        endpoint: ServerConstant.checkEmailEndPoint,
        data: {'email': email},
      );
      return response['exists'] ?? false;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  @override
  Future<bool> validateOtp(String email, String otp) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        endpoint: ServerConstant.verifyOTP,
        data: {'email': email, 'otp': otp},
      );
      return response['isValid'] ?? false;
    } catch (e) {
      // Handle error
      return false;
    }
  }

  @override
  Future<void> sendOtp(String email) async {
    try {
      await _api.post(
        endpoint: ServerConstant.verificationOTP,
        data: {'email': email},
      );
    } catch (e) {
      // Handle error
    }
  }
}
