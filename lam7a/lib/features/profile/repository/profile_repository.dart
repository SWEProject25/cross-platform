import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final api = ref.watch(profileApiServiceProvider);
  return ProfileRepository(api);
}

class ProfileRepository {
  final ProfileApiService _api;
  ProfileRepository(this._api);

  Future<ProfileModel> getProfile(String username) async {
    final dto = await _api.getProfileByUsername(username);
    return _mapDto(dto);
  }

  Future<ProfileModel> getMyProfile() async {
    final dto = await _api.getMyProfile();
    return _mapDto(dto);
  }

  Future<ProfileModel> updateMyProfile(ProfileModel profile, {String? avatarPath, String? bannerPath}) async {
    String avatarUrl = profile.avatarImage;
    String bannerUrl = profile.bannerImage;

    if (avatarPath != null && avatarPath.isNotEmpty && !avatarPath.startsWith('http')) {
      avatarUrl = await _api.uploadProfilePicture(avatarPath);
    }
    if (bannerPath != null && bannerPath.isNotEmpty && !bannerPath.startsWith('http')) {
      bannerUrl = await _api.uploadBanner(bannerPath);
    }

    final body = <String, dynamic>{
      'name': profile.displayName,
      'bio': profile.bio,
      'location': profile.location,
      if (avatarUrl.isNotEmpty) 'profileImageUrl': avatarUrl,
      if (bannerUrl.isNotEmpty) 'bannerImageUrl': bannerUrl,
      if (profile.website.isNotEmpty) 'website': profile.website,
    };

    final dto = await _api.updateMyProfile(body);
    return _mapDto(dto);
  }

  Future<void> followUser(int id) => _api.followUser(id);
  Future<void> unfollowUser(int id) => _api.unfollowUser(id);

  Future<List<ProfileModel>> getFollowers(int id) async {
    final raw = await _api.getFollowers(id);
    return raw.map((m) => _mapRawToProfileModel(m)).toList();
  }

  Future<List<ProfileModel>> getFollowing(int id) async {
    final raw = await _api.getFollowing(id);
    return raw.map((m) => _mapRawToProfileModel(m)).toList();
  }

  ProfileModel _mapDto(ProfileDto dto) {
    return ProfileModel(
      id: dto.id,
      userId: dto.userId,
      displayName: dto.name,
      handle: dto.user?['username'] ?? '',
      bio: dto.bio ?? '',
      avatarImage: dto.profileImageUrl ?? '',
      bannerImage: dto.bannerImageUrl ?? '',
      isVerified: dto.isDeactivated == true ? false : false,
      location: dto.location ?? '',
      birthday: dto.birthDate ?? '',
      joinedDate: dto.createdAt ?? '',
      followersCount: 0,
      followingCount: 0,
      website: dto.website ?? '',
    );
  }

  ProfileModel _mapRawToProfileModel(Map<String, dynamic> raw) {
    return ProfileModel(
      id: raw['id'] is int ? raw['id'] : int.tryParse(raw['id']?.toString() ?? '') ?? 0,
      userId: raw['id'] is int ? raw['id'] : int.tryParse(raw['id']?.toString() ?? '') ?? 0,
      displayName: raw['displayName'] ?? raw['name'] ?? '',
      handle: raw['username'] ?? raw['User']?['username'] ?? '',
      bio: raw['bio'] ?? '',
      avatarImage: raw['profileImageUrl'] ?? '',
      bannerImage: '',
      isVerified: false,
      location: '',
      birthday: '',
      joinedDate: raw['followedAt'] ?? '',
      followersCount: 0,
      followingCount: 0,
      website: '',
    );
  }
}
