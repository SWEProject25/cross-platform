import 'package:flutter/material.dart';
import '../../models/users_model.dart';

enum Style { muted, blocked }

class StatusUserTile extends StatelessWidget {
  final User user;
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1️⃣ Smaller avatar that fits upper half of the tile
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 18, // smaller radius
            ),
          ),
          const SizedBox(width: 12),

          // 2️⃣ + 3️⃣ Expanded text section with wrapping bio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.handle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  user.bio,
                  style: TextStyle(
                    color: Colors.grey.shade200, // 2️⃣ slightly whiter
                    fontSize: 14, // 2️⃣ bigger font
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // 4️⃣ Bright red bubbled button (filled, rounded, bold)
          ElevatedButton(
            onPressed: onCliked,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(
                255,
                247,
                10,
                10,
              ), // bright red fill
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // bubbled shape
              ),
              elevation: 2,
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(
                color: Colors.white, // white text
                fontSize: 15, // bigger font
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
