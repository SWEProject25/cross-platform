import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/services/mock_user_api_service.dart';

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
    
    final userAsync = ref.watch(userByIdProvider(tweet.userId));
    final daysPosted = widget.daysPosted;
    
    return Row(
      children: [
        userAsync.when(
          data: (user) => CircleAvatar(
            radius: 19,
            backgroundImage: NetworkImage(user.profilePic.toString()),
            backgroundColor: Colors.grey[200],
          ),
          loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
          error: (err, _) => const Icon(Icons.error),
        ),
        const SizedBox(width: 10, height: 5),
        userAsync.when(
          data: (user) => Text(
            user.username,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
          error: (err, _) => const Icon(Icons.error),
        ),
        const SizedBox(width: 10),
        userAsync.when(
          data: (user) => Text(
            user.hashUserName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
          error: (err, _) => const Icon(Icons.error),
        ),
        const SizedBox(width: 10),
        Text('${daysPosted}d'),
        const SizedBox(width: 10),
      ],
    );
  }
}