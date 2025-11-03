import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_summary.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';

class TweetSummaryWidget extends ConsumerWidget {
  const TweetSummaryWidget({
    super.key,
    required this.tweetId,
    this.tweetData, // Optional: pre-loaded tweet data to avoid fetch
  });

  final String tweetId;
  final TweetModel? tweetData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If tweet data is provided, don't fetch by ID (avoids 404)
    if (tweetData != null) {
      return _buildTweetUI(context, ref, tweetData!);
    }
    
    // Otherwise fetch using ViewModel
    final tweetAsync = ref.watch(tweetViewModelProvider(tweetId));

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        key: Key(tweetId),
        color: Colors.black,
        padding: const EdgeInsets.only(left: 10),
        child: tweetAsync.when(
          data: (tweetState) {
            final tweet = tweetState.tweet.value;

            if (tweet == null) {
              return const Center(
                child: Text('Tweet data not available'),
              );
            }

            final daysPosted = DateTime.now().day - tweet.date.day;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === User row ===
                Row(
                  children: [
                    TweetUserSummaryInfo(
                      tweetState: tweetState,
                      daysPosted: daysPosted,
                    ),
                    IconButton(
                      icon: const Icon(Icons.rocket),
                      onPressed: () => ref
                          .read(tweetViewModelProvider(tweet.id).notifier)
                          .summarizeBody(),
                    ),
                  ],
                ),

                // === Tweet body ===
                GestureDetector(
                  onTap: () {
                    ref
                        .read(tweetViewModelProvider(tweetId).notifier)
                        .handleViews();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TweetScreen(
                          tweetId: tweetId,
                          tweetData: tweet, // Pass tweet data to avoid 404
                        ),
                      ),
                    );
                  },
                  child: TweetBodySummaryWidget(post: tweet),
                ),

                // === Tweet feed ===
                TweetFeed(tweetState: tweetState),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildTweetUI(BuildContext context, WidgetRef ref, TweetModel tweet) {
    final daysPosted = DateTime.now().day - tweet.date.day;
    
    // Watch the viewmodel to get proper state with interaction flags
    final tweetAsync = ref.watch(tweetViewModelProvider(tweetId));

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        key: Key(tweetId),
        color: Colors.black,
        padding: const EdgeInsets.only(left: 10),
        child: tweetAsync.when(
          data: (tweetState) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === User row ===
              Row(
                children: [
                  TweetUserSummaryInfo(
                    tweetState: tweetState,
                    daysPosted: daysPosted,
                  ),
                  IconButton(
                    icon: const Icon(Icons.rocket),
                    onPressed: () => ref
                        .read(tweetViewModelProvider(tweet.id).notifier)
                        .summarizeBody(),
                  ),
                ],
              ),

              // === Tweet body ===
              GestureDetector(
                onTap: () {
                  ref
                      .read(tweetViewModelProvider(tweetId).notifier)
                      .handleViews();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TweetScreen(
                        tweetId: tweetId,
                        tweetData: tweet, // Pass tweet data to avoid 404
                      ),
                    ),
                  );
                },
                child: TweetBodySummaryWidget(post: tweet),
              ),

              // === Tweet feed ===
              TweetFeed(tweetState: tweetState),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const Center(child: Text('Error loading tweet')),
        ),
      ),
    );
  }
}
