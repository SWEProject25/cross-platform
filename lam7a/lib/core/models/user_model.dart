import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    int? id,
    int? profileId,
    String? username,
    String? email,
    String? role,
    String? name,
    String? birthDate,
    String? profileImageUrl,
    String? bannerImageUrl,
    String? bio,
    String? location,
    String? website,
    String? createdAt,
    @Default(0) int followersCount,
    @Default(0) int followingCount,

    @Default(ProfileStateOfFollow.notfollowing)
    ProfileStateOfFollow stateFollow,

    @Default(ProfileStateOfMute.notmuted)
    ProfileStateOfMute stateMute,

    @Default(ProfileStateBlocked.notblocked)
    ProfileStateBlocked stateBlocked,
  }) = _UserModel;
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
