import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile/model/profile_model.dart';
import '../../repository/profile_header_repository.dart';
import '../../../services/mock_profile_api_service.dart';

/// Provide the repository — use mock or real service
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    mockService: MockProfileAPIService(),
    useMock: true,
  ),
);

/// AsyncNotifierProvider for ProfileHeaderViewModel
final profileHeaderViewModelProvider =
    AsyncNotifierProvider<ProfileHeaderViewModel, ProfileHeaderModel>(
  ProfileHeaderViewModel.new,
);

class ProfileHeaderViewModel extends AsyncNotifier<ProfileHeaderModel> {
  late final ProfileRepository _repository;
  void updateProfile(ProfileHeaderModel updatedProfile) {
  state = AsyncData(updatedProfile);
}


  @override
  Future<ProfileHeaderModel> build() async {
    _repository = ref.read(profileRepositoryProvider);
    // Load a default or mock user (must exist in your mock data)
    return _repository.getProfile('hossam_dev');
  }

  /// Load a specific profile header by username
  Future<void> loadProfileHeader(String username) async {
    state = const AsyncLoading();
    try {
      final profile = await _repository.getProfile(username);
      state = AsyncData(profile);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Refresh current user profile
  Future<void> refresh() async {
    final current = state.asData?.value;
    if (current == null) return;
    await loadProfileHeader(current.handle);
  }
}
