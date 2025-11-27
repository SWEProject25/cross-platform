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

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [

          // =================== BANNER + AVATAR ===================
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),

            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Banner
                    Positioned.fill(
                      child: profile.bannerImage.isNotEmpty
                          ? Image.network(profile.bannerImage, fit: BoxFit.cover)
                          : Container(color: Colors.grey.shade300),
                    ),

                    // Avatar (overlapping bottom)
                    Positioned(
                      bottom: -40, // pulls avatar outside banner
                      left: 16,
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 42,
                          backgroundImage: NetworkImage(profile.avatarImage),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Space so header doesn't cover avatar
          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],

        // =================== PROFILE BODY ===================
        body: ProfileHeaderWidget(
          profile: profile,
          isOwnProfile: isOwnProfile,
          onEdited: refresh,
        ),
      ),
    );
  }
}
