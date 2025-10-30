import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../profile_header/ui/viewmodel/profile_header_viewmodel.dart';
import '../../../../core/widgets/app_outlined_button.dart';
import '../../../profile_edit/ui/view/edit_profile_page.dart';

class ProfileHeaderWidget extends ConsumerStatefulWidget {
  final String userId;

  const ProfileHeaderWidget({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<ProfileHeaderWidget> createState() =>
      _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends ConsumerState<ProfileHeaderWidget> {
  @override
  void initState() {
    super.initState();
    // Load the profile for this user when widget mounts
    Future.microtask(() {
      ref
          .read(profileHeaderViewModelProvider.notifier)
          .loadProfileHeader(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileHeaderViewModelProvider);

    return profileState.when(
      data: (profile) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.network(
                  profile.bannerImage,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
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
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerRight,
                child: AppOutlinedButton(
                  text: 'Edit Profile',
                  onPressed: () {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    profile.displayName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  if (profile.isVerified) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Colors.blue, size: 20),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('@${profile.handle}',
                  style: const TextStyle(color: Colors.grey, fontSize: 15)),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(profile.bio,
                  style: const TextStyle(fontSize: 15)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  if (profile.location.isNotEmpty) ...[
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(profile.location,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14)),
                    const SizedBox(width: 12),
                  ],
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(profile.joinedDate,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFollowCount(profile.followingCount.toString(), 'Following'),
                  const SizedBox(width: 16),
                  _buildFollowCount(profile.followersCount.toString(), 'Followers'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('❌ Error loading profile: $error'),
      ),
    );
  }

  Widget _buildFollowCount(String count, String label) {
    return Row(
      children: [
        Text(count,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 15)),
      ],
    );
  }
}
