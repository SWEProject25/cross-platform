// lib/features/profile/ui/view/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import '../widgets/profile_header_widget.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = args["username"];

    final asyncProfile = ref.watch(profileViewModelProvider(username));

    return asyncProfile.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text("Error: $err"))),
      data: (profile) => _ProfileLoaded(profile: profile, username: username),
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

    void refresh() => ref.invalidate(profileViewModelProvider(username));

    const double avatarRadius = 42;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // ---------------- BANNER + AVATAR FIXED ----------------
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Banner image
                    FlexibleSpaceBar(
                      background: profile.bannerImage.isNotEmpty
                          ? Image.network(profile.bannerImage, fit: BoxFit.cover)
                          : Container(color: Colors.grey.shade300),
                    ),

                    // Avatar overlay
                    Positioned(
                      bottom: -avatarRadius,
                      left: 16,
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: avatarRadius - 3,
                          backgroundImage: profile.avatarImage.isNotEmpty
                              ? NetworkImage(profile.avatarImage)
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

          // Spacer below avatar so content doesn't overlap it
          SliverToBoxAdapter(
            child: SizedBox(height: avatarRadius + 16),
          ),

          // Profile header content (everything else below avatar)
          SliverToBoxAdapter(
            child: ProfileHeaderWidget(
              profile: profile,
              isOwnProfile: isOwnProfile,
              onEdited: refresh,
            ),
          ),
        ],

        // ---------------- TABS ----------------
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
