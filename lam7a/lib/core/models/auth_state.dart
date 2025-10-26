import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/core/models/user_model.dart';
part 'auth_state.freezed.dart';
@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
     String? token,
     UserModel? user,
     @Default(false) bool isAuthenticated,
     
  }) = _AuthState;
}