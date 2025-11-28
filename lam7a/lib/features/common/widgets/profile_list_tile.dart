import 'package:flutter/material.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import 'package:lam7a/features/profile/ui/view/profile_screen.dart';
import 'profile_action_button.dart';

enum ProfileActionType { follow, unfollow, unmute, unblock }

class ProfileTile extends StatelessWidget {
  final ProfileModel profile;

  const ProfileTile({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(profile.avatarImage),
      ),
      title: Row(
        children: [
          Text(
            profile.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (profile.isVerified) const SizedBox(width: 6),
          if (profile.isVerified)
            const Icon(Icons.verified, size: 16, color: Colors.blue),
        ],
      ),
      subtitle: Text(
        '@${profile.handle}\n${profile.bio}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FollowButton(initialProfile: profile),
      isThreeLine: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProfileScreen(),
            settings: RouteSettings(arguments: {"username": profile.handle}),
          ),
        );
      },
    );
  }
}
