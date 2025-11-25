// profile_api_service_impl.dart
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
    final res = await _api.get(endpoint: "/profile/username/$username");
    return ProfileDto.fromJson(_extractObject(res));
  }

  @override
  Future<ProfileDto> getMyProfile() async {
    final res = await _api.get(endpoint: "/profile/me");
    return ProfileDto.fromJson(_extractObject(res));
  }

  @override
  Future<ProfileDto> updateMyProfile(Map<String, dynamic> body) async {
    final res = await _api.patch(endpoint: "/profile/me", data: body);
    return ProfileDto.fromJson(_extractObject(res));
  }

  // -------------------- Helpers --------------------

  /// Extract JSON object `{ ... }`
  Map<String, dynamic> _extractObject(dynamic res) {
    if (res is Map && res.containsKey("data")) {
      return Map<String, dynamic>.from(res["data"]);
    }
    return Map<String, dynamic>.from(res);
  }

  /// Extract JSON list `[ ... ]`
  List<Map<String, dynamic>> _extractList(dynamic res) {
    if (res is Map && res.containsKey("data")) {
      return List<Map<String, dynamic>>.from(res["data"]);
    }
    return List<Map<String, dynamic>>.from(res);
  }

  Future<String> _extractUploadUrl(dynamic res) {
    final data = _extractObject(res);

    return Future.value(
      data["profile_image_url"] ??
      data["banner_image_url"] ??
      data["url"] ??
      "",
    );
  }

  // -------------------- Uploads --------------------

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    final res = await _api.post(endpoint: "/profile/me/profile-picture", data: form);
    return _extractUploadUrl(res);
  }

  @override
  Future<String> uploadBanner(String filePath) async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(filePath)});
    final res = await _api.post(endpoint: "/profile/me/banner", data: form);
    return _extractUploadUrl(res);
  }

  // -------------------- Follow System --------------------

  @override
  Future<void> followUser(int id) async {
    await _api.post(endpoint: "/users/$id/follow");
  }

  @override
  Future<void> unfollowUser(int id) async {
    await _api.delete(endpoint: "/users/$id/follow");
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowers(int id) async {
    final res = await _api.get(endpoint: "/users/$id/followers");
    return _extractList(res);
  }

  @override
  Future<List<Map<String, dynamic>>> getFollowing(int id) async {
    final res = await _api.get(endpoint: "/users/$id/following");
    return _extractList(res);
  }
}
