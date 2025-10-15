import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lam7a/models/tweet.dart';
import 'package:lam7a/models/user_profile.dart';
import 'package:lam7a/widgets/vedio_player.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class Tweet extends StatefulWidget {
  const Tweet({
    super.key,
    required this.tweetId,
    required this.user,
    required this.post,
    //required this.summerizeBody     ** waiting for it to finish to see if it will be passed or inpelmented in this class
  });
  final UserProf user;
  final int tweetId;
  final Post post;
  //final void Function() summerizeBody;  ** waiting for it to finish to see if it will be passed or inpelmented in this class
  @override
  State<Tweet> createState() {
    return _TweetState();
  }
}

class _TweetState extends State<Tweet> with TickerProviderStateMixin {
  //TO DO
  void _summerizeBody() {}

  ///
  var isLiked = false;
  var isReposted = false;
  // for the like animation
  late AnimationController _controller;
  late AnimationController _controllerRepost;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scaleAnimationRepost;
  void _handleLike() {
    if (isLiked) {
      setState(() {
        isLiked = !isLiked;
        widget.post.likes -= 1;
      });
    } else {
      _controller.forward().then((_) => _controller.reverse());
      setState(() {
        isLiked = !isLiked;
        widget.post.likes += 1;
      });
    }
  }

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

  /// Returns the shortened number and its suffix.
  String howLong(double m) {
    String s = '';

    if (m >= 1_000_000_000) {
      s = 'B';
      m /= 1_000_000_000;
    } else if (m >= 1_000_000) {
      s = 'M';
      m /= 1_000_000;
    } else if (m >= 1_000) {
      s = 'K';
      m /= 1_000;
    }

    String formatted;
    if (s.isEmpty) {
      // <1000, show as integer
      formatted = m.toInt().toString();
    } else {
      // For K, M, B — show up to 2 decimals, remove .0 automatically
      formatted = (m % 1 == 0) ? m.toInt().toString() : m.toStringAsFixed(2);
    }

    return '$formatted$s';
  }

  //To Do
  void _handleComment() {}

  ///To DO
  void _handlerepost() {
    if (isReposted) {
      isReposted = !isReposted;
      setState(() {
        widget.post.repost -= 1;
      });
    } else {
      _controllerRepost.forward().then((_) => _controllerRepost.reverse());
      isReposted = !isReposted;
      setState(() {
        widget.post.repost += 1;
      });
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

  void _handleViews() {}
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //get how many days pased since date posted
    final daysPosted = DateTime.now().day - widget.post.date.day;
    //is number in k ,m, b
    String commentsNumStr = '';
    String veiwsNumStr = '';
    String likesNumStr = '';
    String repostsNumStr = '';
    double commNum = (widget.post.comments).toDouble();
    double likesNum = widget.post.likes.toDouble();
    double repostNum = widget.post.repost.toDouble();
    double viewsNum = widget.post.views.toDouble();
    commentsNumStr = howLong(commNum);
    likesNumStr = howLong(likesNum);
    repostsNumStr = howLong(repostNum);
    veiwsNumStr = howLong(viewsNum);

    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        key: Key(widget.tweetId.toString()),
        color:  Colors.black,//Theme.of(context).colorScheme.onSurface,
        padding: EdgeInsets.only(left:10),
        //main column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //usr row
            Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundImage: NetworkImage(widget.user.profilePic),
                  backgroundColor:
                      Colors.grey[200], // optional placeholder color
                ),
                SizedBox(width: 10, height: 5),
                Text(
                  widget.user.username,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(width: 10),
                Text(
                  widget.user.hashUserName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(width: 10),
                Text('${daysPosted.toString()}d'),
                SizedBox(width: 10),
                IconButton(icon: Icon(Icons.rocket), onPressed: _summerizeBody),
              ],
            ),
            SizedBox(height: 20),
            //tweet body
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 50),
                Flexible(
                  child: Text(
                    widget.post.body,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (widget.post.mediaPic != null)
              
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
                                widget.post.mediaPic.toString(),
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
                          if (widget.post.mediaVideo != null)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: VideoPlayerWidget(
                                url: widget.post.mediaVideo.toString(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              // feed
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 40),
                ////Comment
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 3.0),
                  child: GestureDetector(
                    onTap: _handleComment,
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
                      onTap: _handleLike,
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
                    onTap: _handleViews,
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
            ),
          ],
        ),
      ),
    );
  }
}
