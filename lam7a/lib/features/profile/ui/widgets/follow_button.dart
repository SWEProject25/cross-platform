// lib/features/profile/ui/widgets/follow_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';


class FollowButton extends ConsumerStatefulWidget {
  final UserModel user;
  final VoidCallback? onFollowStateChanged;

  const FollowButton({super.key, required this.user, this.onFollowStateChanged});

  @override
  ConsumerState<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends ConsumerState<FollowButton> {
  late UserModel _user;
  bool _loading = false;



  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  Future<void> _toggle() async {
    setState(() => _loading = true);

    final repo = ref.read(profileRepositoryProvider);

    try {
      if (_user.stateFollow == ProfileStateOfFollow.following) {
        await repo.unfollowUser(_user.id ?? 0);
        _user = _user.copyWith(
          stateFollow: ProfileStateOfFollow.notfollowing,
          followersCount: (_user.followersCount - 1).clamp(0, 999999),
        );

        await ref
            .read(tweetHomeViewModelProvider.notifier)
            .refreshFollowingTweets();
        UserModel myUser = ref.watch(authenticationProvider).user!;
        ref
            .read(authenticationProvider.notifier)
            .updateUser(
              myUser.copyWith(followingCount: myUser.followingCount - 1),
            );
      } else {
        await repo.followUser(_user.id ?? 0);
        _user = _user.copyWith(
          stateFollow: ProfileStateOfFollow.following,
          followersCount: _user.followersCount + 1,
        );
        await ref
            .read(tweetHomeViewModelProvider.notifier)
            .refreshFollowingTweets();

        UserModel myUser = ref.watch(authenticationProvider).user!;
        ref
            .read(authenticationProvider.notifier)
            .updateUser(
              myUser.copyWith(followingCount: myUser.followingCount + 1),
            );
      }
      widget.onFollowStateChanged?.call();

      if (mounted) setState(() {});
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFollowing = _user.stateFollow == ProfileStateOfFollow.following;

    final isFollowingMe =
        _user.stateFollowingMe == ProfileStateFollowingMe.followingme;

    return OutlinedButton(
      key: const ValueKey('follow_button'),
      onPressed: _loading ? null : _toggle,
      style: OutlinedButton.styleFrom
      (
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
        ),


        backgroundColor: isFollowing ? Colors.white : Colors.black,
        foregroundColor: isFollowing ? Colors.black : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ), 
      ),
      child: _loading
          ? const SizedBox(
              width: 16,
              height: 8,
              child: CircularProgressIndicator(key: ValueKey('follow_button_loading'), strokeWidth: 2),
            )
          : Text(
              isFollowing
                  ? "Following"
                  : isFollowingMe
                  ? "Follow Back"
                  : "Follow",
              key: const ValueKey('follow_button_label'),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
    );
  }
}
