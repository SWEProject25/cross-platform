// lib/ui/widgets/profile_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/profile_model.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../widgets/profile_header_widget.dart';

class ProfileCard extends ConsumerWidget {
  final ProfileModel profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = profile.stateFollow == ProfileStateOfFollow.following;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // LEFT SIDE: CLICKABLE USER INFO
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileHeaderWidget(
                      userId: profile.handle,
                      isOwnProfile: false,
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profile.avatarImage),
                    radius: 25,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.displayName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.isVerified)
                              const Icon(Icons.verified,
                                  color: Colors.blue, size: 16),
                          ],
                        ),
                        Text(
                          '@${profile.handle}',
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.bio,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // RIGHT SIDE: FOLLOW BUTTON
          OutlinedButton(
            onPressed: () async {
              if (isFollowing) {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Unfollow ${profile.displayName}?'),
                    content: const Text(
                        'Their posts will no longer appear in your timeline.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Unfollow'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  ref.toggleFollowInList(profile.handle);
                }
              } else {
                ref.toggleFollowInList(profile.handle);
              }
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.white : Colors.black,
              foregroundColor: isFollowing ? Colors.black : Colors.white,
              side: BorderSide(
                color: isFollowing
                    ? const Color.fromRGBO(207, 217, 222, 1)
                    : Colors.black,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
