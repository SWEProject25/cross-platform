// // profile_model.dart
// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'profile_model.freezed.dart';
// part 'profile_model.g.dart';

// @freezed
// abstract class ProfileModel with _$ProfileModel {
//   const factory ProfileModel({
//     required int id,
//     required int userId,
//     required String displayName,
//     required String handle,
//     @Default('') String bio,
//     @Default('') String avatarImage,
//     @Default('') String bannerImage,
//     @Default(false) bool isVerified,
//     @Default('') String location,
//     @Default('') String birthday,
//     @Default('') String joinedDate,
//     @Default(0) int followersCount,
//     @Default(0) int followingCount,
//     @Default('') String website,
//     @Default(ProfileStateOfFollow.notfollowing) ProfileStateOfFollow stateFollow,
//     @Default(ProfileStateOfMute.notmuted) ProfileStateOfMute stateMute,
//     @Default(ProfileStateBlocked.notblocked) ProfileStateBlocked stateBlocked,
//   }) = _ProfileModel;

//   factory ProfileModel.fromJson(Map<String, dynamic> json) =>
//       _$ProfileModelFromJson(json);
// }

// enum ProfileStateOfFollow { following, notfollowing }
// enum ProfileStateOfMute { muted, notmuted }
// enum ProfileStateBlocked { blocked, notblocked }
// lib/features/profile/model/profile_model.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required int id,
    required int userId,
    required String displayName,
    required String handle,

    @Default('') String bio,
    @Default('') String avatarImage,
    @Default('') String bannerImage,

    @Default(false) bool isVerified,
    @Default('') String location,
    @Default('') String birthday,
    @Default('') String joinedDate,
    @Default('') String website,

    @Default(0) int followersCount,
    @Default(0) int followingCount,

    @Default(ProfileStateOfFollow.notfollowing)
    ProfileStateOfFollow stateFollow,

    @Default(ProfileStateOfMute.notmuted)
    ProfileStateOfMute stateMute,

    @Default(ProfileStateBlocked.notblocked)
    ProfileStateBlocked stateBlocked,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  /// ---------------- RAW API → MODEL ----------------
  factory ProfileModel.fromRaw(Map<String, dynamic> raw) {
    return ProfileModel(
      id: raw["id"] ?? 0,
      userId: raw["user_id"] ?? 0,
      displayName: raw["name"] ?? "",
      handle: raw["username"] ?? "",
      avatarImage: raw["profile_image_url"] ?? "",
      bannerImage: raw["banner_image_url"] ?? "",
      bio: raw["bio"] ?? "",
      location: raw["location"] ?? "",
      website: raw["website"] ?? "",
      followersCount: raw["followers_count"] ?? 0,
      followingCount: raw["following_count"] ?? 0,
    );
  }
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
