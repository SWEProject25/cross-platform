import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/widgets/video_player_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/styled_tweet_text_widget.dart';
import 'package:lam7a/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class TweetDetailedBodyWidget extends StatelessWidget {
  final TweetState tweetState;
  
  const TweetDetailedBodyWidget({super.key, required this.tweetState});
  
  @override
  Widget build(BuildContext context) {
    final post = tweetState.tweet.value!;
    final responsive = context.responsive;
    final fontSize = responsive.fontSize(17);
    final imageHeight = responsive.isTablet 
        ? 500.0 
        : responsive.isLandscape 
            ? responsive.heightPercent(60) 
            : 400.0;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding(16),
                    ),
                    child: StyledTweetText(
                      text: post.body,
                      fontSize: fontSize.clamp(15, 20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.padding(10)),
            if (post.mediaPic != null)
                 Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(responsive.padding(8)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post.mediaPic.toString(),
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,

                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            ),
                          ),
                          if (post.mediaVideo != null)
                            Padding(
                              padding: EdgeInsets.all(responsive.padding(8)),
                              child: VideoPlayerWidget(
                                url: post.mediaVideo.toString(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                 )
          ],
        );
      },
    );
  }
}