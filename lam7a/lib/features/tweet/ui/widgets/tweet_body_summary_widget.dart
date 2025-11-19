import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class TweetBodySummaryWidget extends StatelessWidget {
  final TweetModel post;
  
  const TweetBodySummaryWidget({super.key, required this.post});
  
  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final leftPadding = responsive.padding(50);
    final fontSize = responsive.fontSize(15);
    final imageHeight = responsive.getTweetImageHeight();
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
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
              SizedBox(height: 10),
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
                        child: VideoPlayerWidget(url: videoUrl),
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
                  ],
                ),
              if (post.mediaVideos.isEmpty && post.mediaVideo != null && post.mediaPic == null)
                Row(
                  children: [
                    SizedBox(width: responsive.padding(40)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: VideoPlayerWidget(url: post.mediaVideo.toString()),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}