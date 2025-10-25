import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet_detailed/ui/widgets/tweet_detailed_body.dart';
import 'package:lam7a/features/tweet_detailed/ui/widgets/tweet_detailed_feed.dart';
import 'package:lam7a/features/tweet_detailed/ui/widgets/tweet_user_info_detailed.dart';
import 'package:lam7a/features/tweet_summary/ui/viewmodel/tweet_viewmodel.dart';

class TweetDetailedWidget extends ConsumerWidget {
  final String tweetId;

  const TweetDetailedWidget({super.key, required this.tweetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetAsync = ref.watch(tweetViewModelProvider(tweetId));

    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        color: Colors.black,
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: tweetAsync.when(
            data: (tweet) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user
                TweetUserInfoDetailed(tweetState: tweet),

                // body
                const SizedBox(height: 10),
                TweetDetailedBodyWidget(tweetState: tweet),

                // feed
                TweetDetailedFeed(tweetState: tweet),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}
