// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EditProfileModel _$EditProfileModelFromJson(Map<String, dynamic> json) =>
    _EditProfileModel(
      displayName: json['displayName'] as String,
      bio: json['bio'] as String,
      location: json['location'] as String,
      avatarImage: json['avatarImage'] as String,
      bannerImage: json['bannerImage'] as String,
    );

Map<String, dynamic> _$EditProfileModelToJson(_EditProfileModel instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'bio': instance.bio,
      'location': instance.location,
      'avatarImage': instance.avatarImage,
      'bannerImage': instance.bannerImage,
    };
