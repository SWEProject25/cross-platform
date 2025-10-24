import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_user_data_model.freezed.dart';
part 'authentication_user_data_model.g.dart';

@freezed
abstract class AuthenticationUserDataModel with _$AuthenticationUserDataModel {
  const factory AuthenticationUserDataModel({
    required String name,
    required String email,
    required String password,
    required String birth_date,
  }) = _AuthenticationUserDataModel;

  // 👇 This enables fromJson
  factory AuthenticationUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationUserDataModelFromJson(json);
}