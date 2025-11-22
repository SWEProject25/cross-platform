import 'package:flutter/material.dart';

import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';

class TweetBodySummaryWidget extends StatelessWidget {
  final TweetModel post;

  const TweetBodySummaryWidget({super.key, required this.post});

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
                    child: Text(
                      bodyText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Display multiple images in summary (side by side, with skeleton while loading)
            if (post.mediaImages.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: responsive.padding(4),
                ),
                child: SizedBox(
                  height: imageHeight,
                  child: Row(
                    children: post.mediaImages.take(2).map((imageUrl) {
                      // Show max 2 in summary
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.padding(2),
                          ),
                          child: GestureDetector(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Colors.grey.shade800,
                                  ),
                                  Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
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
                    }).toList(),
                  ),
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
                  ),
                ],
              ),

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
                        child:
                            VideoPlayerWidget(url: post.mediaVideo.toString()),
                      ),
                    ),
                  ),
                ],
              ),

            if (post.originalTweet != null)
              OriginalTweetCard(tweet: post.originalTweet!),
          ],
        );
      },
    );
  }
}

class OriginalTweetCard extends StatelessWidget {
  final TweetModel tweet;

  const OriginalTweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final imageHeight = responsive.getTweetImageHeight();
    final username = tweet.username ?? 'unknown';
    final displayName = (tweet.authorName != null &&
            tweet.authorName!.isNotEmpty)
        ? tweet.authorName!
        : username;
    final profileImage = tweet.authorProfileImage;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TweetScreen(
              tweetId: tweet.id,
              tweetData: tweet,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          top: responsive.padding(4),
        ),
        padding: EdgeInsets.all(responsive.padding(8)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade800),
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppUserAvatar(
                  radius: 16,
                  imageUrl: profileImage,
                  displayName: displayName,
                  username: username,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '@$username',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (tweet.body.trim().isNotEmpty)
              StyledTweetText(
                text: tweet.body,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
              ),
            if (tweet.mediaImages.isNotEmpty) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  tweet.mediaImages.first,
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, child, loadingProgress) {
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
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            if (tweet.mediaImages.isEmpty &&
                tweet.mediaVideos.isNotEmpty) ...[
              const SizedBox(height: 6),
              VideoPlayerWidget(url: tweet.mediaVideos.first),
            ],
          ],
        ),
      ),
    );
  }
}

