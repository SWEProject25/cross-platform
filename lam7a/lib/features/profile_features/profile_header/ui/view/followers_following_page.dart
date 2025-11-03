// import 'package:flutter/material.dart';
// //import 'package:lam7a/core/widgets/app_outlined_button.dart';
// import 'package:lam7a/features/profile_features/profile_summary/model/profile_model.dart';
// import 'package:lam7a/features/profile_features/profile_summary/ui/widgets/profile_card.dart';


// class FollowersFollowingPage extends StatefulWidget {
//   final String username;

//   const FollowersFollowingPage({super.key, required this.username});

//   @override
//   State<FollowersFollowingPage> createState() => _FollowersFollowingPageState();
// }

// class _FollowersFollowingPageState extends State<FollowersFollowingPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   final List<Map<String, dynamic>> followingList = [
//     {
//       "name": "MrBeast",
//       "handle": "@MrBeast",
//       "bio": "New MrBeast or MrBeast Gaming video each Saturday!",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1673404014393802753/bbB-l3zr_400x400.jpg",
//       "isFollowing": true
//     },
//     {
//       "name": "Brian Basson",
//       "handle": "@BassonBrain",
//       "bio": "Free speech | Tesla | 🚀 SpaceX | 🛰️ Starlink",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1303453200782110721/q3u5I8g__400x400.jpg",
//       "isFollowing": true
//     },
//     {
//       "name": "Elon Musk",
//       "handle": "@elonmusk",
//       "bio": "Technoking of Tesla, Imperator of Mars",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1841291940613781505/pz8vEJW6_400x400.jpg",
//       "isFollowing": true
//     },
//     {
//       "name": "Starlink",
//       "handle": "@Starlink",
//       "bio":
//           "Internet from space for humans on Earth. Engineered by @SpaceX",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1353115652822927360/0zB7n_1x_400x400.jpg",
//       "isFollowing": true
//     },
//   ];

//   final List<Map<String, dynamic>> followersList = [
//     {
//       "name": "Hossam Dev",
//       "handle": "@hossam_dev",
//       "bio": "Building Flutter apps 🚀 | Coffee lover ☕",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1720802949343287296/knW2OxCH_400x400.jpg",
//       "isFollowing": true
//     },
//     {
//       "name": "AI Bot",
//       "handle": "@aibot",
//       "bio": "Helping developers with Flutter and Dart 💡",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1623637892358739968/NKpU2j5K_400x400.jpg",
//       "isFollowing": false
//     },
//     {
//       "name": "Tech Daily",
//       "handle": "@techdaily",
//       "bio": "Daily news on AI, startups, and code 👨‍💻",
//       "avatar":
//           "https://pbs.twimg.com/profile_images/1753452217389105152/99xkEw9H_400x400.jpg",
//       "isFollowing": false
//     },
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Convert the map into your ProfileModel used by ProfileCard
//   ProfileModel _mapToProfileModel(Map<String, dynamic> m) {
//     return ProfileModel(
//       name: m['name'] as String,
//       username: m['handle'] as String,
//       bio: m['bio'] as String,
//       imageUrl: m['avatar'] as String,
//       isVerified: (m['isFollowing'] == true), // optional: use as verified flag
//       stateFollow: (m['isFollowing'] == true)
//           ? ProfileStateOfFollow.following
//           : ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     );
//   }

//   Widget _buildListItem(Map<String, dynamic> user) {
//     final profileModel = _mapToProfileModel(user);
//     // ProfileCard already contains the follow button and behaviour
//     return ProfileCard(profile: profileModel);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF9F9F9),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0.5,
//         title: Text(
//           widget.username,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tabController,
//               indicatorColor: Colors.blue,
//               labelColor: Colors.blue,
//               unselectedLabelColor: Colors.grey,
//               tabs: const [
//                 Tab(text: 'Followers'),
//                 Tab(text: 'Following'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           ListView.separated(
//             itemCount: followersList.length,
//             physics: const AlwaysScrollableScrollPhysics(),
//             separatorBuilder: (_, __) => const Divider(height: 0.5),
//             itemBuilder: (_, index) => _buildListItem(followersList[index]),
//           ),
//           ListView.separated(
//             itemCount: followingList.length,
//             physics: const AlwaysScrollableScrollPhysics(),
//             separatorBuilder: (_, __) => const Divider(height: 0.5),
//             itemBuilder: (_, index) => _buildListItem(followingList[index]),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile_features/profile_summary/ui/widgets/profile_card.dart';
import 'package:lam7a/features/profile_features/profile_summary/model/profile_model.dart';
import 'package:lam7a/features/profile_features/profile_summary/ui/viewmodel/profile_viewmodel.dart';

class FollowersFollowingPage extends ConsumerStatefulWidget {
  final String username;

  const FollowersFollowingPage({super.key, required this.username});

  @override
  ConsumerState<FollowersFollowingPage> createState() =>
      _FollowersFollowingPageState();
}

class _FollowersFollowingPageState
    extends ConsumerState<FollowersFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Text(
          widget.username,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Followers'),
                Tab(text: 'Following'),
              ],
            ),
          ),
        ),
      ),
      body: profileState.when(
        data: (profiles) {
          // Split into two lists
          final followers = profiles
              .where((p) => p.stateFollow == ProfileStateOfFollow.notfollowing)
              .toList();
          final following = profiles
              .where((p) => p.stateFollow == ProfileStateOfFollow.following)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              ListView.separated(
                itemCount: followers.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 0.5),
                itemBuilder: (_, index) => ProfileCard(profile: followers[index]),
              ),
              ListView.separated(
                itemCount: following.length,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 0.5),
                itemBuilder: (_, index) => ProfileCard(profile: following[index]),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
