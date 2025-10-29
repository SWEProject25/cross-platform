import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class AuthenticationRepository {
  Future<bool> checkEmail(String email, Ref ref);
  Future<bool> verificationOTP(String email, Ref ref);
  Future<bool> resendOTP(String email, Ref ref);
  Future<UserModel> register(AuthenticationUserDataModel user, Ref ref);
  Future<bool> verifyOTP(String email, String OTP, Ref ref);
  Future<UserModel?> login(AuthenticationUserCredentialsModel userCredentials, Ref ref);
  Future<void> test(WidgetRef ref);
  Future<bool> logout(Ref ref);
}