import 'package:flutter/material.dart';
import '../../../../core/models/user_model.dart';

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.profileImageUrl!),
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
                const SizedBox(height: 2),
                Text(
                  user.username!,
                  style: TextStyle(
                    color: theme.brightness == Brightness.light
                        ? const Color(0xFF7C868E)
                        : Colors.grey,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
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
          FilledButton(
            key: const Key("action_button"),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF4222F),
              shape: const StadiumBorder(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            ),
            onPressed: onCliked,
            child: Container(
              padding: const EdgeInsets.all(0),
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
