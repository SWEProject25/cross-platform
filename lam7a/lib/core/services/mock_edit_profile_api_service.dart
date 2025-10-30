import 'dart:async';
import '../../features/profile_features/profile_edit/model/edit_profile_model.dart';

class MockEditProfileAPIService {
  EditProfileModel _mockProfile = const EditProfileModel(
    displayName: 'Hossam Mohamed',
    bio: 'Flutter Developer | Coffee Lover ☕',
    location: 'Cairo, Egypt',
    avatarImage: 'https://picsum.photos/200?random=3',
    bannerImage: 'https://picsum.photos/800/200?random=4',
  );

  Future<EditProfileModel> fetchProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockProfile;
  }

  Future<EditProfileModel> updateProfile(EditProfileModel newProfile) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockProfile = newProfile;
    return _mockProfile;
  }
}
