import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/widgets/app_user_avatar.dart';
import '../../../../features/profile/ui/view/profile_screen.dart';

enum Style { muted, blocked }

class StatusUserTile extends StatelessWidget {
  final UserModel user;
  final Style style;
  final VoidCallback onCliked;

  const StatusUserTile({
    super.key,
    required this.user,
    required this.style,
    required this.onCliked,
  });

  @override
  Widget build(BuildContext context) {
    final actionLabel = style == Style.muted ? 'Muted' : 'Blocked';
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // makes empty space clickable
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const ProfileScreen(),
              settings: RouteSettings(arguments: {"username": user.username}),
              transitionsBuilder: (_, _, _, child) {
                return child;
              },
            ),
          );
        },

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppUserAvatar(
              radius: 20,
              imageUrl: user.profileImageUrl,
              displayName: user.name,
              username: user.username,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),
            FilledButton(
              key: const Key("action_button"),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF4222F),
                shape: const StadiumBorder(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              ),
              onPressed: onCliked,
              child: Text(
                actionLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
