// lib/features/profile/ui/widgets/profile_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import 'follow_button.dart';

class ProfileCard extends ConsumerWidget {
  final UserModel user;

  const ProfileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: (user.profileImageUrl != null &&
                user.profileImageUrl!.isNotEmpty)
            ? NetworkImage(user.profileImageUrl!)
            : null,
      ),

      title: Text(
        user.name ?? "Unknown",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),

      subtitle: Text(
        "@${user.username ?? ''}",
        style: const TextStyle(color: Colors.grey),
      ),

      trailing: FollowButton(user: user),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
            settings: RouteSettings(arguments: {"username": user.username}),
          ),
        );
      },
    );
  }
}
