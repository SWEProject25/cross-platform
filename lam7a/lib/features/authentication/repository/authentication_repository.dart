import 'package:lam7a/features/authentication/model/user_credential_model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/user_data_model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/repository/iauthentication_repository.dart';
import 'package:lam7a/features/authentication/service/authentication_api_service.dart';

class AuthenticationRepository implements IauthenticationRepository {
  final apiAuth = AuthenticationApiService();
  @override
  Future<bool> checkEmail(String email) async {
    bool isUnique = false;
    isUnique = await apiAuth.checkEmail(email);
    return isUnique;
  }

  @override
  Future<String> verificationOTP(String email) async {
    final message = await apiAuth.verificationOTP(email);
    return message;
  }

  @override
  Future<String> resendOTP(String email) async {
    final message = await apiAuth.resendOTP(email);
    return message;
  }

  @override
  Future<int> register(AuthenticationUserDataModel user) async {
    int message = await apiAuth.register(user);
    return message;
  }

  @override
  Future<bool> verifyOTP(String email, String OTP) async {
    bool isValidOTP = await apiAuth.verifyOTP(email, OTP);
    return isValidOTP;
  }

  @override
  Future<int> login(AuthenticationUserCredentialsModel userCredentials) async {
    int statusCode = await apiAuth.Login(userCredentials);
    return statusCode;
  }
}
