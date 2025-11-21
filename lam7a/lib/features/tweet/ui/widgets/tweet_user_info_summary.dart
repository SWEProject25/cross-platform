import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';

class TweetUserSummaryInfo extends ConsumerStatefulWidget {
  const TweetUserSummaryInfo({
    super.key,
    required this.tweetState,
    required this.daysPosted,
  });
  
  final TweetState tweetState;
  final int daysPosted;
  
  @override
  ConsumerState<TweetUserSummaryInfo> createState() {
    return _TweetUserSummaryInfoState();
  }
}

class _TweetUserSummaryInfoState extends ConsumerState<TweetUserSummaryInfo> {
  @override
  Widget build(BuildContext context) {
    // Safe null check
    final tweet = widget.tweetState.tweet.value;
    if (tweet == null) {
      return const SizedBox.shrink();
    }
    
    final daysPosted = widget.daysPosted;
    
    // Use user data directly from tweet model (from backend)
    final username = tweet.username ?? 'unknown';
    final displayName = tweet.authorName ?? username;
    final profileImage = tweet.authorProfileImage;
    
    return Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: Colors.grey[700],
          backgroundImage: profileImage != null && profileImage.isNotEmpty
              ? NetworkImage(profileImage)
              : null,
          child: profileImage == null || profileImage.isEmpty
              ? Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10, height: 5),
        SizedBox(
          width: 160,
          child: Text(
            displayName,
            style:  TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
         SizedBox(
          width: 80,
        child: Text(
          '@$username',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            overflow: TextOverflow.ellipsis,
          ),
        ),
         ),
        const SizedBox(width: 10),
        Text('${daysPosted}d'),
        const SizedBox(width: 10),
      ],
    );
  }
}