// lib/features/profile/ui/widgets/profile_header_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

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
                  key: const ValueKey('profile_edit_button'),
                  style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6), 
                  minimumSize: const Size(0, 28), 
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap, 

                  // Border color depends on theme
                  side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),

                  // Background color optional
                  backgroundColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                  onPressed: () async {
                    final updated = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage(user: user)),
                    );
                    if (updated != null) onEdited?.call();
                  },
                  child: Text(
                    'Edit profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  )
                )
              : Container(
                key: const ValueKey('profile_follow_button'),
                child: FollowButton(user: user),
              ) 
        ]),
      ),

      const SizedBox(height: 6),

      // Name and handle
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user.name ?? '', key: const ValueKey('profile_display_name'), style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 22, fontWeight: FontWeight.bold)),
          Text('@${user.username ?? ''}', key: const ValueKey('profile_username'), style: const TextStyle(color: Colors.grey)),
        ]),
      ),

      const SizedBox(height: 6),

      // Bio
      if ((user.bio ?? '').isNotEmpty)
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(user.bio!), key: const ValueKey('profile_bio'),),

      const SizedBox(height: 10),

      // Extra info
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(spacing: 12, runSpacing: 6, children: [
          if ((user.location ?? '').isNotEmpty)
            Row(key: const ValueKey('profile_location'), mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.location_on_outlined, size: 16), const SizedBox(width: 4), Text(user.location ?? '')]),


          if ((user.birthDate ?? '').isNotEmpty)
              Row(
                key: const ValueKey('profile_birthdate'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cake_outlined, size: 16),
                  const SizedBox(width: 4),

                  // Format the date properly
                  Text(
                    (user.birthDate ?? '').split("T").first, // <-- FIX
                  ),
                ],
              ),

              if ((user.website ?? '').isNotEmpty)
              GestureDetector(
                key: const ValueKey('profile_website'),
                onTap: () async {
                  final url = Uri.parse(user.website!);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      user.website!,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),


          if ((user.createdAt ?? '').isNotEmpty)
            Row(key: const ValueKey('profile_joined_date'), mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.calendar_today_outlined, size: 16), const SizedBox(width: 4), Text('Joined ${user.createdAt!.split("T").first}')]),
        ]),
      ),

      const SizedBox(height: 12),

      // Following / Followers - navigates to FollowersFollowingPage
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(children: [
          GestureDetector(
            key: const ValueKey('profile_following_button'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersFollowingPage(userId: user.id ?? 0, initialTab: 1)));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: '${user.followingCount} ', style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                const TextSpan(text: 'Following', style: TextStyle(color: Colors.grey)),
              ]),
            ),
          ),

          const SizedBox(width: 16),

          GestureDetector(
            key: const ValueKey('profile_followers_button'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FollowersFollowingPage(userId: user.id ?? 0, initialTab: 0)));
            },
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: '${user.followersCount} ', style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
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
