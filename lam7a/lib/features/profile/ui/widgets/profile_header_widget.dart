// lib/features/profile/ui/widgets/profile_header_widget.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/ui/view/edit_profile_page.dart';
import 'package:lam7a/features/profile/ui/view/followers_following_page.dart';
import 'package:lam7a/features/profile/ui/widgets/follow_button.dart';
import 'package:lam7a/features/profile/ui/widgets/profile_action_menu.dart';
import 'package:lam7a/features/profile/ui/widgets/profile_notifications_sheet.dart';

const String _devFallbackBanner = '/mnt/data/WhatsApp Image 2025-11-16 at 11.45.44 AM (1).jpeg';

class ProfileHeaderWidget extends ConsumerWidget {
  final ProfileModel profile;
  final bool isOwnProfile;
  final VoidCallback? onEdited; // parent can provide to refresh

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    this.isOwnProfile = false,
    this.onEdited,
  });

  ImageProvider _imageFromPath(String path, {bool isBanner = false}) {
    if (path.isEmpty) {
      try {
        final f = File(_devFallbackBanner);
        if (f.existsSync()) return FileImage(f);
      } catch (_) {}
      return NetworkImage(isBanner ? 'https://via.placeholder.com/900x250' : 'https://via.placeholder.com/150');
    }
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
    final bool isFollowing = profile.stateFollow == ProfileStateOfFollow.following;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // banner + top actions
        Stack(
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image(
                image: _imageFromPath(profile.bannerImage, isBanner: true),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Row(
                  children: [
                    Material(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.maybePop(context),
                        child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.arrow_back, color: Colors.white)),
                      ),
                    ),
                    const Spacer(),
                    Material(
                      color: Colors.black26,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {},
                        child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.search, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ProfileActionMenu(profile: profile),
                  ],
                ),
              ),
            ),
          ],
        ),

        // avatar + actions row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -46,
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(radius: 43, backgroundImage: _imageFromPath(profile.avatarImage)),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(child: Container()),
                  Row(
                    children: [
                      if (!isOwnProfile)
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mail_outline),
                        ),
                      if (!isOwnProfile)
                        IconButton(
                          onPressed: () async {
                            final res = await showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
                              isScrollControlled: true,
                              builder: (_) => ProfileNotificationsSheet(username: profile.handle),
                            );
                            // res contains selected option if needed
                          },
                          icon: const Icon(Icons.notifications_none),
                        ),
                      if (isOwnProfile)
                        OutlinedButton(
                          onPressed: () async {
                            final updated = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditProfilePage(profile: profile)),
                            );
                            if (updated != null && updated is ProfileModel) {
                              if (onEdited != null) onEdited!();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Edit profile'),
                        )
                      else
                        FollowButton(initialProfile: profile),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // name, handle, optional verified & Get verified
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(profile.displayName, style: titleStyle),
              const SizedBox(width: 6),
              if (profile.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 18),
              if (isOwnProfile)
                TextButton(onPressed: () {}, child: const Text('Get Verified', style: TextStyle(color: Colors.blue))),
            ]),
            const SizedBox(height: 2),
            Text('@${profile.handle}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            if (profile.bio.isNotEmpty) Text(profile.bio),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 6, children: [
              if (profile.location.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(profile.location, style: const TextStyle(color: Colors.grey)),
                ]),
              if (profile.birthday.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.cake_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(profile.birthday, style: const TextStyle(color: Colors.grey)),
                ]),
              if (profile.joinedDate.isNotEmpty)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(profile.joinedDate, style: const TextStyle(color: Colors.grey)),
                ]),
            ]),
            const SizedBox(height: 12),

            // Following / Followers row with navigation
            Row(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FollowersFollowingPage(userId: profile.userId, initialTab: 1),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${profile.followingCount} ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    const TextSpan(text: 'Following', style: TextStyle(color: Colors.grey)),
                  ]),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FollowersFollowingPage(userId: profile.userId, initialTab: 0),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(text: '${profile.followersCount} ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    const TextSpan(text: 'Followers', style: TextStyle(color: Colors.grey)),
                  ]),
                ),
              ),
            ]),

            const SizedBox(height: 8),
            const Text('Not followed by anyone you’re following', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
