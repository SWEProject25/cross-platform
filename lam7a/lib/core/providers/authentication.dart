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
  @override
  AuthState build() {
    return AuthState();
  }

  Future<void> isAuthenticated(WidgetRef ref) async {
    try {
      state = state.copyWith(isLoading: true);
      final prefs = await SharedPreferences.getInstance();
      final _apiService = await ref.read(apiServiceProvider.future);
      final response = await _apiService.get(endpoint: ServerConstant.me);
      if (response['user'] != null) {
        UserModel? user = UserModel.fromJson(response["user"]);
        await authenticateUser(user);
      }
    } catch (e) {
      logout(ref);
      print(e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> authenticateUser(UserModel? user) async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      state = state.copyWith(token: null, isAuthenticated: true, user: user);
    }
  }

  Future<void> logout(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final _apiService = await ref.read(apiServiceProvider.future);
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
