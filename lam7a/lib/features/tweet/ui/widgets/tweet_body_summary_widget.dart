import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class TweetBodySummaryWidget extends StatelessWidget {
  final TweetModel post;
  
  const TweetBodySummaryWidget({super.key, required this.post});
  
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final leftPadding = responsive.padding(48);
    final fontSize = responsive.fontSize(15);
    final imageHeight = responsive.getTweetImageHeight();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.body.trim().isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: leftPadding),
                  Flexible(
                    child: StyledTweetText(
                      text: post.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      fontSize: fontSize.clamp(14, 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            // Display multiple images in summary
            if (post.mediaImages.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: responsive.padding(40)),
                child: Column(
                  children: post.mediaImages.take(2).map((imageUrl) { // Show max 2 in summary
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
                                url: imageUrl,
                                isVideo: false,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                height: imageHeight,
                                child: const Center(child: CircularProgressIndicator()),
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            // Display multiple videos in summary
            if (post.mediaVideos.isNotEmpty && post.mediaImages.isEmpty)
              Padding(
                padding: EdgeInsets.only(left: responsive.padding(40)),
                child: Column(
                  children: post.mediaVideos.take(1).map((videoUrl) { // Show max 1 video in summary
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
                          child: Image.network(
                            post.mediaPic.toString(),
                            width: double.infinity,
                            height: imageHeight,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (post.mediaVideos.isEmpty && post.mediaVideo != null && post.mediaPic == null)
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
                        child: VideoPlayerWidget(url: post.mediaVideo.toString()),
                      ),
                    ),
                  ),
                ],
              ),
            if (post.originalTweet != null)
              _OriginalTweetCard(tweet: post.originalTweet!),
          ],
        );
      },
    );
  }
}

class _OriginalTweetCard extends StatelessWidget {
  final TweetModel tweet;

  const _OriginalTweetCard({super.key, required this.tweet});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final imageHeight = responsive.getTweetImageHeight();
    final username = tweet.username ?? 'unknown';
    final displayName = (tweet.authorName != null && tweet.authorName!.isNotEmpty)
        ? tweet.authorName!
        : username;
    final profileImage = tweet.authorProfileImage;

    return Container(
      margin: EdgeInsets.only(
        left: responsive.padding(40),
        right: responsive.padding(16),
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
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[700],
                backgroundImage: profileImage != null && profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : null,
                child: profileImage == null || profileImage.isEmpty
                    ? Text(
                        username.isNotEmpty ? username[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
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
                        color: Theme.of(context).colorScheme.onPrimary,
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: imageHeight,
                    child: const Center(child: CircularProgressIndicator()),
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
          if (tweet.mediaImages.isEmpty && tweet.mediaVideos.isNotEmpty) ...[
            const SizedBox(height: 6),
            VideoPlayerWidget(url: tweet.mediaVideos.first),
          ],
        ],
      ),
    );
  }
}