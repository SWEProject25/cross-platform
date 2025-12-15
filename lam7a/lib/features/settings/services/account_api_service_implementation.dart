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
        endpoint: ServerConstant.me,
        fromJson: (data) => UserModel.fromJson(data['data']['user']),
      );
      print('Fetched User Info: $result');
      return result;
    } catch (e) {
      // Handle error
      print('Error fetching user info: $e');
      rethrow;
    }
  }

  @override
  Future<void> changeEmail(String newEmail) async {
    try {
      await _api.patch(
        endpoint: ServerConstant.updateEmail,
        data: {'email': newEmail},
      );
    } catch (e) {
      print('Error changing email in api service');
      rethrow;
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
      rethrow;
    }
  }

  @override
  Future<void> changeUsername(String newUsername) async {
    try {
      await _api.patch(
        endpoint: ServerConstant.changeUsername,
        data: {'username': newUsername},
      );
    } catch (e) {
      print('Error changing username in api service');
      rethrow;
    }
  }

  @override // to be made
  Future<bool> validatePassword(String password) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        endpoint: ServerConstant.validatePassword,
        data: {'password': password},
      );

      // Extract the 'isValid' field safely from response['data']
      return response['data']?['isValid'] ?? false;
    } catch (e) {
      print('Error validating password in api service');
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
      return true;
    }
  }

  @override
  Future<bool> validateOtp(String email, String otp) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        endpoint: ServerConstant.verifyOTP,
        data: {'email': email, 'otp': otp},
      );
      return response['status'] == 'success';
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
      print('Error sending OTP in api service');
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    try {
      await _api.post(
        endpoint: ServerConstant.resendOTP,
        data: {'email': email},
      );
    } catch (e) {
      print('Error sending re-send OTP in api service');
      rethrow;
    }
  }
}
