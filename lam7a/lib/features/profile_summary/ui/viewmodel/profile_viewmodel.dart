import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/profile_model.dart';
import '../../repository/profile_repository.dart';
import '../../../../core/services/mockProfileSammary_api_service.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(MockAPIService()),
);


final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, List<ProfileModel>>(ProfileViewModel.new);


class ProfileViewModel extends AsyncNotifier<List<ProfileModel>> {
  late final ProfileRepository _repository;

  @override
  Future<List<ProfileModel>> build() async {
    _repository = ref.read(profileRepositoryProvider);
    final profiles = await _repository.getProfiles();
    return profiles;
  }

  void unfollow(String username) {
    final currentState = state.value ?? [];
    state = AsyncData(currentState.where((p) => p.username != username).toList());
  }
}
