import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/authentication_repository.dart';
import 'package:lam7a/features/authentication/service/authentication_api_service.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final apiService = AuthenticationApiService();
  @override
  Future<bool> checkEmail(String email, Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    Map<String, dynamic> body;
    body = await apiService.checkEmail(email, _apiService);
    print(body);
    return (body[message].toString() == emailExist);
  }

  @override
  Future<bool> verificationOTP(String email, Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final message = await apiService.verificationOTP(email, _apiService);
    return (message[status].toString() == success);
  }

  @override
  Future<bool> resendOTP(String email, Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final message = await apiService.resendOTP(email, _apiService);
    return (message[status].toString() == success);
  }

  @override
  Future<UserModel> register(AuthenticationUserDataModel user, Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final data = await apiService.register(user, _apiService);
    UserModel userModel = UserModel.fromJson(data['data']['user']);
    return userModel;
  }

  @override
  Future<bool> verifyOTP(String email, String OTP, Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final message = await apiService.verifyOTP(email, OTP, _apiService);
    return (message[status].toString() == success);
  }

  @override
  Future<UserModel> login(
    AuthenticationUserCredentialsModel userCredentials,
    Ref ref,
  ) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final data = await apiService.Login(userCredentials, _apiService);
    print(data);
    UserModel userModel = UserModel.fromJson(data['data']['user']);
    return userModel;
  }

  @override
  Future<void> test(WidgetRef ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    final data = await apiService.test(_apiService);
  }
  Future<bool> logout(Ref ref) async {
    final _apiService = await ref.read(apiServiceProvider.future);
    bool res =  await apiService.logout(_apiService);
      print(res);
      return res;
    }
}

