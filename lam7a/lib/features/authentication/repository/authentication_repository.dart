
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract class AuthenticationRepository {
  Future<bool> checkEmail(String email, Ref ref);
  Future<bool> verificationOTP(String email, Ref ref);
  Future<bool> resendOTP(String email, Ref ref);
  Future<bool> register(AuthenticationUserDataModel user, Ref ref);
  Future<bool> verifyOTP(String email, String OTP, Ref ref);
  Future<bool> login(AuthenticationUserCredentialsModel userCredentials, Ref ref);
}