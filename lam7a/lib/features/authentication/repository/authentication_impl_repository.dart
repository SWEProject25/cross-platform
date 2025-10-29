import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/service/authentication_api_service.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'authentication_impl_repository.g.dart';
@riverpod
AuthenticationRepositoryImpl authenticationImplRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    ref.read(authenticationApiServiceProvider),
  );
}

class AuthenticationRepositoryImpl {
  AuthenticationApiService apiService;
  AuthenticationRepositoryImpl(this.apiService);
  Future<bool> checkEmail(String email) async {
    Map<String, dynamic> body;
    body = await apiService.checkEmail(email);
    print(body);
    return (body[message].toString() == emailExist);
  }

  Future<bool> verificationOTP(String email) async {
    final message = await apiService.verificationOTP(email);
    return (message[status].toString() == success);
  }

  Future<bool> resendOTP(String email) async {
    final message = await apiService.resendOTP(email);
    return (message[status].toString() == success);
  }

  Future<UserModel?> register(AuthenticationUserDataModel user) async {
    final data = await apiService.register(user);
    UserModel userModel = UserModel.fromJson(data['data']['user']);
    return userModel;
  }

  Future<bool> verifyOTP(String email, String OTP) async {
    final message = await apiService.verifyOTP(email, OTP);
    return (message[status].toString() == success);
  }

  Future<UserModel> login(
    AuthenticationUserCredentialsModel userCredentials,
  ) async {
    final data = await apiService.Login(userCredentials);
    print(data);
    UserModel userModel = UserModel.fromJson(data['data']['user']);
    return userModel;
  }

  Future<void> test() async {
    final data = await apiService.test();
  }
}
