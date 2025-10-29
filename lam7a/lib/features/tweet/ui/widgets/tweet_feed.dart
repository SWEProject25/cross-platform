import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TweetFeed extends ConsumerStatefulWidget {
  const TweetFeed({
    super.key,
    required this.tweetState,

  });
  final TweetState tweetState;

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
    final tweetId = widget.tweetState.tweet.value?.id;
    if (tweetId == null) return;
    
    ref.read(tweetViewModelProvider(tweetId).notifier)
        .handleRepost(
          controllerRepost: _controllerRepost,
        );
    if (ref.read(tweetViewModelProvider(tweetId).notifier).getisReposted()) {
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
    final tweetId = widget.tweetState.tweet.value?.id;
    if (tweetId == null) return;
    
    if(!ref.read(tweetViewModelProvider(tweetId).notifier).getisReposted())
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
 @override
  Widget build(BuildContext context) {
    // Safe null check
    final tweet = widget.tweetState.tweet.value;
    if (tweet == null) {
      return const SizedBox.shrink(); // Return empty if no tweet data
    }
    
    final tweetId = tweet.id;
    final tweetState = ref.watch(tweetViewModelProvider(tweetId));
    String commentsNumStr = '0';
    String veiwsNumStr = '0';
    String likesNumStr = '0';
    String repostsNumStr = '0';
    
    tweetState.whenData((tweetState) {
      final stateTweet = tweetState.tweet.value;
      if (stateTweet != null) {
        final viewModel = ref.read(tweetViewModelProvider(tweetId).notifier);

        final commNum = (stateTweet.comments ?? 0).toDouble();
        final likesNum = (stateTweet.likes ?? 0).toDouble();
        final repostNum = (stateTweet.repost ?? 0).toDouble();
        final viewsNum = (stateTweet.views ?? 0).toDouble();

        commentsNumStr = viewModel.howLong(commNum);
        likesNumStr = viewModel.howLong(likesNum);
        repostsNumStr = viewModel.howLong(repostNum);
        veiwsNumStr = viewModel.howLong(viewsNum);
      }
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
                .read(tweetViewModelProvider(tweetId).notifier)
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
                    .read(tweetViewModelProvider(tweetId).notifier)
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
                    .read(tweetViewModelProvider(tweetId).notifier)
                    .handleLike(
                      controller: _controller,
                    );
              },
              child: ref
                    .read(tweetViewModelProvider(tweetId).notifier)
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
            style: TextStyle(color: ref.read(tweetViewModelProvider(tweetId).notifier).getIsLiked()
             ? Colors.red : Colors.grey),
          ),
        ),
        SizedBox(width: 30),

        ///views
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 3.0),
          child: GestureDetector(
            onTap: ref
                .read(tweetViewModelProvider(tweetId).notifier)
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
