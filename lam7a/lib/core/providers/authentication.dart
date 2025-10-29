import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication.g.dart';

// this is under developing not finished yet
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication {
 late ApiService _apiService;
  @override
  AuthState build() {
    _apiService = ref.read(apiServiceProvider);
    return AuthState();
  }

  Future<void> isAuthenticated() async {
    try {
      final response = await _apiService.get(endpoint: ServerConstant.me);
      if (response['user'] != null) {
        UserModel? user = UserModel.fromJson(response["user"]);
        await authenticateUser(user);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> authenticateUser(UserModel? user) async {
    if (user != null) {
      state = state.copyWith(token: null, isAuthenticated: true, user: user);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await _apiService.post(endpoint: ServerConstant.logout);
      if (response['message'] == 'Logout successful') {
        prefs.remove('token');
        state = state.copyWith(user: null, isAuthenticated: false);
      }
      else {
        print("Logout failed");
      }
    } catch (e) {
      print(e);
    }
  }
}
