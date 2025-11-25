// // lib/features/profile/services/mock_profile_api_service.dart
// import '../model/profile_model.dart';

// class MockProfileAPIService {
//   final Map<String, ProfileModel> _mockData = {
//     'hossam_dev': ProfileModel(
//       displayName: 'Hossam Dev',
//       handle: 'hossam_dev',
//       bio: 'Flutter Developer | Building amazing apps 🚀',
//       avatarImage: 'https://i.pravatar.cc/150?img=1',
//       bannerImage: 'https://picsum.photos/400/150',
//       isVerified: true,
//       location: 'Cairo, Egypt',
//       birthday: '1995-05-15',
//       joinedDate: 'Joined January 2020',
//       followersCount: 1250,
//       followingCount: 340,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     'john_doe': ProfileModel(
//       displayName: 'John Doe',
//       handle: 'john_doe',
//       bio: 'Tech enthusiast | Coffee lover ☕',
//       avatarImage: 'https://i.pravatar.cc/150?img=2',
//       bannerImage: 'https://picsum.photos/400/151',
//       isVerified: false,
//       location: 'New York, USA',
//       birthday: '1990-03-20',
//       joinedDate: 'Joined March 2021',
//       followersCount: 450,
//       followingCount: 120,
//       stateFollow: ProfileStateOfFollow.following,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     'jane_smith': ProfileModel(
//       displayName: 'Jane Smith',
//       handle: 'jane_smith',
//       bio: 'UI/UX Designer | Creating beautiful experiences ✨',
//       avatarImage: 'https://i.pravatar.cc/150?img=3',
//       bannerImage: 'https://picsum.photos/400/152',
//       isVerified: true,
//       location: 'London, UK',
//       birthday: '1992-07-10',
//       joinedDate: 'Joined June 2019',
//       followersCount: 2100,
//       followingCount: 890,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//   };

//   Future<ProfileModel> fetchProfile(String username) async {
//     await Future.delayed(const Duration(milliseconds: 500));
    
//     if (_mockData.containsKey(username)) {
//       return _mockData[username]!;
//     }
//     throw Exception('Profile not found: $username');
//   }

//   Future<ProfileModel> updateProfile(ProfileModel profile) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _mockData[profile.handle] = profile;
//     return profile;
//   }

//   Future<List<ProfileModel>> fetchProfiles() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return _mockData.values.toList();
//   }
// }