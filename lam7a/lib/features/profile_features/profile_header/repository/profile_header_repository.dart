import '../../profile/model/profile_model.dart';
import '../../services/mock_profile_api_service.dart';

class ProfileRepository {
  final MockProfileAPIService? mockService;
  final bool useMock;

  ProfileRepository({
    this.mockService,
    this.useMock = true,
  });

  Future<ProfileHeaderModel> getProfile(String username) async {
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
}
