import '../../profile/model/profile_model.dart';
import '../../services/mock_profile_api_service.dart';

class EditProfileRepository {
  final MockProfileAPIService mockService;

  EditProfileRepository({required this.mockService});

  Future<ProfileHeaderModel> getProfile(String username) async {
    return await mockService.fetchProfile(username);
  }

  Future<ProfileHeaderModel> updateProfile(ProfileHeaderModel profile) async {
    return await mockService.updateProfile(profile);
  }
}
