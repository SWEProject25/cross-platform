import 'package:flutter/material.dart';
import '../../model/profile_header_model.dart';
import '../../../../core/widgets/app_outlined_button.dart';
import '../../../profile_edit/ui/view/edit_profile_page.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileHeaderModel profile;
  final VoidCallback onEditPressed;

  const ProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Ban + Ava
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Ban
              Image.network(
                profile.bannerImage,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),

              // Ava overlapping ban bottom-left
              Positioned(
                left: 16,
                bottom: -40,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 37,
                    backgroundImage: NetworkImage(profile.avatarImage),
                  ),
                ),
              ),
            ],
          ),

          // Add space for the overlapping avatar
          const SizedBox(height: 10),

          // 🔹 Edit Profile button under ban
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: AppOutlinedButton(
                text: 'Edit Profile',
                onPressed: () {
                  debugPrint('🟦 Pressed Edit Profile');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(profile: profile),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Display Name + Verified Icon (option) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  profile.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                if (profile.isVerified) ...[
                  const SizedBox(width: 6),
                  const Icon(Icons.verified, color: Colors.blue, size: 20),
                ],
              ],
            ),
          ),

          // 🔹 Handle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '@${profile.handle}',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),

          const SizedBox(height: 8),

          // 🔹 Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              profile.bio,
              style: const TextStyle(fontSize: 15),
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Location + Joined Date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (profile.location.isNotEmpty) ...[
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    profile.location,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                ],
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  profile.joinedDate,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Followers & Following counts // TODO implement the logic for onPress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFollowCount('100', 'Following'),
                const SizedBox(width: 16),
                _buildFollowCount('256', 'Followers'),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// follower/following counts
  Widget _buildFollowCount(String count, String label) {
    return Row(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    );
  }
}
