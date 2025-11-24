// // lib/features/profile/repository/profile_repository.dart
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:lam7a/features/profile/dtos/profile_dto.dart';
// import 'package:lam7a/features/profile/model/profile_model.dart';
// import 'package:lam7a/features/profile/services/profile_api_service.dart';

// part 'profile_repository.g.dart';

// @Riverpod(keepAlive: true)
// ProfileRepository profileRepository(Ref ref) {
//   final api = ref.watch(profileApiServiceProvider);
//   return ProfileRepository(api);
// }

// class ProfileRepository {
//   final ProfileApiService _api;
//   ProfileRepository(this._api);

//   Future<ProfileModel> getProfile(String username) async {
//     final dto = await _api.getProfileByUsername(username);
//     return _mapDto(dto);
//   }

//   Future<ProfileModel> getMyProfile() async {
//     final dto = await _api.getMyProfile();
//     return _mapDto(dto);
//   }

//   Future<ProfileModel> updateMyProfile(
//     ProfileModel profile, {
//     String? avatarPath,
//     String? bannerPath,
//   }) async {

//     String avatarUrl = profile.avatarImage;
//     String bannerUrl = profile.bannerImage;

//     if (avatarPath != null && !avatarPath.startsWith("http")) {
//       avatarUrl = await _api.uploadProfilePicture(avatarPath);
//     }

//     if (bannerPath != null && !bannerPath.startsWith("http")) {
//       bannerUrl = await _api.uploadBanner(bannerPath);
//     }

//     final dto = await _api.updateMyProfile({
//       "name": profile.displayName,
//       "bio": profile.bio,
//       "location": profile.location,
//       "website": profile.website,
//       "birth_date": profile.birthday,
//       "profile_image_url": avatarUrl,
//       "banner_image_url": bannerUrl,
//     });

//     return _mapDto(dto);
//   }

//   Future<void> followUser(int id) => _api.followUser(id);
//   Future<void> unfollowUser(int id) => _api.unfollowUser(id);

//   Future<List<ProfileModel>> getFollowers(int id) async {
//     final list = await _api.getFollowers(id);
//     return list.map(_mapRawToProfileModel).toList();
//   }

//   Future<List<ProfileModel>> getFollowing(int id) async {
//     final list = await _api.getFollowing(id);
//     return list.map(_mapRawToProfileModel).toList();
//   }

//   // --------------------- DTO -> ProfileModel -----------------------
//   ProfileModel _mapDto(ProfileDto dto) {
//     return ProfileModel(
//       id: dto.id,
//       userId: dto.userId,
//       displayName: dto.name,
//       handle: dto.user?["username"] ?? "",
//       bio: dto.bio ?? "",
//       avatarImage: dto.profileImageUrl ?? "",
//       bannerImage: dto.bannerImageUrl ?? "",
//       location: dto.location ?? "",
//       birthday: dto.birthDate ?? "",
//       joinedDate: dto.createdAt ?? "",
//       website: dto.website ?? "",
//       isVerified: false, // backend doesn’t send this yet

//       followersCount: dto.followersCount ?? 0,
//       followingCount: dto.followingCount ?? 0,

//       stateFollow: (dto.isFollowedByMe ?? false)
//           ? ProfileStateOfFollow.following
//           : ProfileStateOfFollow.notfollowing,
//     );
//   }

//   // -------------------- FOLLOWERS RAW ---------------------
//   ProfileModel _mapRawToProfileModel(Map<String, dynamic> raw) {
//     return ProfileModel(
//       id: raw["id"] ?? 0,
//       userId: raw["user_id"] ?? 0,
//       displayName: raw["name"] ?? "",
//       handle: raw["username"] ?? "",
//       avatarImage: raw["profile_image_url"] ?? "",
//       bannerImage: raw["banner_image_url"] ?? "",
//       bio: raw["bio"] ?? "",
//       location: raw["location"] ?? "",
//       website: raw["website"] ?? "",
//       followersCount: raw["followers_count"] ?? 0,
//       followingCount: raw["following_count"] ?? 0,
//     );
//   }
// }
// lib/features/profile/repository/profile_repository.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
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
  Future<ProfileModel> getProfile(String username) async {
    final dto = await _api.getProfileByUsername(username);
    return _fromDto(dto);
  }

  // ---------------- GET MY PROFILE ----------------
  Future<ProfileModel> getMyProfile() async {
    final dto = await _api.getMyProfile();
    return _fromDto(dto);
  }

  // ---------------- UPDATE MY PROFILE ----------------
  Future<ProfileModel> updateMyProfile(
    ProfileModel profile, {
    String? avatarPath,
    String? bannerPath,
  }) async {

    String avatarUrl = profile.avatarImage;
    String bannerUrl = profile.bannerImage;

    if (avatarPath != null && !avatarPath.startsWith("http")) {
      avatarUrl = await _api.uploadProfilePicture(avatarPath);
    }

    if (bannerPath != null && !bannerPath.startsWith("http")) {
      bannerUrl = await _api.uploadBanner(bannerPath);
    }

    final dto = await _api.updateMyProfile({
      "name": profile.displayName,
      "bio": profile.bio,
      "location": profile.location,
      "website": profile.website,
      "birth_date": profile.birthday,
      "profile_image_url": avatarUrl,
      "banner_image_url": bannerUrl,
    });

    return _fromDto(dto);
  }

  // ---------------- FOLLOW / UNFOLLOW ----------------
  Future<void> followUser(int id) => _api.followUser(id);
  Future<void> unfollowUser(int id) => _api.unfollowUser(id);

  // ---------------- GET FOLLOWERS / FOLLOWING ----------------
  Future<List<ProfileModel>> getFollowers(int id) async {
    final list = await _api.getFollowers(id);
    return list.map(ProfileModel.fromRaw).toList();
  }

  Future<List<ProfileModel>> getFollowing(int id) async {
    final list = await _api.getFollowing(id);
    return list.map(ProfileModel.fromRaw).toList();
  }

  // ---------------- DTO → MODEL ----------------
  ProfileModel _fromDto(ProfileDto dto) {
    return ProfileModel(
      id: dto.id,
      userId: dto.userId,
      displayName: dto.name,
      handle: dto.user?["username"] ?? "",
      bio: dto.bio ?? "",
      avatarImage: dto.profileImageUrl ?? "",
      bannerImage: dto.bannerImageUrl ?? "",
      location: dto.location ?? "",
      birthday: dto.birthDate ?? "",
      joinedDate: dto.createdAt ?? "",
      website: dto.website ?? "",

      followersCount: dto.followersCount ?? 0,
      followingCount: dto.followingCount ?? 0,

      stateFollow: (dto.isFollowedByMe ?? false)
          ? ProfileStateOfFollow.following
          : ProfileStateOfFollow.notfollowing,
    );
  }
}
