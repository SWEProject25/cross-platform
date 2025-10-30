import 'package:lam7a/features/profile_features/services/mockProfileSammary_api_service.dart';
import '../model/profile_model.dart';

class ProfileRepository {
  final MockAPIService _apiService;

  ProfileRepository(this._apiService);

  Future<List<ProfileModel>> getProfiles() async {
    return await _apiService.fetchProfiles();
  }
}
