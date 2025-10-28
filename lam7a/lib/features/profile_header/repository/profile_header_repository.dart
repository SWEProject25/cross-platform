import '../model/profile_header_model.dart';
import '../../../core/services/mock_profile_api_service.dart';

class ProfileRepository {
  final MockProfileAPIService? mockService;
  final bool useMock;

  ProfileRepository({
  
    this.mockService,
    this.useMock = true,
  });

  Future<ProfileHeaderModel> getProfile(String username) async {
    if (useMock) {
      return await mockService!.fetchProfile(username);
    } else {
      // Here you would implement the real API call
      throw UnimplementedError('Real API service not implemented yet.');
    }
  }
}
