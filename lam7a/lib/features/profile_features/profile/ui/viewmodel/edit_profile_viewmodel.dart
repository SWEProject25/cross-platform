import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile_features/profile/model/profile_model.dart';
import '../../repositery/edit_profile_repository.dart';
import '../../../services/mock_profile_api_service.dart';

final editProfileRepositoryProvider = Provider<EditProfileRepository>(
  (ref) => EditProfileRepository(
    mockService: MockProfileAPIService(),
  ),
);

final editProfileViewModelProvider =
    AsyncNotifierProvider<EditProfileViewModel, ProfileHeaderModel>(
        EditProfileViewModel.new);

class EditProfileViewModel extends AsyncNotifier<ProfileHeaderModel> {
  late final EditProfileRepository _repository;

  @override
  Future<ProfileHeaderModel> build() async {
    _repository = ref.read(editProfileRepositoryProvider);
    return await _repository.getProfile('hossam_dev');
  }

  Future<void> saveProfile(ProfileHeaderModel updated) async {
    state = const AsyncLoading();
    try {
      final updatedProfile = await _repository.updateProfile(updated);
      state = AsyncData(updatedProfile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
