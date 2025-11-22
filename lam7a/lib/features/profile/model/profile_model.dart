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
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @Default('') String website,
    @Default(ProfileStateOfFollow.notfollowing) ProfileStateOfFollow stateFollow,
    @Default(ProfileStateOfMute.notmuted) ProfileStateOfMute stateMute,
    @Default(ProfileStateBlocked.notblocked) ProfileStateBlocked stateBlocked,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
