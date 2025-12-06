import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/widgets/full_screen_media_viewer.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

class TweetDetailedBodyWidget extends StatelessWidget {
  final TweetState tweetState;
  
  const TweetDetailedBodyWidget({super.key, required this.tweetState});
  
  @override
  Widget build(BuildContext context) {
    // Handle null tweet (e.g., 404 error)
    if (tweetState.tweet.value == null) {
      return  Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Tweet not found or has been deleted',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }
    
    final post = tweetState.tweet.value!;
    final responsive = context.responsive;

    final imageHeight = responsive.isTablet 
        ? 500.0 
        : responsive.isLandscape 
            ? responsive.heightPercent(60) 
            : 400.0;
    final bodyText = post.body.trim();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bodyText.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.padding(0),
                ),
                child: StyledTweetText(
                  text: bodyText,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onMentionTap: (handle) {
                    Navigator.of(context).pushNamed(
                      '/profile',
                      arguments: {'username': handle},
                    );
                  },
                  onHashtagTap: (tag) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NavigationHomeScreen(
                          initialIndex: 1,
                          initialSearchQuery: '#$tag',
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: responsive.padding(12)),
            ],

            // Display multiple images
            if (post.mediaImages.isNotEmpty)
              Column(
                children: post.mediaImages.map((imageUrl) {
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
                    ),
                  );
                }).toList(),
              ),
            // Display multiple videos
            if (post.mediaVideos.isNotEmpty)
              Column(
                children: post.mediaVideos.map((videoUrl) {
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
                      child: VideoPlayerWidget(
                        url: videoUrl,
                      ),
                    ),
                  );
                }).toList(),
              ),
            // Backward compatibility: show old single media fields if new lists are empty
            if (post.mediaImages.isEmpty && post.mediaPic != null)
              Padding(
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
            if (post.mediaVideos.isEmpty && post.mediaVideo != null)
              Padding(
                padding: EdgeInsets.all(responsive.padding(8)),
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
            if (post.originalTweet != null)
              OriginalTweetCard(tweet: post.originalTweet!),
          ],
        );
      },
    );
  }
}