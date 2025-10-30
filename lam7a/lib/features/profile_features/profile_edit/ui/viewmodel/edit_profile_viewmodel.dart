import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/edit_profile_repository.dart';
import '../../model/edit_profile_model.dart';
import '../../../../../core/services/mock_edit_profile_api_service.dart';

final editProfileRepositoryProvider = Provider<EditProfileRepository>(
  (ref) => EditProfileRepository(mockService: MockEditProfileAPIService()),
);

final editProfileViewModelProvider =
    AsyncNotifierProvider<EditProfileViewModel, EditProfileModel>(
        EditProfileViewModel.new);

class EditProfileViewModel extends AsyncNotifier<EditProfileModel> {
  late final EditProfileRepository _repository;

  @override
  Future<EditProfileModel> build() async {
    _repository = ref.read(editProfileRepositoryProvider);
    return await _repository.getProfile();
  }

  Future<void> saveProfile(EditProfileModel updated) async {
    state = const AsyncLoading();
    try {
      final updatedProfile = await _repository.updateProfile(updated);
      state = AsyncData(updatedProfile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
