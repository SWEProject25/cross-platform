// lib/ui/viewmodel/profile_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/profile_model.dart';
import '../../repositery/profile_repository.dart';
import '../../services/mock_profile_api_service.dart';

/// Provide the repository
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(
    mockService: MockProfileAPIService(),
    useMock: true,
  ),
);

/// Single Profile Provider (for viewing one profile)
final profileViewModelProvider = FutureProvider.family<ProfileModel, String>(
  (ref, userId) async {
    final repository = ref.read(profileRepositoryProvider);
    return repository.getProfile(userId);
  },
);

/// State provider for managing profile updates - using a Map to store by userId
final profileStateMapProvider = NotifierProvider<ProfileStateMapNotifier, Map<String, AsyncValue<ProfileModel>>>(
  ProfileStateMapNotifier.new,
);

/// List of Profiles Provider
final profileListViewModelProvider = FutureProvider<List<ProfileModel>>(
  (ref) async {
    final repository = ref.read(profileRepositoryProvider);
    return repository.getProfiles();
  },
);

/// State provider for managing profile list
final profileListStateProvider = NotifierProvider<ProfileListStateNotifier, List<ProfileModel>?>(
  ProfileListStateNotifier.new,
);

/// Notifier for profile state map (stores multiple profiles by userId)
class ProfileStateMapNotifier extends Notifier<Map<String, AsyncValue<ProfileModel>>> {
  @override
  Map<String, AsyncValue<ProfileModel>> build() {
    return {};
  }

  void setStateForUser(String userId, AsyncValue<ProfileModel> value) {
    state = {...state, userId: value};
  }

  AsyncValue<ProfileModel>? getStateForUser(String userId) {
    return state[userId];
  }
}

/// Notifier for profile list state
class ProfileListStateNotifier extends Notifier<List<ProfileModel>?> {
  @override
  List<ProfileModel>? build() {
    return null;
  }

  void setState(List<ProfileModel> value) {
    state = value;
  }
}

/// Extension methods for profile operations
extension ProfileOperations on WidgetRef {
  /// Update profile
  Future<void> updateProfile(String userId, ProfileModel updatedProfile) async {
    final repository = read(profileRepositoryProvider);
    
    read(profileStateMapProvider.notifier).setStateForUser(userId, const AsyncValue.loading());
    
    try {
      final updated = await repository.updateProfile(updatedProfile);
      read(profileStateMapProvider.notifier).setStateForUser(userId, AsyncValue.data(updated));
      invalidate(profileViewModelProvider(userId));
    } catch (e, st) {
      read(profileStateMapProvider.notifier).setStateForUser(userId, AsyncValue.error(e, st));
    }
  }

  /// Toggle follow state
  void toggleFollow(String userId, ProfileModel currentProfile) {
    final newState = currentProfile.stateFollow == ProfileStateOfFollow.following
        ? ProfileStateOfFollow.notfollowing
        : ProfileStateOfFollow.following;

    final updated = currentProfile.copyWith(stateFollow: newState);
    read(profileStateMapProvider.notifier).setStateForUser(userId, AsyncValue.data(updated));
  }

  /// Refresh profile
  Future<void> refreshProfile(String userId) async {
    invalidate(profileViewModelProvider(userId));
  }

  /// Toggle follow in list
  void toggleFollowInList(String handle) {
    final currentList = read(profileListStateProvider);
    if (currentList == null) return;

    final updated = currentList.map((profile) {
      if (profile.handle == handle) {
        final newState = profile.stateFollow == ProfileStateOfFollow.following
            ? ProfileStateOfFollow.notfollowing
            : ProfileStateOfFollow.following;
        return profile.copyWith(stateFollow: newState);
      }
      return profile;
    }).toList();

    read(profileListStateProvider.notifier).setState(updated);
  }

  /// Remove profile from list
  void removeProfileFromList(String handle) {
    final currentList = read(profileListStateProvider);
    if (currentList == null) return;

    read(profileListStateProvider.notifier).setState(
        currentList.where((p) => p.handle != handle).toList());
  }
}