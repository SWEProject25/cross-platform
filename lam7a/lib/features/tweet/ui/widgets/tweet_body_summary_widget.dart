import 'package:flutter/material.dart';

import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';
import 'package:lam7a/features/Explore/ui/view/search_result_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/Explore/ui/viewmodel/search_results_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/state/deleted_tweets_provider.dart';

class TweetBodySummaryWidget extends StatelessWidget {
  final TweetModel post;
  // When true, taps on the embedded OriginalTweetCard are disabled so that
  // an outer GestureDetector (e.g. in TweetSummaryWidget) can handle them.
  final bool disableOriginalTap;

  const TweetBodySummaryWidget({
    super.key,
    required this.post,
    this.disableOriginalTap = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final leftPadding = responsive.padding(0);
    final imageHeight = responsive.getTweetImageHeight();
    final bodyText = post.body.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bodyText.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: leftPadding),
                  Flexible(
                    child: StyledTweetText(
                      text: bodyText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                      // coverage:ignore-start

                      onMentionTap: (handle) {
                        Navigator.of(context).pushNamed(
                          '/profile',
                          arguments: {'username': handle},
                        );
                      },
                      onHashtagTap: (tag) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProviderScope(
                              overrides: [
                                searchResultsViewModelProvider.overrideWith(
                                  () => SearchResultsViewmodel(),
                                ),
                              ],
                              child: SearchResultPage(
                                hintText: "#$tag",
                                canPopTwice: false,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
// coverage:ignore-end
            // Display up to 4 images in a 2x2 grid (with skeleton while loading)
            if (post.mediaImages.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: responsive.padding(4)),
                child: Builder(
                  builder: (context) {
                    final images = post.mediaImages.take(4).toList();
                    final hasTwoRows = images.length > 2;
                    final totalHeight = hasTwoRows
                        ? imageHeight * 2
                        : imageHeight;

                    Widget buildImageTile(String imageUrl) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.padding(2),
                          ),
                          child: GestureDetector(
                            // coverage:ignore-start
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FullScreenMediaViewer(
                                    url: imageUrl,
                                    isVideo: false,
                                  ),
                                ),
                              );
                            },
// coverage:ignore-end
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(color: Colors.grey.shade800),
                                  Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            color: Colors.grey.shade800,
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: totalHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: images
                                  .take(2)
                                  .map((url) => buildImageTile(url))
                                  .toList(),
                            ),
                          ),
                          if (hasTwoRows) ...[
                            SizedBox(height: responsive.padding(4)),
                            Expanded(
                              child: Row(
                                children: images
                                    .skip(2)
                                    .take(2)
                                    .map((url) => buildImageTile(url))
                                    .toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            // Display multiple videos in summary
            if (post.mediaVideos.isNotEmpty && post.mediaImages.isEmpty)
              Padding(
                padding: EdgeInsets.only(left: responsive.padding(40)),
                child: Column(
                  children: post.mediaVideos.take(1).map((videoUrl) {
                    // Show max 1 video in summary
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.padding(8),
                        vertical: responsive.padding(4),
                      ),
                      child: GestureDetector(
                        // coverage:ignore-start
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullScreenMediaViewer(
                                url: videoUrl,
                                isVideo: true,
                              ),
                            ),
                          );
                        },
// coverage:ignore-end
                        child: VideoPlayerWidget(url: videoUrl),
                      ),
                    );
                  }).toList(),
                ),
              ),
            // Backward compatibility: show old single media fields if new lists are empty
            if (post.mediaImages.isEmpty && post.mediaPic != null)
              Row(
                children: [
                  SizedBox(width: responsive.padding(40)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(responsive.padding(8)),
                      child: GestureDetector(
                        // coverage:ignore-start
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullScreenMediaViewer(
                                url: post.mediaPic.toString(),
                                isVideo: false,
                              ),
                            ),
                          );
                        },
// coverage:ignore-end
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                width: double.infinity,
                                height: imageHeight,
                                color: Colors.grey.shade800,
                              ),
                              Image.network(
                                post.mediaPic.toString(),
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                                // coverage:ignore-start

                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: double.infinity,
                                        height: imageHeight,
                                        color: Colors.grey.shade800,
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error, color: Colors.red),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
// coverage:ignore-end
            if (post.mediaVideos.isEmpty &&
                post.mediaVideo != null &&
                post.mediaPic == null)
              Row(
                children: [
                  SizedBox(width: responsive.padding(40)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        // coverage:ignore-start
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FullScreenMediaViewer(
                                url: post.mediaVideo.toString(),
                                isVideo: true,
                              ),
                            ),
                          );
                        },
// coverage:ignore-end
                        child: VideoPlayerWidget(
                          url: post.mediaVideo.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
// coverage:ignore-start

            if ((post.isRepost || post.isQuote) && post.originalTweet != null)
              disableOriginalTap
                  ? IgnorePointer(
                      child: OriginalTweetCard(
                        tweet: post.originalTweet!,
                        showActions: !post.isQuote,
                      ),
                    )
                  : OriginalTweetCard(
                      tweet: post.originalTweet!,
                      showActions: !post.isQuote,
                    ),
          ],
        );
      },
    );
  }
}


// coverage:ignore-end

class OriginalTweetCard extends ConsumerWidget {
  final TweetModel tweet;
  final bool showConnectorLine;
  final bool showActions;

  const OriginalTweetCard({
    super.key,
    required this.tweet,
    this.showConnectorLine = false,
    this.showActions = true,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedIds = ref.watch(deletedTweetsProvider);
    if (deletedIds.contains(tweet.id)) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'This tweet is not available',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey),
        ),
      );
    }

    final responsive = context.responsive;
    final imageHeight = responsive.getTweetImageHeight();
    final username = tweet.username ?? 'unknown';
    final displayName =
        (tweet.authorName != null && tweet.authorName!.isNotEmpty)
        ? tweet.authorName!
        : username;
    final profileImage = tweet.authorProfileImage;
    final theme = Theme.of(context);
    final timeAgo = _formatTimeAgo(tweet.date);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TweetScreen(tweetId: tweet.id, tweetData: tweet),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.padding(0),
          vertical: responsive.padding(8),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar column with optional connector line
              Column(
                children: [
                  AppUserAvatar(
                    radius: 19,
                    imageUrl: profileImage,
                    displayName: displayName,
                    username: username,
                  ),
                  if (showConnectorLine)
                    Expanded(
                      child: Container(width: 2, color: Colors.grey),
                    ),
                ],
              ),
              const SizedBox(width: 9),
              // Content + actions column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User info row: DisplayName @username · time
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '@$username',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' · $timeAgo',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Body text
                    if (tweet.body.trim().isNotEmpty)
                      StyledTweetText(
                        text: tweet.body.trim(),
                        fontSize: theme.textTheme.bodyLarge?.fontSize ?? 16,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        // coverage:ignore-start
                        onMentionTap: (handle) {
                          Navigator.of(context).pushNamed(
                            '/profile',
                            arguments: {'username': handle},
                          );
                        },
                        onHashtagTap: (tag) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProviderScope(
                                overrides: [
                                  searchResultsViewModelProvider.overrideWith(
                                    () => SearchResultsViewmodel(),
                                  ),
                                ],
                                child: SearchResultPage(
                                  hintText: "#$tag",
                                  canPopTwice: false,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    // coverage:ignore-end
                    // Media images
                    if (tweet.mediaImages.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          tweet.mediaImages.first,
                          width: double.infinity,
                          height: imageHeight,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return SizedBox(
                              height: imageHeight,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return SizedBox(
                              height: imageHeight,
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    // Media videos
                    if (tweet.mediaImages.isEmpty &&
                        tweet.mediaVideos.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      VideoPlayerWidget(url: tweet.mediaVideos.first),
                    ],

                    // If this tweet is itself a repost/quote with a parent,
                    // render the parent tweet nested below (without actions
                    // or connector line). This lets reposts of quotes show
                    // the quoted tweet's parent as well.
                    if (tweet.originalTweet != null) ...[
                      const SizedBox(height: 8),
                      OriginalTweetCard(
                        tweet: tweet.originalTweet!,
                        showConnectorLine: false,
                        showActions: false,
                      ),
                    ],

                    if (showActions) ...[
                      const SizedBox(height: 4),
                      TweetFeed(
                        tweetState: TweetState(
                          isLiked: false,
                          isReposted: false,
                          isViewed: false,
                          tweet: AsyncValue.data(tweet),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
