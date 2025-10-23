import 'package:lam7a/features/tweet_summary/ui/view/widgets/vedio_player.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/models/tweet.dart';
class TweetBodySummaryWidget extends StatelessWidget{

final TweetModel post;
 const TweetBodySummaryWidget({super.key,required this.post});
  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(children: [ Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 50),
                  Flexible(
                    child: Text(
                        maxLines: 3, // or 4
                      overflow: TextOverflow.ellipsis,
                      post.body,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (post.mediaPic != null)
                   Row(
                    children: [
                      SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  post.mediaPic.toString(),
                                  width: double.infinity,
                                  height: 200,
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
    ]
    ),
  );
  }
}