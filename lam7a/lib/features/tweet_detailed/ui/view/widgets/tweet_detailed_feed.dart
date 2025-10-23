import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/features/tweet_summary/state/tweet_state.dart';
import 'package:lam7a/features/tweet_summary/ui/view_model/tweet_viewmodel.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';

class TweetFeedDetailed extends ConsumerStatefulWidget {
  const TweetFeedDetailed({super.key, required this.tweetState});
  final TweetState tweetState;
  @override
  ConsumerState<TweetFeedDetailed> createState() {
    return _TweetFeedState();
  }
}

class _TweetFeedState extends ConsumerState<TweetFeedDetailed>
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
 ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier)
        .handleRepost(
          controllerRepost: _controllerRepost,
        );
    if (ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier).getisReposted()) {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final postId =widget.tweetState.tweet.value!.id;
    final tweetState = ref.watch(tweetViewModelProvider(postId));
    final tweet =tweetState.whenData((tweetState) => tweetState.tweet);
    String veiwsNumStr = '';
    String likesNumStr = '';
    String repostsNumStr = '';
    String qoutesNumStr='';
    String bookmarksNumStr='';
    tweet.whenData((tweet) {
      final viewModel = ref.read(
        tweetViewModelProvider(postId).notifier,
      );
    final tweetVal=tweet.value!;
      final likesNum = tweetVal.likes.toDouble();
      final repostNum = tweetVal.repost.toDouble();
      final viewsNum = tweetVal.views.toDouble();
      final qoutesNum= tweetVal.qoutes.toDouble();
      final bookmarksNum=tweetVal.bookmarks.toDouble();
      likesNumStr = viewModel.howLong(likesNum);
      repostsNumStr = viewModel.howLong(repostNum);
      veiwsNumStr = viewModel.howLong(viewsNum);
      qoutesNumStr=viewModel.howLong(qoutesNum);
      bookmarksNumStr=viewModel.howLong(bookmarksNum);
    });
    String formatDate(DateTime date) {
      final formatter = DateFormat('hh:mm a');
      return formatter.format(date);
    }

    void showRepostQuoteOptions(BuildContext context) {
    if(!ref.read(tweetViewModelProvider(widget.tweetState.tweet.value!.id).notifier).getisReposted())
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

    return Column(
      children: [
        SizedBox(height: 10),
        // date
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  formatDate(tweet.value!.date),
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                  ),
                ),
              ),
              loading: () => CircularProgressIndicator(),
              error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  DateFormat('d MMM yy').format(tweet.value!.date),
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.grey,
                  ),
                ),
              ),
              loading: () => CircularProgressIndicator(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              '·',
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  veiwsNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Views",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 0.4, // line thickness
          color: Color.fromARGB(255, 139, 139, 139), // line color
          height: 20, // space above + below line
          indent: 18, // left padding
          endIndent: 18, // right padding
        ),
        Row(
          children: [
            //reposts
            tweet.when(
              data: (tweet) =>  Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  repostsNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Reposts",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10,),
                tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  qoutesNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Quotes",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
            SizedBox(width: 10,),
                tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  likesNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Likes",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),

          ],
        ),
                   Divider(
          thickness: 0.4, // line thickness
          color: Color.fromARGB(255, 139, 139, 139), // line color
          height: 20, // space above + below line
          indent: 18, // left padding
          endIndent: 18, // right padding
        ),
             Row( children: [  tweet.when(
              data: (tweet) => Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  bookmarksNumStr,
                  style: TextStyle(
                    fontSize: 15,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                  ),
                ),
              ),
              loading: () => CircleAvatar(),
               error: (e ,st)=> Text('Error $e'),
            ),
            Text(
              " Bookmarks",
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                color: Colors.grey,
              ),
            ),
      ]),
           Divider(
          thickness: 0.4, // line thickness
          color: Color.fromARGB(255, 139, 139, 139), // line color
          height: 20, // space above + below line
          indent: 18, // left padding
          endIndent: 18, // right padding
        ),
        ////Comment
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 15),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: GestureDetector(
                onTap: ref
                    .read(tweetViewModelProvider(postId).notifier)
                    .handleComment,
                child: Icon(Icons.comment, color: Colors.grey),
              ),
            ),

            SizedBox(width: 50),

            ///repost
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: ScaleTransition(
                scale: _scaleAnimationRepost,
                child: GestureDetector(
                  onTap:  () {
                showRepostQuoteOptions(context);
                },
                  child:
                      widget.tweetState.isReposted
                      ? Icon(Icons.loop, color: Colors.green)
                      : Icon(Icons.loop, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(width: 50),
            ///// Like
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(tweetViewModelProvider(postId).notifier)
                        .handleLike(controller: _controller);
                  },
                  child:
                      
                          widget.tweetState.isLiked
                      ? Icon(Icons.favorite, color: Colors.red)
                      : Icon(Icons.favorite_border, color: Colors.grey),
                ),
              ),
            ),

            SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: GestureDetector(
                onTap: ref
                    .read(tweetViewModelProvider(postId).notifier)
                    .handleBookmark,
                child: Icon(Icons.bookmark_border, color: Colors.grey),
              ),
            ),

            ///views
            SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 3.0),
              child: GestureDetector(
                onTap: ref
                    .read(tweetViewModelProvider(postId).notifier)
                    .handleShare,
                child: Icon(Icons.share_outlined, color: Colors.grey),
              ),
            ),

            SizedBox(width: 15),
          ],
        ),
 
      ],
    );
  }
}
