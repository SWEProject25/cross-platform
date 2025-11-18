import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model2/profile_model.dart';
import '../../repositery/profile_repository.dart';
import '../../../services/mockProfileSammary_api_service.dart';

final profileRepositoryProvider = Provider(
  (ref) => ProfileRepository(MockAPIService()),
);

final profileViewModelProvider =
    AsyncNotifierProvider<ProfileViewModel, List<ProfileModel>>(
  ProfileViewModel.new,
);

class ProfileViewModel extends AsyncNotifier<List<ProfileModel>> {
  late final ProfileRepository _repository;

  @override
  Future<List<ProfileModel>> build() async {
    _repository = ref.read(profileRepositoryProvider);
    final profiles = await _repository.getProfiles();
    return profiles;
  }

  void toggleFollow(String username) {
    final List<ProfileModel> current = state.value ?? [];
    final List<ProfileModel> updated = current.map((profile) {
      if (profile.username == username) {
        return profile.copyWith(
          stateFollow: profile.stateFollow == ProfileStateOfFollow.following
              ? ProfileStateOfFollow.notfollowing
              : ProfileStateOfFollow.following,
        );
      }
      return profile;
    }).toList();

    state = AsyncData(updated);
  }

  void unfollow(String username) {
    final currentState = state.value ?? [];
    state = AsyncData(
      currentState.where((p) => p.username != username).toList(),
    );
  }
}
