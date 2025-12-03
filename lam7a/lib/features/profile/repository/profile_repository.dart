// lib/features/profile/repository/profile_repository.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
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

  // ================== GET PROFILE ==================
  Future<UserModel> getProfile(String username) async {
    final dto = await _api.getProfileByUsername(username);
    return _mapDtoToUser(dto);
  }

  Future<UserModel> getMyProfile() async {
    final dto = await _api.getMyProfile();
    return _mapDtoToUser(dto);
  }

  // ================== UPDATE PROFILE ==================
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

    return _mapDtoToUser(dto);
  }

  // ================== FOLLOW SYSTEM ==================
  Future<void> followUser(int id) => _api.followUser(id);
  Future<void> unfollowUser(int id) => _api.unfollowUser(id);

  // ================== FOLLOWERS / FOLLOWING ==================
  Future<List<UserModel>> getFollowers(int id) async {
    final list = await _api.getFollowers(id);
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<List<UserModel>> getFollowing(int id) async {
    final list = await _api.getFollowing(id);
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  // ================== DTO → USER MODEL ==================
  UserModel _mapDtoToUser(ProfileDto dto) {
    return UserModel(
      id: dto.userId,
      profileId: dto.id,
      
      username: dto.user?["username"],
      name: dto.name,
      
      birthDate: dto.birthDate,
      bio: dto.bio,
      location: dto.location,
      website: dto.website,
      createdAt: dto.createdAt,

      profileImageUrl: dto.profileImageUrl,
      bannerImageUrl: dto.bannerImageUrl,

      followersCount: dto.user?["followers_count"] ?? dto.followersCount ?? 0,
      followingCount: dto.user?["following_count"] ?? dto.followingCount ?? 0,

      stateFollow: (dto.isFollowedByMe ?? false)
          ? ProfileStateOfFollow.following
          : ProfileStateOfFollow.notfollowing,
    );
  }
}
