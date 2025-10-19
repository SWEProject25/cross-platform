import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/view/widgets/tweet_body.dart';
import 'package:lam7a/features/tweet/ui/view/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/view/widgets/tweet_user_info.dart';
import 'package:lam7a/features/tweet/ui/view_model/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/models/tweet.dart';
import 'package:lam7a/features/tweet/models/user_profile.dart';

class TweetSummaryWidget extends ConsumerStatefulWidget {
  const TweetSummaryWidget({
    super.key,
    required this.tweetId,
    required this.user,
    required this.post,
    //required this.summerizeBody   ** waiting for it to finish to see if it will be passed or inpelmented in this class
  });
  final UserProf user;
  final int tweetId;
  final TweetModel post;
  //final void Function() summerizeBody;  ** waiting for it to finish to see if it will be passed or inpelmented in this class
  @override
  ConsumerState<TweetSummaryWidget> createState() {
    return _TweetState();
  }
}

class _TweetState extends ConsumerState<TweetSummaryWidget> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final tweet = ref.watch(tweetViewModelProvider(widget.post.id, initialTweet: widget.post),);
    //get how many days pased since date posted
    final daysPosted = DateTime.now().day - widget.post.date.day;
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
               TweetUserInfo(user: widget.user, daysPosted: daysPosted),
                IconButton(icon: Icon(Icons.rocket), onPressed:ref.read(tweetViewModelProvider(initialTweet:  widget.post,widget.post.id).notifier).summerizeBody),
              ],
            ),
            //tweet body
            TweetBodyWidget(post: tweet),
              // feed
              TweetFeed(post: tweet),
          ],
        ),
      ),
    );
  }
}
