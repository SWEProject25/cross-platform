import 'package:lam7a/features/tweet_summary/State/tweet_state.dart';
import 'package:lam7a/features/tweet_summary/ui/view/widgets/vedio_player.dart';
import 'package:flutter/material.dart';
class TweetBodyDetailedWidget extends StatelessWidget{

  final TweetState tweetState;
 const TweetBodyDetailedWidget({super.key,required this.tweetState});
  @override
  Widget build(BuildContext context) {
    final post= tweetState.tweet;
  return Column(children: [ Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                
                Flexible(
                  child: Text(
                    post.body,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                       decoration: TextDecoration.none,
                       fontSize: 17,
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
                                height: 400,
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
  );
  }
}