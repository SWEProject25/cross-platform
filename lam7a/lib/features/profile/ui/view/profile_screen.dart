// // lib/features/profile/ui/view/profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:lam7a/core/models/user_model.dart';
// import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
// import 'package:lam7a/core/providers/authentication.dart';

// import '../widgets/profile_header_widget.dart';
// import '../widgets/profile_more_menu.dart'; // <--- NEW
// import '../widgets/blocked_profile_view.dart';// <--- NEW FILE YOU CREATED

// class ProfileScreen extends ConsumerWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

//     final username = args?['username'] as String?;
//     if (username == null || username.isEmpty) {
//       return const Scaffold(body: Center(child: Text('No username provided')));
//     }

//     final asyncUser = ref.watch(profileViewModelProvider(username));

//     return asyncUser.when(
//       loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
//       data: (user) => _ProfileLoaded(user: user, username: username),
//     );
//   }
// }

// class _ProfileLoaded extends ConsumerWidget {
//   final UserModel user;
//   final String username;

//   const _ProfileLoaded({required this.user, required this.username});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final myUser = ref.watch(authenticationProvider).user;
//     final isOwnProfile = myUser?.id == user.id;

//     // Refresh function after muting/blocking
//     void refresh() => ref.invalidate(profileViewModelProvider(username));

//     // --- BLOCKED SCREEN HANDLING ---
//     if (user.stateBlocked == ProfileStateBlocked.blocked) {
//       return BlockedProfileView(
//         username: username,
//         userId: user.id,
//         onUnblock: () {
//           ref.invalidate(profileViewModelProvider(username));
//         }
//       ); // <--- YOUR BLOCK VIEW
//     }

//     const double avatarRadius = 46.0;

//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (_, __) => [
//           SliverAppBar(
//             pinned: true,
//             expandedHeight: 240,
//             backgroundColor: Colors.white,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () => Navigator.pop(context),
//             ),

//             // -----------------------
//             //     THREE DOTS MENU
//             // -----------------------
//             actions: [
//               if (!isOwnProfile)
//                 ProfileMoreMenu(
//                   user: user,
//                   username: username,
//                   onAction: refresh,
//                 ),
//             ],

//             flexibleSpace: LayoutBuilder(builder: (context, constraints) {
//               return Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   // Banner
//                   Positioned.fill(
//                     child: (user.bannerImageUrl != null &&
//                             user.bannerImageUrl!.isNotEmpty)
//                         ? Image.network(user.bannerImageUrl!, fit: BoxFit.cover)
//                         : Container(color: Colors.grey.shade300),
//                   ),

//                   // Avatar
//                   Positioned(
//                     bottom: -avatarRadius,
//                     left: 16,
//                     child: CircleAvatar(
//                       radius: avatarRadius,
//                       backgroundColor: Colors.white,
//                       child: CircleAvatar(
//                         radius: avatarRadius - 3,
//                         backgroundImage: (user.profileImageUrl != null &&
//                                 user.profileImageUrl!.isNotEmpty)
//                             ? NetworkImage(user.profileImageUrl!)
//                             : const AssetImage('assets/images/user_profile.png')
//                                 as ImageProvider,
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),

//           // Space for avatar push-down
//           SliverToBoxAdapter(child: SizedBox(height: avatarRadius + 12)),

//           SliverToBoxAdapter(
//             child: ProfileHeaderWidget(
//               user: user,
//               isOwnProfile: isOwnProfile,
//               onEdited: refresh,
//             ),
//           ),
//         ],

//         body: DefaultTabController(
//           length: 6,
//           child: Column(
//             children: [
//               const TabBar(
//                 isScrollable: true,
//                 tabs: [
//                   Tab(text: 'Posts'),
//                   Tab(text: 'Replies'),
//                   Tab(text: 'Highlights'),
//                   Tab(text: 'Articles'),
//                   Tab(text: 'Media'),
//                   Tab(text: 'Likes'),
//                 ],
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: List.generate(
//                     6,
//                     (i) => ListView.builder(
//                       itemCount: 10,
//                       itemBuilder: (_, idx) => ListTile(
//                         title: Text('Item $idx'),
//                         subtitle: const Text('Content coming later'),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';

import '../widgets/profile_header_widget.dart';
import '../widgets/profile_more_menu.dart';
import '../widgets/blocked_profile_view.dart';

import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final username = args?['username'] as String?;

    if (username == null || username.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No username provided")),
      );
    }

    final asyncUser = ref.watch(profileViewModelProvider(username));

    return asyncUser.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text("Error: $err"))),
      data: (user) => _ProfileLoaded(user: user, username: username),
    );
  }
}

class _ProfileLoaded extends ConsumerWidget {
  final UserModel user;
  final String username;

  const _ProfileLoaded({required this.user, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(authenticationProvider).user;
    final isOwnProfile = myUser?.id == user.profileId;

    void refresh() => ref.invalidate(profileViewModelProvider(username));

    // Blocked screen
    if (user.stateBlocked == ProfileStateBlocked.blocked) {
      return BlockedProfileView(
        username: username,
        userId: user.profileId!, // <-- FIX
        onUnblock: refresh,
      );
    }

    const double avatarRadius = 46;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            actions: [
              if (!isOwnProfile)
                ProfileMoreMenu(user: user, username: username, onAction: refresh)
            ],

            flexibleSpace: LayoutBuilder(
              builder: (_, __) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: (user.bannerImageUrl != null && user.bannerImageUrl!.isNotEmpty)
                          ? Image.network(user.bannerImageUrl!, fit: BoxFit.cover)
                          : Container(color: Colors.grey.shade300),
                    ),
                    Positioned(
                      bottom: -avatarRadius,
                      left: 16,
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: avatarRadius - 3,
                          backgroundImage: (user.profileImageUrl != null &&
                                  user.profileImageUrl!.isNotEmpty)
                              ? NetworkImage(user.profileImageUrl!)
                              : const AssetImage("assets/images/user_profile.png")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: avatarRadius + 12)),
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              user: user,
              isOwnProfile: isOwnProfile,
              onEdited: refresh,
            ),
          ),
        ],

        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "Posts"),
                  Tab(text: "Replies"),
                  Tab(text: "Likes"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _ProfilePostsTab(userId: user.profileId!.toString()), // <-- FIXED
                    _ProfileRepliesTab(userId: user.profileId!.toString()), // <-- FIXED
                    _ProfileLikesTab(userId: user.profileId!.toString()), // <-- FIXED
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------- POSTS TAB -----------------------
class _ProfilePostsTab extends ConsumerWidget {
  final String userId;
  const _ProfilePostsTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPosts = ref.watch(profilePostsProvider(userId));

    return asyncPosts.when(
      data: (tweets) {
        if (tweets.isEmpty) return const Center(child: Text("No posts yet"));
        return ListView.builder(
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading posts")),
    );
  }
}

// ----------------------- REPLIES TAB -----------------------
class _ProfileRepliesTab extends ConsumerWidget {
  final String userId;
  const _ProfileRepliesTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncReplies = ref.watch(profileRepliesProvider(userId));

    return asyncReplies.when(
      data: (tweets) {
        if (tweets.isEmpty) return const Center(child: Text("No replies yet"));
        return ListView.builder(
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading replies")),
    );
  }
}

// ----------------------- LIKES TAB -----------------------
class _ProfileLikesTab extends ConsumerWidget {
  final String userId;
  const _ProfileLikesTab({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncLikes = ref.watch(profileLikesProvider(userId));

    return asyncLikes.when(
      data: (tweets) {
        if (tweets.isEmpty) return const Center(child: Text("No liked posts"));
        return ListView.builder(
          itemCount: tweets.length,
          itemBuilder: (_, i) => TweetSummaryWidget(
            tweetId: tweets[i].id,
            tweetData: tweets[i],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading liked posts")),
    );
  }
}

