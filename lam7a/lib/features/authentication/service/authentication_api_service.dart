import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/utils.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
// import 'package:lam7a/features/authentication/model/user_data_model.dart';

class AuthenticationApiService {
  Future<Map<String, dynamic>> checkEmail(
    String email,
    final apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.checkEmailEndPoint,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> verificationOTP(
    String email,
    final apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verificationOTP,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> resendOTP(
    String email,
    final apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.resendOTP,
      data: {'email': email},
    );
  }

  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String OTP,
    final apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verifyOTP,
      data: {'email': email, 'otp': OTP},
    );
  }

  Future<Map<String, dynamic>> register(AuthenticationUserDataModel user, final apiService) async {
   
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.registrationEndPoint,
      data: user.toJson(),
    );
  }

  Future<Map<String, dynamic>> Login(AuthenticationUserCredentialsModel userCredentials,final apiService) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.login,
      data: userCredentials.toJson(),
    );
  }

    Future<void> test(final apiService) async
    {
        Map<String, dynamic> res =  await apiService.get(
      endpoint: ServerConstant.domain + "/auth/me",
    );
      print(res[status]);
    }

}
