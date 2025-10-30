import 'dart:async';
import '../../features/profile/model/profile_model.dart';

/// ✅ Mock API Service to simulate backend data for testing or offline mode.
class MockProfileAPIService {
  /// Fetches mock profile data for a given username.
  Future<ProfileHeaderModel> fetchProfile(String username) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final lowerUsername = username.toLowerCase();

    switch (lowerUsername) {
      case 'hossam_dev':
        return ProfileHeaderModel(
          bannerImage: 'https://picsum.photos/800/200?random=11',
          avatarImage: 'https://picsum.photos/200?random=12',
          displayName: 'Hossam Mohamed',
          handle: 'hossam_dev',
          bio:
              'Software Engineer | Flutter Developer 💙 | Love clean architecture 🧠',
          location: 'Cairo, Egypt',
          joinedDate: 'May 2021',
          followersCount: 1200,
          followingCount: 580,
          isVerified: true,
        );

      case 'flutter_enthusiast':
        return ProfileHeaderModel(
          bannerImage: 'https://picsum.photos/800/200?random=21',
          avatarImage: 'https://picsum.photos/200?random=22',
          displayName: 'Flutter Enthusiast',
          handle: 'flutter_enthusiast',
          bio: 'Building apps with Flutter and Firebase 🔥',
          location: 'Alexandria, Egypt',
          joinedDate: 'June 2022',
          followersCount: 640,
          followingCount: 300,
          isVerified: false,
        );

      default:
        return ProfileHeaderModel(
          bannerImage: 'https://picsum.photos/800/200?random=31',
          avatarImage: 'https://picsum.photos/200?random=32',
          displayName: 'Unknown User',
          handle: username,
          bio: 'Just exploring the app 👀',
          location: 'Unknown',
          joinedDate: 'January 2025',
          followersCount: 12,
          followingCount: 5,
          isVerified: false,
        );
    }
  }
}
