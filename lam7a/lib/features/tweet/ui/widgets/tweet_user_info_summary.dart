import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class TweetUserSummaryInfo extends ConsumerStatefulWidget {
  const TweetUserSummaryInfo({
    super.key,
    required this.tweetState,
    required this.timeAgo,
    this.fallbackTweet,
  });
  
  final TweetState tweetState;
  final String timeAgo;
  // Optional richer tweet model from the feed (with avatar and authorName)
  final TweetModel? fallbackTweet;
  
  @override
  ConsumerState<TweetUserSummaryInfo> createState() {
    return _TweetUserSummaryInfoState();
  }
}

class _TweetUserSummaryInfoState extends ConsumerState<TweetUserSummaryInfo> {
  @override
  Widget build(BuildContext context) {
    // Prefer fallback tweet (from feed) when provided
    final tweet = widget.fallbackTweet ?? widget.tweetState.tweet.value;

    if (tweet == null) {
      return const SizedBox.shrink();
    }
    
    // Use user data directly from tweet model (from backend)
    final username = tweet.username ?? 'unknown';
    final displayName = (tweet.authorName != null && tweet.authorName!.isNotEmpty)
        ? tweet.authorName!
        : username;
    final String? profileImage = tweet.authorProfileImage;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/profile',
            arguments: {'username': username},
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold ), 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8,),
           Expanded(
             child: Text(
                '@$username · ',
                style:  Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, 
              ),
           ),
          
          Text(
            widget.timeAgo,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey )
          ),
        ],
      ),
      ),
    );
  }
}