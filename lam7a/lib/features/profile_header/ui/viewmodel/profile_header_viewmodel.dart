import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/profile_header_model.dart';
import '../../repository/profile_header_repository.dart';
import '../../../../core/services/mock_profile_api_service.dart';

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

  @override
  Future<ProfileHeaderModel> build() async {
    _repository = ref.read(profileRepositoryProvider);

    // You can load a default profile or wait for explicit username
    final profile = await _repository.getProfile('default_user');
    return profile;
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

  /// Example of how you might refresh the profile
  Future<void> refresh() async {
    final current = state.asData?.value;
    if (current == null) return;
    await loadProfileHeader(current.handle);
  }
}
