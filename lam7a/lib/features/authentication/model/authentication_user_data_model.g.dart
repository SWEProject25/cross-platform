// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_user_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticationUserDataModel _$AuthenticationUserDataModelFromJson(
  Map<String, dynamic> json,
) => _AuthenticationUserDataModel(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  birth_date: json['birth_date'] as String,
);

Map<String, dynamic> _$AuthenticationUserDataModelToJson(
  _AuthenticationUserDataModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'birth_date': instance.birth_date,
};
