import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';

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
    final displayName = (tweetData.authorName != null && tweetData.authorName!.isNotEmpty)
        ? tweetData.authorName!
        : username;
    final String? profileImage = tweetData.authorProfileImage;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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
       const SizedBox(width: 8),
       const Spacer(),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2), // slimmer vertically
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // avoids extra height
          minimumSize: Size.zero, // removes default min constraints
        ),
        child: const Text("Follow"),
      ),
    ),
      ],
    );
  }
}
