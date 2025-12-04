import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';

class ProfileMoreMenu extends ConsumerWidget {
  final UserModel user;
  final String username;
  final VoidCallback onAction;

  const ProfileMoreMenu({
    super.key,
    required this.user,
    required this.username,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(profileRepositoryProvider);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) async {
        if (value == "mute") {
          if (user.stateMute == ProfileStateOfMute.muted) {
            await repo.unmuteUser(user.id!);
          } else {
            await repo.muteUser(user.id!);
          }
        }

        if (value == "block") {
          if (user.stateBlocked == ProfileStateBlocked.blocked) {
            await repo.unblockUser(user.id!);
          } else {
            await repo.blockUser(user.id!);
          }
        }

        onAction();
      },

      itemBuilder: (_) => [
        PopupMenuItem(
          value: "mute",
          child: Text(
            user.stateMute == ProfileStateOfMute.muted ? "Unmute" : "Mute",
          ),
        ),
        PopupMenuItem(
          value: "block",
          child: Text(
            user.stateBlocked == ProfileStateBlocked.blocked ? "Unblock" : "Block",
          ),
        ),
      ],
    );
  }
}
