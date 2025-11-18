import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model2/profile_model.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../core/widgets/app_outlined_button.dart';
import '../view/other_user_profile_screen.dart';

class ProfileCard extends ConsumerWidget {
  final ProfileModel profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);
    final isFollowing = profile.stateFollow == ProfileStateOfFollow.following;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========== LEFT SIDE: CLICKABLE USER INFO ==========
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OtherUserProfileScreen(
                      userId: profile.username, // or profile.id
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile picture
                  CircleAvatar(
                    backgroundImage: NetworkImage(profile.imageUrl),
                    radius: 25,
                  ),

                  const SizedBox(width: 12),

                  // Text info takes flexible space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                profile.name,
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
                          profile.username,
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

          // ========== RIGHT SIDE: FOLLOW BUTTON ==========
          AppOutlinedButton(
            text: isFollowing ? 'Following' : 'Follow',
            onPressed: () async {
              if (isFollowing) {
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Unfollow ${profile.name}?',
                  message:
                      'Their posts will no longer appear in your timeline.',
                  confirmText: 'Unfollow',
                );
                if (confirmed == true) {
                  viewModel.toggleFollow(profile.username);
                }
              } else {
                viewModel.toggleFollow(profile.username);
              }
            },
            backgroundColor: isFollowing ? Colors.white : Colors.black,
            textColor: isFollowing ? Colors.black : Colors.white,
            borderColor: isFollowing
                ? const Color.fromRGBO(207, 217, 222, 1)
                : Colors.black,
          ),
        ],
      ),
    );
  }
}

