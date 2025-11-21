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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TweetUserSummaryInfo(
                        tweetState: tweetState,
                        daysPosted: daysPosted,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.rocket,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => ref
                          .read(tweetViewModelProvider(tweet.id).notifier)
                          .summarizeBody(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                const SizedBox(height: 6),
                TweetFeed(tweetState: tweetState),
              ],
            );
          },
          loading: () => const _TweetSkeleton(),
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
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.only(left: 10),
        child: tweetAsync.when(
          data: (tweetState) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TweetUserSummaryInfo(
                      tweetState: tweetState,
                      daysPosted: daysPosted,
                      fallbackTweet: tweet,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.rocket,
                      size: 20,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () => ref
                        .read(tweetViewModelProvider(tweet.id).notifier)
                        .summarizeBody(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
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
              const SizedBox(height: 6),
              TweetFeed(tweetState: tweetState),
            ],
          ),
          loading: () => const _TweetSkeleton(),
          error: (_, __) => const Center(child: Text('Error loading tweet')),
        ),
      ),
    );
  }
}

class _TweetSkeleton extends StatelessWidget {
  const _TweetSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
