
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';

abstract class AuthenticationRepository {
  Future<bool> checkEmail(String email);
  Future<String> verificationOTP(String email);
  Future<String> resendOTP(String email);
  Future<int> register(AuthenticationUserDataModel user);
  Future<bool> verifyOTP(String email, String OTP);
  Future<int> login(AuthenticationUserCredentialsModel userCredentials);
}