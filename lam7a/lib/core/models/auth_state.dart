import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/core/models/user_model.dart';
part 'auth_state.freezed.dart';
@freezed
class AuthState with _$AuthState {
  UserModel? user; // need to change 
  String? token;
  AuthState({this.token, this.user});
  bool isAuthenticated = false;

}