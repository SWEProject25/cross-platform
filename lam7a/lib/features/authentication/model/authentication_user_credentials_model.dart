import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_user_credentials_model.freezed.dart';
part 'authentication_user_credentials_model.g.dart';

@freezed
abstract class AuthenticationUserCredentialsModel with _$AuthenticationUserCredentialsModel {
  const factory AuthenticationUserCredentialsModel({
    required String email,
    required String password,
  }) = _AuthenticationUserCredentialsModel;

  // 👇 This enables fromJson
  factory AuthenticationUserCredentialsModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationUserCredentialsModelFromJson(json);
} 