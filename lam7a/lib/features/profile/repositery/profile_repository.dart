// lib/features/profile/repository/profile_repository.dart
import '../model/profile_model.dart';
import '../services/mock_profile_api_service.dart';

class ProfileRepository {
  final MockProfileAPIService? mockService;
  final bool useMock;

  ProfileRepository({
    this.mockService,
    this.useMock = true,
  });

  Future<ProfileModel> getProfile(String username) async {
    if (useMock) {
      if (mockService == null) {
        throw StateError('MockProfileAPIService is not provided.');
      }
      return await mockService!.fetchProfile(username);
    } else {
      // TODO: Replace with real API call
      throw UnimplementedError('Real API service not implemented yet.');
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    if (useMock) {
      if (mockService == null) {
        throw StateError('MockProfileAPIService is not provided.');
      }
      return await mockService!.updateProfile(profile);
    } else {
      throw UnimplementedError('Real API service not implemented yet.');
    }
  }

  Future<List<ProfileModel>> getProfiles() async {
    if (useMock) {
      if (mockService == null) {
        throw StateError('MockProfileAPIService is not provided.');
      }
      return await mockService!.fetchProfiles();
    } else {
      throw UnimplementedError('Real API service not implemented yet.');
    }
  }
}