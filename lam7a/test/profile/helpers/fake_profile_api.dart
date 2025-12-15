import 'package:lam7a/features/profile/services/profile_api_service.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';

class FakeProfileApiService implements ProfileApiService {
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> likes = [];
  List<Map<String, dynamic>> replies = [];

  ProfileDto? profile;

  // -------- PROFILE --------
  @override
  Future<ProfileDto> getProfileByUsername(String username) async {
    return profile!;
  }

  @override
  Future<ProfileDto> getMyProfile() async {
    return profile!;
  }

  // -------- PAGINATION --------
  @override
  Future<List<Map<String, dynamic>>> getProfilePosts(
    String userId,
    int page,
    int limit,
  ) async {
    return posts;
  }

  @override
  Future<List<Map<String, dynamic>>> getProfileLikes(
    String userId,
    int page,
    int limit,
  ) async {
    return likes;
  }

  @override
  Future<List<Map<String, dynamic>>> getProfileReplies(
    String userId,
    int page,
    int limit,
  ) async {
    return replies;
  }

  // -------- UNUSED METHODS (safe no-op) --------
  @override
  Future<void> followUser(int id) async {}

  @override
  Future<void> unfollowUser(int id) async {}

  @override
  Future<void> muteUser(int id) async {}

  @override
  Future<void> unmuteUser(int id) async {}

  @override
  Future<void> blockUser(int id) async {}

  @override
  Future<void> unblockUser(int id) async {}

  @override
  Future<List<Map<String, dynamic>>> getFollowers(int id) async => [];

  @override
  Future<List<Map<String, dynamic>>> getFollowing(int id) async => [];

  @override
  Future<String> uploadProfilePicture(String path) async => path;

  @override
  Future<String> uploadBanner(String path) async => path;

  @override
  Future<ProfileDto> updateMyProfile(Map<String, dynamic> body) async {
    return ProfileDto(
      id: 1,
      userId: 1,
      name: body['name'],
      bio: body['bio'],
      location: body['location'],
      website: body['website'],
      birthDate: body['birth_date'],
      profileImageUrl: body['profile_image_url'],
      bannerImageUrl: body['banner_image_url'],
      followersCount: 0,
      followingCount: 0,
    );
  }

}
