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
    return await apiService.post(
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
  Future<List<dynamic>> getInterests() async {
    Map<String, dynamic> res = await apiService.get(
      endpoint: ServerConstant.getInterests,
    );
    return res['data'];
  }
  Future<List<dynamic>> getUsersToFollow() async {
    Map<String, dynamic> res = await apiService.get(
      endpoint: ServerConstant.toFollowUsers,
      queryParameters: {'limit': 10}
    );
    return res['data']['users'];
  }

  Future<void> selectInterests(List<int> interestIds) async {
    await apiService.post(
      endpoint: ServerConstant.addInterests,
      data: {'interestIds': interestIds},
    );
  }
  Future<Map<String, dynamic>> followUsers(int userId) async {
    return await apiService.post(
      endpoint: "/users/${userId}/follow",
    );
  }

  Future<Map<String, dynamic>> unFollowUsers(int userId) async {
    return await apiService.delete(
      endpoint: "/users/${userId}/follow",
    );
  }
  Future<Map<String, dynamic>> oAuthGoogleLogin(String idToken) async {
    final response = await apiService.post(endpoint: ServerConstant.oAuthGoogleLogin, data: {'idToken' : idToken});
    return response;
  }
  Future<Map<String, dynamic>> oAuthGithubLogin(String code) async {
    final response = await apiService.post(endpoint: ServerConstant.oAuthExchangeCode, data: {'code' : code});
    return response;
  }
}
