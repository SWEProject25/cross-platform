import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/utils.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
// import 'package:lam7a/features/authentication/model/user_data_model.dart';

class AuthenticationApiService {
  Future<Map<String, dynamic>> checkEmail(
    String email,
    ApiService apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.checkEmailEndPoint,
      data: {'email': email},
      fromJson: fromJsonToMap,
    );
  }

  Future<Map<String, dynamic>> verificationOTP(
    String email,
    ApiService apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verificationOTP,
      data: {'email': email},
      fromJson: fromJsonToMap,
    );
  }

  Future<Map<String, dynamic>> resendOTP(
    String email,
    ApiService apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.resendOTP,
      data: {'email': email},
      fromJson: fromJsonToMap,
    );
  }

  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String OTP,
    ApiService apiService,
  ) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verifyOTP,
      data: {'email': email, 'otp': OTP},
      fromJson: fromJsonToMap,
    );
  }

  Future<Map<String, dynamic>> register(AuthenticationUserDataModel user, ApiService apiService) async {
   
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verifyOTP,
      data: user.toJson(),
      fromJson: fromJsonToMap,
    );
  }

  Future<Map<String, dynamic>> Login(AuthenticationUserCredentialsModel userCredentials,ApiService apiService) async {
    return await apiService.post(
      endpoint: ServerConstant.domain + ServerConstant.verifyOTP,
      data: userCredentials.toJson(),
      fromJson: fromJsonToMap,
    );
  }
}
