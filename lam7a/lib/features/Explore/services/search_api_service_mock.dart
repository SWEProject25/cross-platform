// import 'dart:async';
// import 'package:lam7a/core/models/user_model.dart';
// import 'package:lam7a/features/common/models/tweet_model.dart';
// import 'package:lam7a/features/profile/model/profile_model.dart';
// import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';
// import 'search_api_service.dart';

// class SearchApiServiceMock implements SearchApiService {
//   // -------------------------------------------------
//   // Mock Autocomplete Suggestions (12 items)
//   // -------------------------------------------------
//   final List<String> _autocomplete = [
//     "flutter",
//     "dart",
//     "riverpod",
//     "openai",
//     "ai",
//     "flutterdev",
//     "coding",
//     "programming",
//     "android",
//     "ios",
//     "mobile apps",
//     "software engineer",
//   ];

//   // -------------------------------------------------
//   // Mock Users
//   // -------------------------------------------------
//   final List<UserModel> _mockUsers = [
//     UserModel(
//       id: 1,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 2,
//       name: 'Sarah Johnson',
//       username: 'sarah_j',
//       bio: 'Designer | UI/UX ✨',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=6',
//       bannerImageUrl: 'https://picsum.photos/400/156',
//       location: 'LA, USA',
//       birthDate: '1994-11-20',
//       createdAt: 'Joined 2020',
//       followersCount: 1400,
//       followingCount: 500,
//       stateFollow: ProfileStateOfFollow.following,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 3,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 4,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 5,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 6,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 7,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 8,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 9,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     UserModel(
//       id: 10,
//       name: 'Ahmed Samir',
//       username: 'ahmed_samir',
//       bio: 'Mobile dev | Flutter ❤️',
//       profileImageUrl: 'https://i.pravatar.cc/150?img=5',
//       bannerImageUrl: 'https://picsum.photos/400/155',
//       location: 'Cairo, Egypt',
//       birthDate: '1999-09-12',
//       createdAt: 'Joined 2022',
//       followersCount: 210,
//       followingCount: 350,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//   ];

//   // -------------------------------------------------
//   // Mock Tweets
//   // -------------------------------------------------

//   // -------------------------------------------------
//   // Autocomplete Search
//   // -------------------------------------------------
//   @override
//   Future<List<String>> autocompleteSearch(String query) async {
//     await Future.delayed(const Duration(milliseconds: 200));

//     if (query.isEmpty) return [];

//     return _autocomplete
//         .where((s) => s.toLowerCase().contains(query.toLowerCase()))
//         .take(3)
//         .toList();
//   }

//   // -------------------------------------------------
//   // Search Users
//   // -------------------------------------------------
//   @override
//   Future<List<UserModel>> searchUsers(String query, int limit, int page) async {
//     await Future.delayed(const Duration(milliseconds: 300));

//     final filtered = _mockUsers
//         .where(
//           (u) =>
//               u.name!.toLowerCase().contains(query.toLowerCase()) ||
//               u.username!.toLowerCase().contains(query.toLowerCase()),
//         )
//         .toList();

//     final start = (page - 1) * limit;
//     return filtered.skip(start).take(limit).toList();
//   }

//   // -------------------------------------------------
//   // Search Tweets (Top / Latest)
//   // -------------------------------------------------
//   @override
//   Future<List<TweetModel>> searchTweets(
//     String query,
//     int limit,
//     int page,
//     String tweetsType,
//   ) async {
//     await Future.delayed(const Duration(milliseconds: 200));

//     List<TweetModel> filtered = mockTweets.values.toList();

//     // simulate top/latest ordering
//     if (tweetsType == 'top') {
//       filtered.sort((a, b) => b.likes.compareTo(a.likes));
//     } else {
//       filtered = filtered.reversed.toList(); // latest
//     }

//     final start = (page - 1) * limit;
//     return filtered.skip(start).take(limit).toList();
//   }

//   // -------------------------------------------------
//   // Search Hashtag Tweets
//   // -------------------------------------------------
//   @override
//   Future<List<TweetModel>> searchHashtagTweets(
//     String hashtag,
//     int limit,
//     int page,
//     String tweetsType,
//   ) async {
//     await Future.delayed(const Duration(milliseconds: 250));

//     final filtered = mockTweets.values.toList();

//     if (tweetsType == 'top') {
//       filtered.sort((a, b) => b.likes.compareTo(a.likes));
//     } else {
//       filtered.sort((a, b) => b.date.compareTo(a.date));
//     }

//     final start = (page - 1) * limit;
//     return filtered.skip(start).take(limit).toList();
//   }
// }
