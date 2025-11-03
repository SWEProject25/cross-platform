// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../viewmodel/profile_header_viewmodel.dart';
// import '../../../../../core/widgets/app_outlined_button.dart';
// import '../../../profile_edit/ui/view/edit_profile_page.dart';
// import '../../../profile/model/profile_model.dart';
// import 'profile_tab_bar.dart';
// import '../view/followers_following_page.dart'; // ✅ Import your followers/following page

// class ProfileHeaderWidget extends ConsumerStatefulWidget {
//   final String userId;

//   const ProfileHeaderWidget({
//     super.key,
//     required this.userId,
//   });

//   @override
//   ConsumerState<ProfileHeaderWidget> createState() =>
//       _ProfileHeaderWidgetState();
// }

// class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
//   ProfileHeaderModel? _currentProfile;
//   int _selectedTabIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() async {
//       final notifier = ref.read(profileHeaderViewModelProvider.notifier);
//       await notifier.loadProfileHeader(widget.userId);
//       final state = ref.read(profileHeaderViewModelProvider);
//       state.whenData((data) => _currentProfile = data);
//     });
//   }

//   ImageProvider _getImage(String path, {bool isBanner = false}) {
//     if (path.isEmpty) {
//       return NetworkImage(isBanner
//           ? 'https://via.placeholder.com/400x150'
//           : 'https://via.placeholder.com/150');
//     }
//     if (path.startsWith('http')) return NetworkImage(path);
//     return FileImage(File(path));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profileState = ref.watch(profileHeaderViewModelProvider);

//     return profileState.when(
//       data: (profile) {
//         final displayProfile = _currentProfile ?? profile;

//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ===== Banner + Avatar =====
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Image(
//                     image: _getImage(displayProfile.bannerImage, isBanner: true),
//                     width: MediaQuery.of(context).size.width,
//                     height: 150,
//                     fit: BoxFit.cover,
//                   ),
//                   Positioned(
//                     left: 16,
//                     bottom: -40,
//                     child: CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.white,
//                       child: CircleAvatar(
//                         radius: 37,
//                         backgroundImage: _getImage(displayProfile.avatarImage),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 10),

//               // ===== Edit Button =====
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: AppOutlinedButton(
//                     text: 'Edit Profile',
//                     onPressed: () async {
//                       final updatedProfile = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) =>
//                               EditProfilePage(profile: displayProfile),
//                         ),
//                       );

//                       if (updatedProfile != null &&
//                           updatedProfile is ProfileHeaderModel) {
//                         setState(() {
//                           _currentProfile = updatedProfile;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // ===== Profile Info =====
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     Text(
//                       displayProfile.displayName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     if (displayProfile.isVerified) ...[
//                       const SizedBox(width: 6),
//                       const Icon(Icons.verified, color: Colors.blue, size: 20),
//                     ],
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(
//                   '@${displayProfile.handle}',
//                   style: const TextStyle(color: Colors.grey, fontSize: 15),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Text(displayProfile.bio,
//                     style: const TextStyle(fontSize: 15)),
//               ),
//               const SizedBox(height: 10),

//               // ===== Location + Joined =====
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     if (displayProfile.location.isNotEmpty) ...[
//                       const Icon(Icons.location_on_outlined,
//                           size: 16, color: Colors.grey),
//                       const SizedBox(width: 4),
//                       Text(displayProfile.location,
//                           style: const TextStyle(
//                               color: Colors.grey, fontSize: 14)),
//                       const SizedBox(width: 12),
//                     ],
//                     const Icon(Icons.calendar_today_outlined,
//                         size: 14, color: Colors.grey),
//                     const SizedBox(width: 4),
//                     Text(displayProfile.joinedDate,
//                         style: const TextStyle(
//                             color: Colors.grey, fontSize: 14)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),

//               // ===== Followers / Following Counts (Clickable) =====
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => FollowersFollowingPage(
//                               username: displayProfile.displayName,
//                             ),
//                           ),
//                         );
//                       },
//                       child: _buildFollowCount(
//                           displayProfile.followingCount.toString(), 'Following'),
//                     ),
//                     const SizedBox(width: 16),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => FollowersFollowingPage(
//                               username: displayProfile.displayName,
//                             ),
//                           ),
//                         );
//                       },
//                       child: _buildFollowCount(
//                           displayProfile.followersCount.toString(), 'Followers'),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // ===== Profile Tab Bar =====
//               ProfileTabBar(
//                 selectedIndex: _selectedTabIndex,
//                 onTabSelected: (index) {
//                   setState(() => _selectedTabIndex = index);
//                 },
//               ),

//               // ===== Tab Content =====
//               _buildTabContent(),
//             ],
//           ),
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (error, _) => Center(
//         child: Text('❌ Error loading profile: $error'),
//       ),
//     );
//   }

//   Widget _buildFollowCount(String count, String label) {
//     return Row(
//       children: [
//         Text(count,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
//         const SizedBox(width: 4),
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
//       ],
//     );
//   }

//   Widget _buildTabContent() {
//     final sections = [
//       'User’s Posts feed',
//       'User’s Replies feed',
//       'User’s Highlights feed',
//       'User’s Articles feed',
//       'User’s Media feed',
//       'User’s Likes feed',
//     ];

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Center(
//         child: Text(
//           sections[_selectedTabIndex],
//           style: const TextStyle(fontSize: 16, color: Colors.black54),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/profile_header_viewmodel.dart';
import '../../../../../core/widgets/app_outlined_button.dart';
import '../../../profile_edit/ui/view/edit_profile_page.dart';
import '../../../profile/model/profile_model.dart';
import 'profile_tab_bar.dart';
import '../view/followers_following_page.dart';

class ProfileHeaderWidget extends ConsumerStatefulWidget {
  final String userId;

  const ProfileHeaderWidget({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ProfileHeaderWidget> createState() =>
      _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
  ProfileHeaderModel? _currentProfile;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final notifier = ref.read(profileHeaderViewModelProvider.notifier);
      await notifier.loadProfileHeader(widget.userId);
      final state = ref.read(profileHeaderViewModelProvider);
      state.whenData((data) => _currentProfile = data);
    });
  }

  ImageProvider _getImage(String path, {bool isBanner = false}) {
    if (path.isEmpty) {
      return NetworkImage(isBanner
          ? 'https://via.placeholder.com/400x150'
          : 'https://via.placeholder.com/150');
    }
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileHeaderViewModelProvider);

    return Container(
      color: Colors.white, // ✅ Make the full background white
      child: profileState.when(
        data: (profile) {
          final displayProfile = _currentProfile ?? profile;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Banner + Avatar =====
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image(
                      image: _getImage(displayProfile.bannerImage, isBanner: true),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 16,
                      bottom: -40,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 37,
                          backgroundImage: _getImage(displayProfile.avatarImage),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===== Edit Button =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppOutlinedButton(
                      text: 'Edit Profile',
                      onPressed: () async {
                        final updatedProfile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditProfilePage(profile: displayProfile),
                          ),
                        );

                        if (updatedProfile != null &&
                            updatedProfile is ProfileHeaderModel) {
                          setState(() {
                            _currentProfile = updatedProfile;
                          });
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ===== Profile Info =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        displayProfile.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (displayProfile.isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.verified, color: Colors.blue, size: 20),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '@${displayProfile.handle}',
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(displayProfile.bio,
                      style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(height: 10),

                // ===== Location + Joined =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      if (displayProfile.location.isNotEmpty) ...[
                        const Icon(Icons.location_on_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(displayProfile.location,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14)),
                        const SizedBox(width: 12),
                      ],
                      const Icon(Icons.calendar_today_outlined,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(displayProfile.joinedDate,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ===== Followers / Following Counts (Clickable) =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersFollowingPage(
                                username: displayProfile.displayName,
                              ),
                            ),
                          );
                        },
                        child: _buildFollowCount(
                            displayProfile.followingCount.toString(), 'Following'),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersFollowingPage(
                                username: displayProfile.displayName,
                              ),
                            ),
                          );
                        },
                        child: _buildFollowCount(
                            displayProfile.followersCount.toString(), 'Followers'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ===== Profile Tab Bar =====
                ProfileTabBar(
                  selectedIndex: _selectedTabIndex,
                  onTabSelected: (index) {
                    setState(() => _selectedTabIndex = index);
                  },
                ),

                // ===== Tab Content =====
                _buildTabContent(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('❌ Error loading profile: $error'),
        ),
      ),
    );
  }

  Widget _buildFollowCount(String count, String label) {
    return Row(
      children: [
        Text(count,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ],
    );
  }

  Widget _buildTabContent() {
    final sections = [
      'User’s Posts feed',
      'User’s Replies feed',
      'User’s Highlights feed',
      'User’s Articles feed',
      'User’s Media feed',
      'User’s Likes feed',
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          sections[_selectedTabIndex],
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
