import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';
import '../view/profile_screen.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profile;
  final VoidCallback? onFollowToggle;

  const ProfileCard({super.key, required this.profile, this.onFollowToggle});

  ImageProvider _imageProvider(String path) {
    if (path.isEmpty) return const NetworkImage('https://via.placeholder.com/150');
    if (path.startsWith('http')) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  Widget build(BuildContext context) {
    final isFollowing = profile.stateFollow == ProfileStateOfFollow.following;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundImage: _imageProvider(profile.avatarImage)),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(username: profile.handle))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Text(profile.displayName, style: const TextStyle(fontWeight: FontWeight.bold))),
                    if (profile.isVerified) const Icon(Icons.verified, color: Colors.blue, size: 16),
                  ]),
                  Text('@${profile.handle}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 6),
                  Text(profile.bio, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: onFollowToggle,
            style: OutlinedButton.styleFrom(
              backgroundColor: isFollowing ? Colors.white : Colors.black,
              foregroundColor: isFollowing ? Colors.black : Colors.white,
              side: BorderSide(color: isFollowing ? Colors.grey.shade300 : Colors.black),
            ),
            child: Text(isFollowing ? 'Following' : 'Follow'),
          ),
        ],
      ),
    );
  }
}
