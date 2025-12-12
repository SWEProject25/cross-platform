import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
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
                  // Check if this is a reply (has parent tweet, not repost/quote)
                  if (!isPureRepost &&
                      !tweetData!.isQuote &&
                      tweetData!.originalTweet != null) ...[
                    // This is a reply - show parent tweet at top with connector
                    _buildParentTweetWithConnector(
                      context,
                      ref,
                      tweetData!.originalTweet!,
                      tweetData!,
                      tweetState,
                    ),
                  ] else ...[
                    // Regular tweet or repost - show normal layout
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
                  ],
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
                    // Check if this is a reply (has parent tweet, not repost/quote)
                    if (tweetModel != null &&
                        !isPureRepost &&
                        !tweetModel.isQuote &&
                        tweetModel.originalTweet != null) ...[
                      // This is a reply - show parent tweet at top with connector
                      _buildParentTweetWithConnector(
                        context,
                        ref,
                        tweetModel.originalTweet!,
                        tweetModel,
                        tweet,
                      ),
                    ] else ...[
                      // Regular tweet or repost - show normal layout
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
                    ],
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

  /// Builds the parent tweet at top with connector line to reply tweet
  Widget _buildParentTweetWithConnector(
    BuildContext context,
    WidgetRef ref,
    TweetModel parentTweet,
    TweetModel replyTweet,
    TweetState replyTweetState,
  ) {
    final theme = Theme.of(context);
    const double avatarRadius = 25.0;

    final parentUsername = parentTweet.username ?? 'unknown';
    final parentDisplayName =
        (parentTweet.authorName != null && parentTweet.authorName!.isNotEmpty)
        ? parentTweet.authorName!
        : parentUsername;

    final replyUsername = replyTweet.username ?? 'unknown';
    final replyDisplayName =
        (replyTweet.authorName != null && replyTweet.authorName!.isNotEmpty)
        ? replyTweet.authorName!
        : replyUsername;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Parent tweet with avatar and connector
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left column: parent avatar + connector line
            Column(
              children: [
                AppUserAvatar(
                  radius: avatarRadius,
                  imageUrl: parentTweet.authorProfileImage,
                  displayName: parentDisplayName,
                  username: parentUsername,
                ),
                Container(width: 2, height: 80, color: Colors.grey),
              ],
            ),
            const SizedBox(width: 10),
            // Parent tweet content - whole area tappable to open parent tweet
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TweetScreen(
                        tweetId: parentTweet.id,
                        tweetData: parentTweet,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Parent user info with time
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            parentDisplayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/profile',
                                arguments: {'username': parentUsername},
                              );
                            },
                            child: Text(
                              '@$parentUsername',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          ' · ${_formatTimeAgo(parentTweet.date)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Parent body and media
                    TweetBodySummaryWidget(
                      post: parentTweet,
                      disableOriginalTap: true,
                    ),
                    const SizedBox(height: 8),
                    // Parent action bar
                    TweetFeed(
                      tweetState: TweetState(
                        isLiked: false,
                        isReposted: false,
                        isViewed: false,
                        tweet: AsyncValue.data(parentTweet),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Reply tweet user info (entire row tappable to open reply author's profile)
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(
              context,
            ).pushNamed('/profile', arguments: {'username': replyUsername});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(width: 2, height: 16, color: Colors.grey),
                  AppUserAvatar(
                    radius: avatarRadius,
                    imageUrl: replyTweet.authorProfileImage,
                    displayName: replyDisplayName,
                    username: replyUsername,
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      replyDisplayName,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@$replyUsername',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // "Replying to" text
        Text.rich(
          TextSpan(
            text: 'Replying to ',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            children: [
              TextSpan(
                text: '@$parentUsername',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.blueAccent,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.of(context).pushNamed(
                      '/profile',
                      arguments: {'username': parentUsername},
                    );
                  },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Reply body (without the original tweet card since we show it above)
        TweetDetailedBodyWidget(
          tweetState: replyTweetState,
          hideOriginalTweet: true,
        ),
        const SizedBox(height: 8),
        // Reply detailed feed (timestamp, stats, etc.)
        TweetDetailedFeed(tweetState: replyTweetState),
      ],
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) {
      final secs = diff.inSeconds <= 0 ? 1 : diff.inSeconds;
      return '${secs}s';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else {
      return '${diff.inDays}d';
    }
  }
}
