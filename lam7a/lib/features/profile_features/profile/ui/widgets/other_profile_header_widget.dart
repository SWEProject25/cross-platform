import 'dart:io';
import 'package:flutter/material.dart';
import '../view/followers_following_page.dart';
import '../../model/profile_model.dart';

class OtherProfileHeaderWidget extends StatefulWidget {
  final ProfileHeaderModel profile;

  const OtherProfileHeaderWidget({super.key, required this.profile});

  @override
  State<OtherProfileHeaderWidget> createState() =>
      _OtherProfileHeaderWidgetState();
}

class _OtherProfileHeaderWidgetState extends State<OtherProfileHeaderWidget> {
  bool _isFollowing = false;

  ImageProvider _getImage(String path, {bool isBanner = false}) {
    if (path.isEmpty) {
      return NetworkImage(
        isBanner
            ? 'https://via.placeholder.com/400x150'
            : 'https://via.placeholder.com/150',
      );
    }
    if (path.startsWith("http")) return NetworkImage(path);
    return FileImage(File(path));
  }

  @override
  void initState() {
    super.initState();
    _isFollowing = false;
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== Banner + Avatar =====
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image(
                image: _getImage(profile.bannerImage, isBanner: true),
                width: MediaQuery.of(context).size.width,
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
                    backgroundImage: _getImage(profile.avatarImage),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          /// ===== Follow Button =====
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: FilledButton(
                onPressed: () {
                  setState(() => _isFollowing = !_isFollowing);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _isFollowing ? Colors.white : Colors.black,
                  side: const BorderSide(color: Colors.black),
                ),
                child: Text(
                  _isFollowing ? "Following" : "Follow",
                  style: TextStyle(
                    color: _isFollowing ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          /// ===== Name + Verification =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  profile.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (profile.isVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.verified, color: Colors.blue, size: 18),
                  ),
              ],
            ),
          ),

          /// Handle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "@${profile.handle}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          /// Bio
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(profile.bio),
          ),

          /// ===== Location + Joined =====
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

          /// ===== Followers + Following (Clickable) =====
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FollowersFollowingPage(
                          username: profile.displayName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "${profile.followingCount} Following",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FollowersFollowingPage(
                          username: profile.displayName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "${profile.followersCount} Followers",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
