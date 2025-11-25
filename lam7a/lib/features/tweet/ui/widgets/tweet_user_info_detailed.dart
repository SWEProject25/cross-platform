import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/ui/widgets/follow_button.dart';

class TweetUserInfoDetailed extends ConsumerStatefulWidget {
  //need userProvider to check for changes for now i use static data
  const TweetUserInfoDetailed({
    super.key,
    required this.tweetState,
  });
  final TweetState tweetState;
  @override
  ConsumerState<TweetUserInfoDetailed> createState() {
    return _TweetUserInfoDetailed();
  }
}

class _TweetUserInfoDetailed extends ConsumerState<TweetUserInfoDetailed> {
  @override
  Widget build(BuildContext context) {
    final tweet= widget.tweetState.tweet;
    
    // Handle null tweet
    if (tweet.value == null) {
      return const SizedBox.shrink();
    }
    
    // Use user data directly from tweet model (from backend)
    final tweetData = tweet.value!;
    final username = tweetData.username ?? 'unknown';
    final displayName =
        (tweetData.authorName != null && tweetData.authorName!.isNotEmpty)
            ? tweetData.authorName!
            : username;
    final String? profileImage = tweetData.authorProfileImage;

    // Load profile via existing viewmodel so we can reuse FollowButton logic
    final asyncProfile = ref.watch(profileViewModelProvider(username));

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/profile',
                arguments: {'username': username},
              );
            },
            child: Row(
              children: [
                AppUserAvatar(
                  radius: 25,
                  imageUrl: profileImage,
                  displayName: displayName,
                  username: username,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '@$username',
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        asyncProfile.when(
          data: (profile) => FollowButton(initialProfile: profile),
          loading: () => OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (e, _) => OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            ),
            child: const Text('Follow'),
          ),
        ),
      ],
    );
  }
}
