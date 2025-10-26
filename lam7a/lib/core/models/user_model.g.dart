// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  username: json['username'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  name: json['name'] as String?,
  birthDate: json['birthDate'] as String?,
  profileImageUrl: json['profileImageUrl'] as String?,
  bannerImageUrl: json['bannerImageUrl'] as String?,
  bio: json['bio'] as String?,
  location: json['location'] as String?,
  website: json['website'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'name': instance.name,
      'birthDate': instance.birthDate,
      'profileImageUrl': instance.profileImageUrl,
      'bannerImageUrl': instance.bannerImageUrl,
      'bio': instance.bio,
      'location': instance.location,
      'website': instance.website,
      'createdAt': instance.createdAt,
    };
