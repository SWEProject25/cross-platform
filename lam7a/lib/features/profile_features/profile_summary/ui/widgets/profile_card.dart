import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/profile_model.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../../../core/widgets/app_dialog.dart';
import '../../../../../core/widgets/app_outlined_button.dart';

class ProfileCard extends ConsumerWidget {
  final ProfileModel profile;

  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(profileViewModelProvider.notifier);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/profile', arguments: profile);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            CircleAvatar(
              backgroundImage: NetworkImage(profile.imageUrl),
              radius: 25,
            ),
            const SizedBox(width: 12),

            // Profile Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
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
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 16,
                          ),
                        ),
                    ],
                  ),
                  Text(
                    profile.username,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile.bio,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Follow Button
            if (profile.stateFollow == ProfileStateOfFollow.following)
              AppOutlinedButton(
                text: 'Following',
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'Unfollow ${profile.name}?',
                    message:
                        'Their posts will no longer show up in your home timeline. You can still view their profile, unless their posts are protected.',
                    confirmText: 'Unfollow',
                  );
                  if (confirmed == true) {
                    viewModel.unfollow(profile.username);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
