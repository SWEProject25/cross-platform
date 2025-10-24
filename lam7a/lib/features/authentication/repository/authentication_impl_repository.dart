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
    ApiService _apiService = ref.read(apiServiceProvider);
    Map<String, dynamic> body;
    body = await apiService.checkEmail(email, _apiService);
    return (body[status] == success);
  }

  @override
  Future<bool> verificationOTP(String email, Ref ref) async {
    ApiService _apiService = ref.read(apiServiceProvider);
    final message = await apiService.verificationOTP(email, _apiService);
    return (message[status] == success);
  }

  @override
  Future<bool> resendOTP(String email, Ref ref) async {
    ApiService _apiService = ref.read(apiServiceProvider);
    final message = await apiService.resendOTP(email, _apiService);
    return (message[status] == success);
  }

  @override
  Future<bool> register(AuthenticationUserDataModel user, Ref ref) async {
    ApiService _apiService = ref.read(apiServiceProvider);
    final message = await apiService.register(user, _apiService);  
    return (message[status] == success);
  }

  @override
  Future<bool> verifyOTP(String email, String OTP, Ref ref) async {
    ApiService _apiService = ref.read(apiServiceProvider);
    final message = await apiService.verifyOTP(email, OTP, _apiService);
    return (message[status] == success);
  }

  @override
  Future<bool> login(AuthenticationUserCredentialsModel userCredentials, Ref ref) async {
    ApiService _apiService = ref.read(apiServiceProvider);
    final message = await apiService.Login(userCredentials,_apiService);
    return (message[status] == success);
  }
}