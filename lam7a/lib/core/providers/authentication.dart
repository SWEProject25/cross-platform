import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication.g.dart';

// this is under developing not finished yet
@Riverpod(keepAlive: true)
class Authentication extends _$Authentication{
  @override
  dynamic build() {
    return AuthState();
  }

  Future<void> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    state = state.copyWith(token: token, isAuthenticated: token != null);
    print(token);
  }

  Future<void> authenticateUser(String? token, UserModel user) async {
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
