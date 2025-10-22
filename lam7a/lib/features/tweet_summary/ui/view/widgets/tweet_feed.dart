import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet_summary/ui/view_model/tweet_viewmodel.dart';
import 'package:lam7a/features/models/tweet.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TweetFeed extends ConsumerStatefulWidget {
  TweetFeed({
    super.key,
    required this.post,
    required this.isLiked,
    required this.isReposted,
  });
  final TweetModel post;
  bool isLiked;
  bool isReposted;
  @override
  ConsumerState<TweetFeed> createState() {
    return _TweetFeedState();
  }
}

class _TweetFeedState extends ConsumerState<TweetFeed>
    with TickerProviderStateMixin {
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
 ref.read(tweetViewModelProvider(widget.post.id).notifier)
        .handleRepost(
          controllerRepost: _controllerRepost,
        );
    if (ref.read(tweetViewModelProvider(widget.post.id).notifier)
        .getisReposted()) {
      showTopSnackBar(
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
    void _showRepostQuoteOptions(BuildContext context) {
    if(!ref.read(tweetViewModelProvider(widget.post.id).notifier).getisReposted())
    {showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.black,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.repeat, color: Colors.blue),
                  title: const Text("Repost",style: TextStyle(color: Colors.white)),
                  onTap: () {
                    _handlerepost();
                     Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.format_quote, color: Colors.green),
                  title: const Text("Quote",style: TextStyle(color: Colors.white)),
                  onTap: () {
                    //
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    }
    else 
    {
      _handlerepost();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final tweet = ref.watch(tweetViewModelProvider(widget.post.id));
    String commentsNumStr = '';
    String veiwsNumStr = '';
    String likesNumStr = '';
    String repostsNumStr = '';
    tweet.whenData((tweet) {
      final viewModel = ref.read(
        tweetViewModelProvider(widget.post.id).notifier,
      );

      final commNum = tweet.comments.toDouble();
      final likesNum = tweet.likes.toDouble();
      final repostNum = tweet.repost.toDouble();
      final viewsNum = tweet.views.toDouble();

      commentsNumStr = viewModel.howLong(commNum);
      likesNumStr = viewModel.howLong(likesNum);
      repostsNumStr = viewModel.howLong(repostNum);
      veiwsNumStr = viewModel.howLong(viewsNum);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 40),
        ////Comment
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 3.0),
          child: GestureDetector(
            onTap: ref
                .read(tweetViewModelProvider(widget.post.id).notifier)
                .handleComment,
            child: Icon(Icons.comment, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 3.0),
          child: Text(commentsNumStr, style: TextStyle(color: Colors.grey)),
        ),
        SizedBox(width: 30),  

        ///repost
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 3.0),
          child: ScaleTransition(
            scale: _scaleAnimationRepost,
            child: GestureDetector(
              onTap: () {
                _showRepostQuoteOptions(context);
                },
              child: ref
                    .read(tweetViewModelProvider(widget.post.id).notifier)
                    .getisReposted()
                  ? Icon(Icons.loop, color: Colors.green)
                  : Icon(Icons.loop, color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 3.0),
          child: Text(repostsNumStr, style: TextStyle(color: Colors.grey)),
        ),
        SizedBox(width: 30),
        ///// Like
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 3.0),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: () {ref
                    .read(tweetViewModelProvider(widget.post.id).notifier)
                    .handleLike(
                      controller: _controller,
                    );
              },
              child: ref
                    .read(tweetViewModelProvider(widget.post.id).notifier)
                    .getIsLiked(
                    )
                  ? Icon(Icons.favorite, color: Colors.red)
                  : Icon(Icons.favorite_border, color: Colors.grey),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 3.0),
          child: Text(
            likesNumStr,
            style: TextStyle(color: widget.isLiked ? Colors.red : Colors.grey),
          ),
        ),
        SizedBox(width: 30),

        ///views
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 3.0),
          child: GestureDetector(
            onTap: ref
                .read(tweetViewModelProvider(widget.post.id).notifier)
                .handleViews,
            child: Icon(Icons.bar_chart, color: Colors.grey),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 1.0, top: 3.0),
          child: Text(veiwsNumStr, style: TextStyle(color: Colors.grey)),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
