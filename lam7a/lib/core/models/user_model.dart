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

  /// ✔ Required by Freezed. This MUST stay exactly like this.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// ✔ Our custom backend mapping constructor
  factory UserModel.fromBackend(Map<String, dynamic> json) {
    final userSection = json['User'] ?? {};

    return UserModel(
      // -----------------------------
      // Correct ID mapping (fixes /posts/null)
      // -----------------------------
      id: json['user_id'] ?? json['id'] ?? userSection['id'],
      profileId: json['id'],

      // -----------------------------
      // User account section
      // -----------------------------
      username: userSection['username'],
      email: userSection['email'],
      role: userSection['role'],

      // -----------------------------
      // Profile fields
      // -----------------------------
      name: json['name'],
      birthDate: json['birth_date'],
      profileImageUrl: json['profile_image_url'],
      bannerImageUrl: json['banner_image_url'],
      bio: json['bio'],
      location: json['location'],
      website: json['website'],
      createdAt: json['created_at'],

      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,

      // -----------------------------
      // Relationship mapping
      // -----------------------------
      stateFollow: json['is_followed_by_me'] == true
          ? ProfileStateOfFollow.following
          : ProfileStateOfFollow.notfollowing,

      stateMute: json['is_muted_by_me'] == true
          ? ProfileStateOfMute.muted
          : ProfileStateOfMute.notmuted,

      stateBlocked: json['is_blocked_by_me'] == true
          ? ProfileStateBlocked.blocked
          : ProfileStateBlocked.notblocked,
    );
  }
}

enum ProfileStateOfFollow { following, notfollowing }
enum ProfileStateOfMute { muted, notmuted }
enum ProfileStateBlocked { blocked, notblocked }
