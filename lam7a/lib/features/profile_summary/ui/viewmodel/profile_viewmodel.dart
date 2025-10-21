import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../model/profile_model.dart';
import '../../repository/profile_repository.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, List<ProfileModel>>((ref) {
  return ProfileViewModel(ProfileRepository());
});

class ProfileViewModel extends StateNotifier<List<ProfileModel>> {
  final ProfileRepository _repository;

  ProfileViewModel(this._repository) : super(_repository.getProfiles());

  void unfollow(String username) {
    state = state.where((p) => p.username != username).toList();
  }
}
