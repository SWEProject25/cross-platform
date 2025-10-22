import 'package:lam7a/core/services/mock_api_service.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  final MockAPIService _apiService;

  ProfileRepository(this._apiService);

  Future<List<ProfileModel>> getProfiles() async {
    return await _apiService.fetchProfiles();
  }
}
