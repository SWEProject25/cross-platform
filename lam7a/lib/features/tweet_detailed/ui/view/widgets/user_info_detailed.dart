import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet_summary/models/tweet.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_user_provider.dart';

class TweetUserInfoDetailed extends ConsumerStatefulWidget {
  //need userProvider to check for changes for now i use static data
  const TweetUserInfoDetailed({
    super.key,
    required this.tweet,
    required this.daysPosted,
  });
  final TweetModel tweet;
  final int daysPosted;
  @override
  ConsumerState<TweetUserInfoDetailed> createState() {
    return _TweetUserInfoDetailed();
  }
}

class _TweetUserInfoDetailed extends ConsumerState<TweetUserInfoDetailed> {
  @override
  Widget build(BuildContext context) {
    //need userProvider to check for changes for now i use static data
    final userAsync = ref.watch(userByIdProvider(widget.tweet.userId));
    return Row(
      children: [
        userAsync.when(
          data: (user) => CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.profilePic.toString()),
            backgroundColor: Colors.grey[200], // optional placeholder color
          ),
          loading: () =>
              const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
          error: (err, _) => const Icon(Icons.error),
        ),
        SizedBox(width: 10),
        Column(
          children: [
            SizedBox(width: 20, height: 5),
            userAsync.when(
              data: (user) => Text(
                user.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
              loading: () =>
                  const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
              error: (err, _) => const Icon(Icons.error),
            ),
            SizedBox(height: 10),
            userAsync.when(
              data: (user) => Text(
                user.hashUserName,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
              loading: () =>
                  const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
              error: (err, _) => const Icon(Icons.error),
            ),
          ],
        ),
      ],
    );
  }
}
