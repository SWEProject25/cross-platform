// lib/features/profile/ui/widgets/profile_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/view/edit_profile_page.dart';
import 'package:lam7a/features/profile/ui/view/followers_following_page.dart';
import 'package:lam7a/features/profile/ui/widgets/follow_button.dart';

class ProfileHeaderWidget extends ConsumerWidget {
  final UserModel user;
  final bool isOwnProfile;
  final VoidCallback? onEdited;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
    required this.isOwnProfile,
    this.onEdited,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Top-right action: Edit or Follow
      Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          isOwnProfile
              ? OutlinedButton(
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage(user: user)),
                    );
                    if (updated != null) onEdited?.call();
                  },
                  child: const Text('Edit profile'),
                )
              : FollowButton(user: user),
        ]),
      ),

      const SizedBox(height: 12),

      // Name and handle
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user.name ?? '', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text('@${user.username ?? ''}', style: const TextStyle(color: Colors.grey)),
        ]),
      ),

      const SizedBox(height: 10),

      // Bio
      if ((user.bio ?? '').isNotEmpty)
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(user.bio!)),

      const SizedBox(height: 10),

      // Extra info
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 12, runSpacing: 6, children: [
          if ((user.location ?? '').isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on_outlined, size: 16), const SizedBox(width: 4), Text(user.location ?? '')]),

          if ((user.birthDate ?? '').isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.cake_outlined, size: 16), const SizedBox(width: 4), Text(user.birthDate ?? '')]),

          if ((user.createdAt ?? '').isNotEmpty)
            Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.calendar_today_outlined, size: 16), const SizedBox(width: 4), Text('Joined ${user.createdAt!.split("T").first}')]),
        ]),
      ),

      const SizedBox(height: 12),

      // Following / Followers - navigates to FollowersFollowingPage
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersFollowingPage(userId: user.id ?? 0, initialTab: 1)));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: '${user.followingCount} ', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const TextSpan(text: 'Following', style: TextStyle(color: Colors.grey)),
              ]),
            ),
          ),

          const SizedBox(width: 16),

          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersFollowingPage(userId: user.id ?? 0, initialTab: 0)));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: '${user.followersCount} ', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                const TextSpan(text: 'Followers', style: TextStyle(color: Colors.grey)),
              ]),
            ),
          ),
        ]),
      ),

      const SizedBox(height: 20),
    ]);
  }
}
