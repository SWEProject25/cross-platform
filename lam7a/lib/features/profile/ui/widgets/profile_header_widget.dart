// lib/ui/widgets/profile_header_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../model/profile_model.dart';
import '../view/edit_profile_page.dart';
import '../view/followers_following_page.dart';
import 'profile_tab_bar.dart';

class ProfileHeaderWidget extends ConsumerStatefulWidget {
  final String userId;
  final bool isOwnProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.userId,
    this.isOwnProfile = true,
  });

  @override
  ConsumerState<ProfileHeaderWidget> createState() =>
      _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
  int _selectedTabIndex = 0;

  ImageProvider _getImage(String path, {bool isBanner = false}) {
    if (path.isEmpty) {
      return NetworkImage(
        isBanner
            ? 'https://via.placeholder.com/400x150'
            : 'https://via.placeholder.com/150',
      );
    }
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileViewModelProvider(widget.userId));
    final profileStateMap = ref.watch(profileStateMapProvider);
    final profileState = profileStateMap[widget.userId];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isOwnProfile
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (value) {
                    if (value == 'mute') {
                      debugPrint('User muted');
                    } else if (value == 'block') {
                      debugPrint('User blocked');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'mute', child: Text('Mute')),
                    const PopupMenuItem(value: 'block', child: Text('Block')),
                  ],
                ),
              ],
            ),
      body: profileState != null
          ? profileState.when(
              data: (profile) => _buildProfileContent(profile),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            )
          : profileAsync.when(
              data: (profile) => _buildProfileContent(profile),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
    );
  }

  Widget _buildProfileContent(ProfileModel profile) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image(
                    image: _getImage(profile.bannerImage, isBanner: true),
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
                        backgroundImage: _getImage(profile.avatarImage),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              _buildActionButton(profile),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      profile.displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (profile.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.verified, color: Colors.blue, size: 18),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '@${profile.handle}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(profile.bio),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (profile.location.isNotEmpty) ...[
                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(profile.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(width: 12),
                    ],
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(profile.joinedDate, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FollowersFollowingPage(username: profile.displayName),
                          ),
                        );
                      },
                      child: Text(
                        '${profile.followingCount} Following',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FollowersFollowingPage(username: profile.displayName),
                          ),
                        );
                      },
                      child: Text(
                        '${profile.followersCount} Followers',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              widget.isOwnProfile
                  ? ProfileTabBar(
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                    )
                  : OtherProfileTabBar(
                      selectedIndex: _selectedTabIndex,
                      onTabSelected: (index) => setState(() => _selectedTabIndex = index),
                    ),
              const Divider(height: 1),
            ],
          ),
        ),
      ],
      body: _buildTabContent(),
    );
  }

  Widget _buildActionButton(ProfileModel profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: widget.isOwnProfile
            ? _buildEditButton(profile)
            : _buildFollowButton(profile),
      ),
    );
  }

  Widget _buildEditButton(ProfileModel profile) {
    return OutlinedButton(
      onPressed: () async {
        final updatedProfile = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditProfilePage(profile: profile)),
        );
        if (updatedProfile != null && updatedProfile is ProfileModel) {
          ref.updateProfile(widget.userId, updatedProfile);
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: Colors.grey.shade400),
        backgroundColor: Colors.white,
      ),
      child: const Text(
        'Edit Profile',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }

  Widget _buildFollowButton(ProfileModel profile) {
    final isFollowing = profile.stateFollow == ProfileStateOfFollow.following;
    return FilledButton(
      onPressed: () => ref.toggleFollow(widget.userId, profile),
      style: FilledButton.styleFrom(
        backgroundColor: isFollowing ? Colors.white : Colors.black,
        side: const BorderSide(color: Colors.black),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        isFollowing ? 'Following' : 'Follow',
        style: TextStyle(
          color: isFollowing ? Colors.black : Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    if (widget.isOwnProfile) {
      final sections = [
        'User\'s Posts feed',
        'User\'s Replies feed',
        'User\'s Highlights feed',
        'User\'s Articles feed',
        'User\'s Media feed',
        'User\'s Likes feed',
      ];
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(sections[_selectedTabIndex], style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ),
      );
    } else {
      final sections = ['Posts from this user', 'User replies', 'Media shared by user'];
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${sections[_selectedTabIndex]} - Item #$index',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      );
    }
  }
}

class OtherProfileTabBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;

  const OtherProfileTabBar({
    super.key,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Posts', 'Replies', 'Media'];
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => onTabSelected(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                        color: isSelected ? Colors.black : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (isSelected)
                      Container(
                        height: 3,
                        width: 25,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}