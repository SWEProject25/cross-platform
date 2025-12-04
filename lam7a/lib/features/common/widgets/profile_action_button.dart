// lib/features/profile/ui/widgets/follow_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';

class FollowButton extends ConsumerStatefulWidget {
  final UserModel initialProfile;
  const FollowButton({super.key, required this.initialProfile});

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  late UserModel _profile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile;
  }

  @override
  Widget build(BuildContext context) {
    final isFollowing = _profile.stateFollow == ProfileStateOfFollow.following;

    return OutlinedButton(
      onPressed: _loading ? null : _toggle,
      style: OutlinedButton.styleFrom(
        backgroundColor: isFollowing
            ? Colors.white
            : const Color.fromARGB(223, 255, 255, 255),
        foregroundColor: isFollowing ? Colors.black : Colors.black,
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: _loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              isFollowing ? 'Following' : 'Follow',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
    );
  }

  Future<void> _toggle() async {
    setState(() => _loading = true);
    final repo = ref.read(profileRepositoryProvider);
    try {
      if (_profile.stateFollow == ProfileStateOfFollow.following) {
        await repo.unfollowUser(_profile.id!);
        _profile = _profile.copyWith(
          stateFollow: ProfileStateOfFollow.notfollowing,
          followersCount: (_profile.followersCount - 1).clamp(0, 1 << 30),
        );
      } else {
        await repo.followUser(_profile.id!);
        _profile = _profile.copyWith(
          stateFollow: ProfileStateOfFollow.following,
          followersCount: _profile.followersCount + 1,
        );
      }
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Action failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
