import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
// import 'package:lam7a/features/authentication/model/user_data_model.dart';

class AuthenticationApiService {
  Future<bool> checkEmail(String email) async {
    Uri url = Uri.parse(
      ServerConstant.domain + ServerConstant.checkEmailEndPoint,
    );
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    print(response.statusCode);
    return (response.statusCode == 200);
  }

  Future<String> verificationOTP(String email) async {
    Uri url = Uri.parse(ServerConstant.domain + ServerConstant.verificationOTP);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.body;
  }

  Future<String> resendOTP(String email) async {
    Uri url = Uri.parse(ServerConstant.domain + ServerConstant.resendOTP);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response.body;
  }

  Future<bool> verifyOTP(String email, String OTP) async {
    Uri url = Uri.parse(ServerConstant.domain + ServerConstant.verifyOTP);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, "otp": OTP}),
    );
    return (response.statusCode < 400);
  }

  Future<int> register(AuthenticationUserDataModel user) async {
    Uri url = Uri.parse(
      ServerConstant.domain + ServerConstant.registrationEndPoint,
    );
      print(user.toJson());
      var res = jsonEncode(user.toJson());
      print(res);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: res,
    );
    return response.statusCode;
  }
  Future<int> Login(AuthenticationUserCredentialsModel userCredentials) async
  {
        Uri url = Uri.parse(
      ServerConstant.domain + ServerConstant.login,
    );
      var res = jsonEncode(userCredentials.toJson());
      print(res);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: res,
    );
    return response.statusCode;
  }
}
