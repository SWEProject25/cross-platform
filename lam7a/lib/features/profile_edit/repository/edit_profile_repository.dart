import '../../../core/services/mock_edit_profile_api_service.dart';
import '../model/edit_profile_model.dart';

class EditProfileRepository {
  final MockEditProfileAPIService mockService;

  EditProfileRepository({required this.mockService});

  Future<EditProfileModel> getProfile() async {
    return await mockService.fetchProfile();
  }

  Future<EditProfileModel> updateProfile(EditProfileModel profile) async {
    return await mockService.updateProfile(profile);
  }
}
