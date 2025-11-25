import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:lam7a/features/authentication/model/user_data_model.dart';
part 'authentication_api_service.g.dart';

@riverpod
AuthenticationApiService authenticationApiService(Ref ref) {
  return AuthenticationApiService(ref.read(apiServiceProvider));
}

class AuthenticationApiService {
  ApiService apiService;
  AuthenticationApiService(this.apiService);
  Future<Map<String, dynamic>> checkEmail(String email) async {
    return await apiService.post(
      endpoint: ServerConstant.checkEmailEndPoint,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> verificationOTP(String email) async {
    return await apiService.post
      endpoint: ServerConstant.verificationOTP,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> resendOTP(String email) async {
    return await apiService.post(
      endpoint: ServerConstant.resendOTP,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> verifyOTP(String email, String OTP) async {
    return await apiService.post(
      endpoint: ServerConstant.verifyOTP,
      data: {'email': email, 'otp': OTP},
    );
  }

  Future<Map<String, dynamic>> register(
    AuthenticationUserDataModel user,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.registrationEndPoint,
      data: user.toJson(),
    );
  }

  Future<Map<String, dynamic>> Login(
    AuthenticationUserCredentialsModel userCredentials,
  ) async {
    print("the user credentials are : ${userCredentials.toJson()}");
    return await apiService.post(
      endpoint: ServerConstant.login,
      data: userCredentials.toJson(),
    );
    
  }

  Future<void> test() async {
    Map<String, dynamic> res = await apiService.get(
      endpoint: ServerConstant.me,
    );
    print(res[AuthenticationConstants.status]);
  }

  Future<bool> logout() async {
    Map<String, dynamic> res = await apiService.post(
      endpoint: ServerConstant.logout,
    );
    print(res[AuthenticationConstants.status]);
    return res[AuthenticationConstants.status] == AuthenticationConstants.success;
  }
}
