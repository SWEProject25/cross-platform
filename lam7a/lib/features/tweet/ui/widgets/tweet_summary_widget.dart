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
    final diff = DateTime.now().difference(tweet.date);
    final daysPosted = diff.inDays < 0 ? 0 : diff.inDays;
    final isPureRepost =
        tweet.isRepost && !tweet.isQuote && tweet.originalTweet != null;
    final isReply =
        !tweet.isRepost && !tweet.isQuote && tweet.originalTweet != null;
    final parentTweet = tweet.originalTweet;
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

    const double avatarRadius = 19.0;

    final avatarWidget = AppUserAvatar(
      radius: avatarRadius,
      imageUrl: tweetData.authorProfileImage,
      displayName: tweetData.authorName,
      username: tweetData.username,
    );

    void _openDetail() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TweetScreen(
            tweetId: tweetId,
            tweetData: tweet,
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
                  if (isPureRepost) ...[
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
                    const SizedBox(height: 2),
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
                                  fallbackTweet: tweet,
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
                                            tweetViewModelProvider(tweet.id)
                                                .notifier)
                                        .summarizeBody();
                                  },
                                ),
                              ],
                            ),
                            if (isPureRepost &&
                                (tweet.body.isEmpty ||
                                    tweet.body.trim().isEmpty))
                              const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: TweetBodySummaryWidget(post: tweet),
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
                  child: TweetFeed(tweetState: localTweetState),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

