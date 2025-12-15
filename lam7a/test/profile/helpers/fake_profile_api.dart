import 'package:lam7a/features/profile/services/profile_api_service.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';

class FakeProfileApiService implements ProfileApiService {
  /// ---------- Configurable test data ----------
  ProfileDto? profile;
  ProfileDto? myProfile;

  List<Map<String, dynamic>> followers = [];
  List<Map<String, dynamic>> following = [];

  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> replies = [];
  List<Map<String, dynamic>> likes = [];

  /// ---------- Call tracking (for assertions) ----------
  bool followCalled = false;
  bool unfollowCalled = false;
  bool muteCalled = false;
  bool unmuteCalled = false;
  bool blockCalled = false;
  bool unblockCalled = false;
  bool updateCalled = false;
  bool delayUpdate = false;
  bool throwOnUpdate = false;
  bool delayFollow = false;


  /// ---------- PROFILE ----------
  @override
  Future<ProfileDto> getProfileByUsername(String username) async {
    if (profile == null) {
      throw StateError('FakeProfileApiService.profile is null');
    }
    return profile!;
  }

  @override
  Future<ProfileDto> getMyProfile() async {
    if (myProfile == null) {
      throw StateError('FakeProfileApiService.myProfile is null');
    }
    return myProfile!;
  }

  @override
  Future<ProfileDto> updateMyProfile(Map<String, dynamic> data) async {
    if (delayUpdate) {
      await Future.delayed(const Duration(seconds: 1));
    }

    if (throwOnUpdate) {
      throw Exception('update failed');
    }

    updateCalled = true;

    return ProfileDto(
      id: 1,
      userId: 1,
      name: data['name'],
      bio: data['bio'],
      location: data['location'],
      website: data['website'],
      birthDate: data['birth_date'],
      profileImageUrl: data['profile_image_url'],
      bannerImageUrl: data['banner_image_url'],
      user: {'username': 'test'},
    );
  }


  /// ---------- MEDIA ----------
  @override
  Future<String> uploadProfilePicture(String path) async {
    return 'https://fake.cdn/avatar.png';
  }

  @override
  Future<String> uploadBanner(String path) async {
    return 'https://fake.cdn/banner.png';
  }

  /// ---------- FOLLOW / BLOCK ----------
  @override
  Future<void> followUser(int id) async {
    followCalled = true;
    if (delayFollow) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  @override
  Future<void> unfollowUser(int id) async {
    unfollowCalled = true;
  }

  @override
  Future<void> muteUser(int id) async {
    muteCalled = true;
  }

  @override
  Future<void> unmuteUser(int id) async {
    unmuteCalled = true;
  }

  @override
  Future<void> blockUser(int id) async {
    blockCalled = true;
  }

  @override
  Future<void> unblockUser(int id) async {
    unblockCalled = true;
  }

  /// ---------- FOLLOWERS ----------
  @override
  Future<List<Map<String, dynamic>>> getFollowers(int id) async {
    return followers;
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowing(int id) async {
    return following;
  }

  /// ---------- PAGINATION ----------
  @override
  Future<List<Map<String, dynamic>>> getProfilePosts(
    String userId,
    int page,
    int limit,
  ) async {
    return posts;
  }

  @override
  Future<List<Map<String, dynamic>>> getProfileReplies(
    String userId,
    int page,
    int limit,
  ) async {
    return replies;
  }

  @override
  Future<List<Map<String, dynamic>>> getProfileLikes(
    String userId,
    int page,
    int limit,
  ) async {
    return likes;
  }


}
