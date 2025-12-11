// lib/features/profile/repository/profile_repository.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'package:lam7a/features/profile/dtos/follow_user_dto.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';

part 'profile_repository.g.dart';

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final api = ref.watch(profileApiServiceProvider);
  return ProfileRepository(api);
}

class ProfileRepository {
  final ProfileApiService _api;

  ProfileRepository(this._api);

  // ---------------- GET PROFILE BY USERNAME ----------------
  Future<UserModel> getProfile(String username) async {
    final dto = await _api.getProfileByUsername(username);
    return _fromDto(dto);
  }

  // ---------------- GET MY PROFILE ----------------
  Future<UserModel> getMyProfile() async {
    final dto = await _api.getMyProfile();
    return _fromDto(dto);
  }

  // ---------------- UPDATE MY PROFILE ----------------
  Future<UserModel> updateMyProfile(
    UserModel user, {
    String? avatarPath,
    String? bannerPath,
  }) async {
    String avatarUrl = user.profileImageUrl ?? "";
    String bannerUrl = user.bannerImageUrl ?? "";

    if (avatarPath != null && !avatarPath.startsWith("http")) {
      avatarUrl = await _api.uploadProfilePicture(avatarPath);
    }

    if (bannerPath != null && !bannerPath.startsWith("http")) {
      bannerUrl = await _api.uploadBanner(bannerPath);
    }

    final dto = await _api.updateMyProfile({
      "name": user.name,
      "bio": user.bio,
      "location": user.location,
      "website": user.website,
      "birth_date": user.birthDate,
      "profile_image_url": avatarUrl,
      "banner_image_url": bannerUrl,
    });

    return _fromDto(dto);
  }

  // ---------------- FOLLOW / UNFOLLOW ----------------
  Future<void> followUser(int id) => _api.followUser(id);
  Future<void> unfollowUser(int id) => _api.unfollowUser(id);

  // ------------ MUTE / UNMUTE ------------
  Future<void> muteUser(int id) => _api.muteUser(id);
  Future<void> unmuteUser(int id) => _api.unmuteUser(id);

  // ------------ BLOCK / UNBLOCK ----------
  Future<void> blockUser(int id) => _api.blockUser(id);
  Future<void> unblockUser(int id) => _api.unblockUser(id);


  // ---------------- GET FOLLOWERS / FOLLOWING ----------------
  /// These endpoints return a list of lightweight "user" objects (not full profile DTOs).
  /// We parse them with FollowUserDto and convert to UserModel.
  Future<List<UserModel>> getFollowers(int id) async {
    final list = await _api.getFollowers(id);
    // list is List<Map<String, dynamic>>
    return list.map<UserModel>((raw) {
      final f = FollowUserDto.fromJson(Map<String, dynamic>.from(raw));
      return UserModel(
        id: f.id,
        username: f.username,
        name: f.name,
        bio: f.bio,
        profileImageUrl: f.profileImageUrl,
        // conservative defaults for counts / other states
        followersCount: 0,
        followingCount: 0,
        stateFollow: (f.isFollowedByMe ?? false)
            ? ProfileStateOfFollow.following
            : ProfileStateOfFollow.notfollowing,
        stateFollowingMe: (f.isFollowingMe ?? false)
            ? ProfileStateFollowingMe.followingme
            : ProfileStateFollowingMe.notfollowingme,
      );
    }).toList();
  }

  Future<List<UserModel>> getFollowing(int id) async {
    final list = await _api.getFollowing(id);
    return list.map<UserModel>((raw) {
      final f = FollowUserDto.fromJson(Map<String, dynamic>.from(raw));
      return UserModel(
        id: f.id,
        username: f.username,
        name: f.name,
        bio: f.bio,
        profileImageUrl: f.profileImageUrl,
        followersCount: 0,
        followingCount: 0,
        stateFollow: (f.isFollowedByMe ?? false)
            ? ProfileStateOfFollow.following
            : ProfileStateOfFollow.notfollowing,
        stateFollowingMe: (f.isFollowingMe ?? false)
            ? ProfileStateFollowingMe.followingme
            : ProfileStateFollowingMe.notfollowingme,
      );
    }).toList();
  }

  // ---------------- DTO → USER MODEL (full profile) ----------------
  UserModel _fromDto(ProfileDto dto) {
    return UserModel(
      id: dto.id,
      profileId: dto.userId,
      username: dto.user?["username"],
      name: dto.name,
      birthDate: dto.birthDate,
      bio: dto.bio,
      location: dto.location,
      website: dto.website,
      createdAt: dto.createdAt,
      profileImageUrl: dto.profileImageUrl,
      bannerImageUrl: dto.bannerImageUrl,
      followersCount: dto.followersCount ?? 0,
      followingCount: dto.followingCount ?? 0,
      stateFollow: (dto.isFollowedByMe ?? false)
          ? ProfileStateOfFollow.following
          : ProfileStateOfFollow.notfollowing,
      // if backend returns these fields for full profile
      stateMute: (dto.toJson().containsKey('is_muted_by_me') && dto.toJson()['is_muted_by_me'] == true)
          ? ProfileStateOfMute.muted
          : ProfileStateOfMute.notmuted,
      stateBlocked: (dto.toJson().containsKey('is_blocked_by_me') && dto.toJson()['is_blocked_by_me'] == true)
          ? ProfileStateBlocked.blocked
          : ProfileStateBlocked.notblocked,

      stateFollowingMe: (dto.toJson().containsKey('is_following_me') && dto.toJson()['is_following_me'] == true)
          ? ProfileStateFollowingMe.followingme
          : ProfileStateFollowingMe.notfollowingme,
    );
  }
}
