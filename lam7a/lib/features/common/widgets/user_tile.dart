import 'package:flutter/material.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'profile_action_button.dart';

class UserTile extends StatelessWidget {
  final UserModel user;

  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
            settings: RouteSettings(arguments: {"username": user.username}),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 3),
              child: CircleAvatar(
                backgroundImage: (user.profileImageUrl?.isNotEmpty ?? false)
                    ? NetworkImage(user.profileImageUrl!)
                    : null,

                radius: 20,
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFF0F1418)
                          : Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  Text(
                    "@${user.username!}",
                    style: TextStyle(
                      color: theme.brightness == Brightness.light
                          ? const Color(0xFF7C868E)
                          : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (user.bio != null && user.bio!.isNotEmpty)
                    Text(
                      user.bio!,
                      style: TextStyle(
                        color: theme.brightness == Brightness.light
                            ? const Color(0xFF101415)
                            : const Color(0xFF8B98A5),
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            FollowButton(initialProfile: user),
          ],
        ),
      ),
    );
  }
}
