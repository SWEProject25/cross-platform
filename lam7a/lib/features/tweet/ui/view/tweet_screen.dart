import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_body_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_detailed.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import '../../ui/widgets/tweet_ai_summery.dart';

class TweetScreen extends ConsumerWidget {
  final String tweetId;
  final TweetModel? tweetData; // Optional: pre-loaded tweet to avoid 404

  const TweetScreen({super.key, required this.tweetId, this.tweetData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If tweet data provided, use it directly (avoids 404 from backend)
    if (tweetData != null) {
      final tweetState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(tweetData!),
      );
      final repliesAsync = ref.watch(tweetRepliesViewModelProvider(tweetId));
      final isPureRepost =
          tweetData!.isRepost &&
          !tweetData!.isQuote &&
          tweetData!.originalTweet != null;
      final username = tweetData!.username ?? 'unknown';
      final displayName =
          (tweetData!.authorName != null && tweetData!.authorName!.isNotEmpty)
          ? tweetData!.authorName!
          : username;

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Text('Post', style: Theme.of(context).textTheme.titleMedium),
          centerTitle: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isPureRepost) ...[
                    Row(
                      children: [
                        const Icon(Icons.repeat, size: 18, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$displayName reposted',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TweetUserInfoDetailed(tweetState: tweetState),
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.rocket,
                          size: 17,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TweetDetailedBodyWidget(tweetState: tweetState),
                  const SizedBox(height: 8),
                  TweetDetailedFeed(tweetState: tweetState),
                  const SizedBox(height: 16),
                  repliesAsync.when(
                    data: (replies) {
                      if (replies.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: replies
                            .map(
                              (reply) => Column(
                                children: [
                                  const Divider(
                                    color: Colors.white24,
                                    thickness: 0.3,
                                    height: 1,
                                  ),
                                  TweetSummaryWidget(
                                    tweetId: reply.id,
                                    tweetData: reply,
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Otherwise fetch using ViewModel (will fail with 404 if backend doesn't support it)
    final tweetAsync = ref.watch(tweetViewModelProvider(tweetId));
    final repliesAsync = ref.watch(tweetRepliesViewModelProvider(tweetId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Text('Post', style: Theme.of(context).textTheme.titleMedium),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: tweetAsync.when(
              data: (tweet) {
                final tweetModel = tweet.tweet.value;
                final isPureRepost =
                    tweetModel != null &&
                    tweetModel.isRepost &&
                    !tweetModel.isQuote &&
                    tweetModel.originalTweet != null;
                final username = tweetModel?.username ?? 'unknown';
                final displayName =
                    (tweetModel?.authorName != null &&
                        tweetModel!.authorName!.isNotEmpty)
                    ? tweetModel!.authorName!
                    : username;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPureRepost) ...[
                      Row(
                        children: [
                          const Icon(
                            Icons.repeat,
                            size: 18,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$displayName reposted',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],  
                      ),
                      const SizedBox(height: 4),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TweetUserInfoDetailed(tweetState: tweet),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.rocket,
                            size: 17,
                            color: Colors.blueAccent,
                          ),
                          onTap: () {
                            if (tweetModel == null) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TweetAiSummary(tweet: tweetModel),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TweetDetailedBodyWidget(tweetState: tweet),
                    const SizedBox(height: 8),
                    TweetDetailedFeed(tweetState: tweet),
                    const SizedBox(height: 16),
                    repliesAsync.when(
                      data: (replies) {
                        if (replies.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: replies
                              .map(
                                (reply) => Column(
                                  children: [
                                    const Divider(
                                      color: Colors.white24,
                                      thickness: 0.3,
                                      height: 1,
                                    ),
                                    TweetSummaryWidget(
                                      tweetId: reply.id,
                                      tweetData: reply,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        );
                      },
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => const SizedBox.shrink(),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ),
      ),
    );
  }
}
