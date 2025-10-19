import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/view_model/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/models/tweet.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
class TweetFeed extends ConsumerStatefulWidget
{
  TweetFeed({super.key,required this.post});
  final TweetModel post;
    @override
  ConsumerState<TweetFeed> createState() {
    return _TweetFeedState();
  }
}
class _TweetFeedState extends ConsumerState<TweetFeed>  with TickerProviderStateMixin
{
    var isLiked = false;
  var isReposted = false;
  // for the like animation
  late AnimationController _controller;
  late AnimationController _controllerRepost;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scaleAnimationRepost;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _controllerRepost = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnimationRepost = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controllerRepost, curve: Curves.easeOut),
    );
  }
  void _handlerepost() {
    isReposted=ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).handlerepost(controllerRepost: _controllerRepost,isReposted: isReposted);
       if(isReposted)
       {showTopSnackBar(
        Overlay.of(context),
        Card(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  "Reposted Successfully",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
       }
  }
    @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
   
  Widget build(BuildContext context) {
    final tweet = ref.watch(tweetViewModelProvider(widget.post.id, initialTweet: widget.post),);
    String commentsNumStr = '';
    String veiwsNumStr = '';
    String likesNumStr = '';
    String repostsNumStr = '';
    double commNum = (tweet.comments).toDouble();
    double likesNum = tweet.likes.toDouble();  //
    double repostNum = tweet.repost.toDouble();
    double viewsNum = tweet.views.toDouble();
    commentsNumStr = ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).howLong(commNum);
    likesNumStr =ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).howLong(likesNum);
    repostsNumStr =ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).howLong(repostNum);
    veiwsNumStr = ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).howLong(viewsNum);
   return
       Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                ////Comment
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: GestureDetector(
                    onTap: ref.read(tweetViewModelProvider(initialTweet:  widget.post,widget.post.id).notifier).handleComment,
                    child: Icon(Icons.comment, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                  child: Text(
                    commentsNumStr,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(width: 10),

                ///repost
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: ScaleTransition(
                    scale: _scaleAnimationRepost,
                    child: GestureDetector(
                      onTap: _handlerepost,
                      child: isReposted
                          ? Icon(Icons.loop, color: Colors.green)
                          : Icon(Icons.loop, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                  child: Text(
                    repostsNumStr,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(width: 10),
                ///// Like
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: GestureDetector(
                      onTap:() { isLiked = ref.read(tweetViewModelProvider(initialTweet:  widget.post,widget.post.id).notifier).handleLike(controller: _controller, isLiked: isLiked);},
                      child: isLiked
                          ? Icon(Icons.favorite, color: Colors.red)
                          : Icon(Icons.favorite_border, color: Colors.grey),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                  child: Text(
                    likesNumStr,
                    style: TextStyle(color: isLiked ? Colors.red : Colors.grey),
                  ),
                ),
                SizedBox(width: 10),

                ///views
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: GestureDetector(
                    onTap: ref.read(tweetViewModelProvider(initialTweet: widget.post,widget.post.id).notifier).handleViews,
                    child: Icon(Icons.bar_chart, color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0, top: 3.0),
                  child: Text(
                    veiwsNumStr,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(width: 15),
              ],
            );
   
  }
}