import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'profile_api_service.dart';

class ProfileApiServiceImpl implements ProfileApiService {
  final Ref ref;
  ProfileApiServiceImpl(this.ref);

  ApiService get _api => ref.read(apiServiceProvider);

  @override
  Future<ProfileDto> getProfileByUsername(String username) async {
    final res = await _api.get(endpoint: "/api/v1.0/profile/username/$username");
    // ApiService returns either a full envelope or inner data — handle both:
    final data = (res is Map && res.containsKey('data')) ? res['data'] : res;
    return ProfileDto.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<ProfileDto> getMyProfile() async {
    final res = await _api.get(endpoint: "/api/v1.0/profile/me");
    final data = (res is Map && res.containsKey('data')) ? res['data'] : res;
    return ProfileDto.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<ProfileDto> updateMyProfile(Map<String, dynamic> body) async {
    final res = await _api.patch(endpoint: "/api/v1.0/profile/me", data: body);
    final data = (res is Map && res.containsKey('data')) ? res['data'] : res;
    return ProfileDto.fromJson(Map<String, dynamic>.from(data));
  }

  Future<String> _extractUploadUrl(dynamic res) {
    if (res is Map && res.containsKey('data')) {
      final data = res['data'];
      if (data is Map && data.containsKey('profileImageUrl')) return Future.value(data['profileImageUrl'] as String);
      if (data is Map && data.containsKey('bannerImageUrl')) return Future.value(data['bannerImageUrl'] as String);
      if (data is Map && data.containsKey('url')) return Future.value(data['url'] as String);
    }
    // fallback: try to find any string url
    if (res is Map) {
      for (final v in res.values) {
        if (v is String && v.startsWith('http')) return Future.value(v);
      }
    }
    return Future.value('');
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _api.post(endpoint: "/api/v1.0/profile/me/profile-picture", data: form);
    return _extractUploadUrl(res);
  }

  @override
  Future<String> uploadBanner(String filePath) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _api.post(endpoint: "/api/v1.0/profile/me/banner", data: form);
    return _extractUploadUrl(res);
  }

  @override
  Future<void> followUser(int id) async {
    await _api.post(endpoint: "/api/v1.0/users/$id/follow");
  }

  @override
  Future<void> unfollowUser(int id) async {
    await _api.delete(endpoint: "/api/v1.0/users/$id/follow");
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowers(int id, {int page = 1, int limit = 20}) async {
    final res = await _api.get(endpoint: "/api/v1.0/users/$id/followers", queryParameters: {'page': page, 'limit': limit});
    final list = (res is Map && res.containsKey('data')) ? res['data'] : res;
    return List<Map<String, dynamic>>.from(list as List);
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowing(int id, {int page = 1, int limit = 20}) async {
    final res = await _api.get(endpoint: "/api/v1.0/users/$id/following", queryParameters: {'page': page, 'limit': limit});
    final list = (res is Map && res.containsKey('data')) ? res['data'] : res;
    return List<Map<String, dynamic>>.from(list as List);
  }
}
