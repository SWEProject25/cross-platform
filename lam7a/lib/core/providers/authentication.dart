import 'package:lam7a/core/models/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication.g.dart';

// this is under developing not finished yet
@riverpod
class Authentication extends _$Authentication{
  @override
  dynamic build() {
    return AuthState();
  }

  Future<void> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    state = state.copyWith(token: token, isAuthenticated: token != null);
  }

  Future<void> authenticateUser(String token) async {
    if (token != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      state = state.copyWith(token: token, isAuthenticated: true);
    }
  }
  Future<void> logout() async
  {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      state = state.copyWith(token: null, isAuthenticated: false);
  }
}
