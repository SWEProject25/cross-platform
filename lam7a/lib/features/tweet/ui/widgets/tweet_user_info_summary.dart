import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class TweetUserSummaryInfo extends ConsumerStatefulWidget {
  const TweetUserSummaryInfo({
    super.key,
    required this.tweetState,
    required this.daysPosted,
    this.fallbackTweet,
  });
  
  final TweetState tweetState;
  final int daysPosted;
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
    
    final daysPosted = widget.daysPosted;
    
    // Use user data directly from tweet model (from backend)
    final username = tweet.username ?? 'unknown';
    final displayName = (tweet.authorName != null && tweet.authorName!.isNotEmpty)
        ? tweet.authorName!
        : username;
    final String? profileImage = tweet.authorProfileImage;

    return Row(
      children: [
        CircleAvatar(
          radius: 19,
          backgroundColor: Colors.grey[700],
          backgroundImage: profileImage != null && profileImage!.isNotEmpty
              ? NetworkImage(profileImage!)
              : null,
          child: profileImage == null || profileImage!.isEmpty
              ? Text(
                  username.isNotEmpty ? username[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 8, height: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      '@$username',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${daysPosted}d',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}