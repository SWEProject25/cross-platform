// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileHeaderModel _$ProfileHeaderModelFromJson(Map<String, dynamic> json) =>
    _ProfileHeaderModel(
      bannerImage: json['bannerImage'] as String,
      avatarImage: json['avatarImage'] as String,
      displayName: json['displayName'] as String,
      handle: json['handle'] as String,
      bio: json['bio'] as String,
      location: json['location'] as String,
      joinedDate: json['joinedDate'] as String,
      mutualFollowers: (json['mutualFollowers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$ProfileHeaderModelToJson(_ProfileHeaderModel instance) =>
    <String, dynamic>{
      'bannerImage': instance.bannerImage,
      'avatarImage': instance.avatarImage,
      'displayName': instance.displayName,
      'handle': instance.handle,
      'bio': instance.bio,
      'location': instance.location,
      'joinedDate': instance.joinedDate,
      'mutualFollowers': instance.mutualFollowers,
      'isVerified': instance.isVerified,
    };
