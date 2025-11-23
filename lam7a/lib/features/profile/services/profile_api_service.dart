// // profile_api_service.dart
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:lam7a/features/profile/dtos/profile_dto.dart';
// import 'profile_api_service_impl.dart';

// part 'profile_api_service.g.dart';

// @riverpod
// ProfileApiService profileApiService(Ref ref) => ProfileApiServiceImpl(ref);

// abstract class ProfileApiService {
//   Future<ProfileDto> getProfileByUsername(String username);
//   Future<ProfileDto> getMyProfile();
//   Future<ProfileDto> updateMyProfile(Map<String, dynamic> body);
//   Future<String> uploadProfilePicture(String filePath);
//   Future<String> uploadBanner(String filePath);
//   Future<void> followUser(int id);
//   Future<void> unfollowUser(int id);
//   Future<List<Map<String, dynamic>>> getFollowers(int id, {int page = 1, int limit = 20});
//   Future<List<Map<String, dynamic>>> getFollowing(int id, {int page = 1, int limit = 20});
// }
// profile_api_service.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'profile_api_service_impl.dart';

part 'profile_api_service.g.dart';

@Riverpod(keepAlive: true)
ProfileApiService profileApiService(Ref ref) {
  return ProfileApiServiceImpl(ref);
}

abstract class ProfileApiService {
  Future<ProfileDto> getProfileByUsername(String username);
  Future<ProfileDto> getMyProfile();
  Future<ProfileDto> updateMyProfile(Map<String, dynamic> body);
  Future<String> uploadProfilePicture(String filePath);
  Future<String> uploadBanner(String filePath);
  Future<void> followUser(int id);
  Future<void> unfollowUser(int id);
  Future<List<Map<String, dynamic>>> getFollowers(int id);
  Future<List<Map<String, dynamic>>> getFollowing(int id);
}
