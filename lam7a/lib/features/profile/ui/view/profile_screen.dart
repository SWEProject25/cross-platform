// // lib/features/profile/ui/view/profile_screen.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
// import 'package:lam7a/features/profile/model/profile_model.dart';
// import 'package:lam7a/core/providers/authentication.dart';
// import '../widgets/profile_header_widget.dart';

// class ProfileScreen extends ConsumerWidget {
//   final String username;

//   const ProfileScreen({super.key, required this.username});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncProfile = ref.watch(profileViewModelProvider(username));

//     return asyncProfile.when(
//       loading: () => const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       ),
//       error: (err, _) => Scaffold(
//         body: Center(child: Text("Error: $err")),
//       ),
//       data: (profile) => _ProfileLoaded(
//         profile: profile,
//         username: username,
//       ),
//     );
//   }
// }

// class _ProfileLoaded extends ConsumerWidget {
//   final ProfileModel profile;
//   final String username;

//   const _ProfileLoaded({
//     required this.profile,
//     required this.username,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final myUser = ref.watch(authenticationProvider).user;
//     final bool isOwnProfile = myUser != null && myUser.id == profile.userId;

//     void refreshProfile() {
//       ref.invalidate(profileViewModelProvider(username));
//     }

//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (_, __) {
//           return [
//             // ------------------- BANNER -------------------
//             SliverAppBar(
//               pinned: true,
//               expandedHeight: 200,
//               backgroundColor: Colors.white,
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 background: profile.bannerImage.isNotEmpty
//                     ? Image.network(profile.bannerImage, fit: BoxFit.cover)
//                     : Container(color: Colors.grey.shade300),
//               ),
//             ),

//             // ------------------- HEADER CONTENT (NO OVERFLOW) -------------------
//             SliverToBoxAdapter(
//               child: ProfileHeaderWidget(
//                 profile: profile,
//                 isOwnProfile: isOwnProfile,
//                 onEdited: refreshProfile,
//               ),
//             ),
//           ];
//         },

//         body: _buildTabView(),
//       ),
//     );
//   }

//   Widget _buildTabView() {
//     return DefaultTabController(
//       length: 6,
//       child: Column(
//         children: [
//           const TabBar(
//             isScrollable: true,
//             labelColor: Colors.black,
//             tabs: [
//               Tab(text: "Posts"),
//               Tab(text: "Replies"),
//               Tab(text: "Highlights"),
//               Tab(text: "Articles"),
//               Tab(text: "Media"),
//               Tab(text: "Likes"),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 _fakeList("Posts"),
//                 _fakeList("Replies"),
//                 _fakeList("Highlights"),
//                 _fakeList("Articles"),
//                 _fakeList("Media"),
//                 _fakeList("Likes"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _fakeList(String title) => ListView.builder(
//         itemCount: 10,
//         itemBuilder: (_, i) => ListTile(
//           title: Text("$title item $i"),
//           subtitle: const Text("This will later show real tweets."),
//         ),
//       );
// }
// lib/features/profile/ui/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import '../widgets/profile_header_widget.dart';

class ProfileScreen extends ConsumerWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileViewModelProvider(username));

    return asyncProfile.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, _) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),

      data: (profile) => _ProfileLoaded(
        profile: profile,
        username: username,
      ),
    );
  }
}

class _ProfileLoaded extends ConsumerWidget {
  final ProfileModel profile;
  final String username;

  const _ProfileLoaded({
    required this.profile,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myUser = ref.watch(authenticationProvider).user;
    final bool isOwnProfile = myUser?.id == profile.userId;

    void refresh() {
      ref.invalidate(profileViewModelProvider(username));
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: profile.bannerImage.isNotEmpty
                  ? Image.network(profile.bannerImage, fit: BoxFit.cover)
                  : Container(color: Colors.grey.shade300),
            ),
          ),

          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              profile: profile,
              isOwnProfile: isOwnProfile,
              onEdited: refresh,
            ),
          ),
        ],

        body: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              const TabBar(
                isScrollable: true,
                tabs: [
                  Tab(text: "Posts"),
                  Tab(text: "Replies"),
                  Tab(text: "Highlights"),
                  Tab(text: "Articles"),
                  Tab(text: "Media"),
                  Tab(text: "Likes"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: List.generate(
                    6,
                    (i) => ListView.builder(
                      itemCount: 10,
                      itemBuilder: (_, idx) => ListTile(
                        title: Text("Item $idx"),
                        subtitle: const Text("Content coming later"),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
