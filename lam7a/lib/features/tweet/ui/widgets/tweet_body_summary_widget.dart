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
              if (post.mediaPic != null)
                   Row(
                    children: [
                      SizedBox(width: responsive.padding(40)),
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
                            if (post.mediaVideo != null && post.mediaPic ==null)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
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
          ),
        );
      },
    );
  }
}