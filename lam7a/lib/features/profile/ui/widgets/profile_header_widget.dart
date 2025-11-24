// lib/features/profile/ui/widgets/profile_header_widget.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/ui/view/edit_profile_page.dart';
import 'package:lam7a/features/profile/ui/view/followers_following_page.dart';
import 'package:lam7a/features/profile/ui/widgets/follow_button.dart';

class ProfileHeaderWidget extends ConsumerWidget {
  final ProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback? onEdited;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.isOwnProfile,
    this.onEdited,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- EDIT BUTTON ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isOwnProfile
                ? OutlinedButton(
                    onPressed: () async {
                      final updated = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage(profile: profile)),
                      );
                      if (updated != null) onEdited?.call();
                    },
                    child: const Text("Edit profile"),
                  )
                : FollowButton(initialProfile: profile),
            const SizedBox(width: 16),
          ],
        ),

        const SizedBox(height: 12),

        // ---------- NAME ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.displayName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("@${profile.handle}", style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ---------- BIO ----------
        if (profile.bio.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(profile.bio),
          ),

        const SizedBox(height: 12),

        // ---------- LOCATION / BIRTHDAY / JOIN DATE ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              if (profile.location.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(profile.location),
                  ],
                ),

              if (profile.birthday.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cake_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text(profile.birthday),
                  ],
                ),

              if (profile.joinedDate.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text("Joined ${profile.joinedDate.split("T").first}"),
                  ],
                ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ---------- FOLLOWING / FOLLOWERS ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FollowersFollowingPage(userId: profile.userId, initialTab: 1),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${profile.followingCount} ",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text: "Following", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FollowersFollowingPage(userId: profile.userId, initialTab: 0),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${profile.followersCount} ",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(
                          text: "Followers", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}
