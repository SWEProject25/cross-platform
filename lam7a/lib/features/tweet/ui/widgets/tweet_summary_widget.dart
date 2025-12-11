import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_summary.dart';

class TweetSummaryWidget extends ConsumerWidget {
  const TweetSummaryWidget({
    super.key,
    required this.tweetId,
    required this.tweetData,
    this.backGroundColor,
  });

  final String tweetId;
  final TweetModel tweetData;
  final Color? backGroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _buildTweetUI(context, ref, tweetData);
  }

  Widget _buildTweetUI(BuildContext context, WidgetRef ref, TweetModel tweet) {
    final isPureRepost =
        tweet.isRepost && !tweet.isQuote && tweet.originalTweet != null;
    final isReply =
        !tweet.isRepost && !tweet.isQuote && tweet.originalTweet != null;
    final parentTweet = tweet.originalTweet;
    // For pure reposts, treat the parent tweet as the main content tweet
    final mainTweet = (isPureRepost && parentTweet != null) ? parentTweet! : tweet;

    final diff = DateTime.now().difference(mainTweet.date);
    final daysPosted = diff.inDays < 0 ? 0 : diff.inDays;
    final replyingToUsername = parentTweet?.username;
    final username = tweet.username ?? 'unknown';
    final displayName =
        (tweet.authorName != null && tweet.authorName!.isNotEmpty)
            ? tweet.authorName!
            : username;

    // Local TweetState from pre-fetched tweet data so we don't refetch
    final localTweetState = TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.data(tweet),
    );

    // For pure reposts, interactions (TweetFeed) should target the parent tweet
    final TweetState feedTweetState =
        (isPureRepost && parentTweet != null)
            ? TweetState(
                isLiked: false,
                isReposted: false,
                isViewed: false,
                tweet: AsyncValue.data(parentTweet!),
              )
            : localTweetState;

    const double avatarRadius = 19.0;

    final avatarWidget = AppUserAvatar(
      radius: avatarRadius,
      imageUrl: mainTweet.authorProfileImage,
      displayName: mainTweet.authorName,
      username: mainTweet.username,
    );

    void _openDetail() {
      final targetTweet = (isPureRepost && parentTweet != null)
          ? parentTweet!
          : tweet;
      final targetId = (isPureRepost && parentTweet != null)
          ? parentTweet!.id
          : tweetId;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TweetScreen(
            tweetId: targetId,
            tweetData: targetTweet,
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        key: Key(tweetId),
        color: backGroundColor ?? Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isReply && parentTweet != null) ...[
              OriginalTweetCard(
                tweet: parentTweet,
                showConnectorLine: true,
              ),
              const SizedBox(height: 8),
            ],
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _openDetail,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isReply &&
                      replyingToUsername != null &&
                      replyingToUsername.isNotEmpty) ...[
                    Text(
                      'Replying to @${replyingToUsername}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (isPureRepost && parentTweet != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.repeat,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$displayName reposted',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatarWidget,
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TweetUserSummaryInfo(
                                  tweetState: localTweetState,
                                  daysPosted: daysPosted,
                                  fallbackTweet: mainTweet,
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.rocket,
                                    size: 17,
                                    color: Colors.blueAccent,
                                  ),
                                  onTap: () {
                                    ref
                                        .read(
                                            tweetViewModelProvider(mainTweet.id)
                                                .notifier)
                                        .summarizeBody();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TweetBodySummaryWidget(post: mainTweet),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: avatarRadius * 2 + 9),
                Expanded(
                  child: TweetFeed(tweetState: feedTweetState),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

