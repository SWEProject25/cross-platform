// lib/features/profile/ui/widgets/profile_action_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';

class ProfileActionMenu extends ConsumerWidget {
  final UserModel user;
  const ProfileActionMenu({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (v) {
        if (v == 'notifications') {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
            builder: (_) => Container(
              padding: const EdgeInsets.all(16),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text("Don't miss a thing", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('@${user.username ?? ''}', style: const TextStyle(color: Colors.grey)),
              ]),
            ),
          );
        }
        // mute, block, share, etc. can call API via service provider
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'share', child: Text('Share')),
        const PopupMenuItem(value: 'turnoff', child: Text('Turn off reposts')),
        const PopupMenuItem(value: 'lists', child: Text('Add/remove from Lists')),
        const PopupMenuItem(value: 'viewlists', child: Text('View Lists')),
        const PopupMenuItem(value: 'lists_on', child: Text("Lists they're on")),
        const PopupMenuItem(value: 'mute', child: Text('Mute')),
        const PopupMenuItem(value: 'block', child: Text('Block')),
        const PopupMenuItem(value: 'report', child: Text('Report')),
      ],
    );
  }
}

