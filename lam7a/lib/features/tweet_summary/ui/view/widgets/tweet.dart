import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_tweet_provider.dart';
import 'package:lam7a/features/tweet_summary/ui/view/widgets/tweet_body.dart';
import 'package:lam7a/features/tweet_detailed/ui/view/widgets/tweet_detailed_widget.dart';
import 'package:lam7a/features/tweet_summary/ui/view/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet_summary/ui/view/widgets/tweet_user_info_summary.dart';
import 'package:lam7a/features/tweet_summary/ui/view_model/tweet_viewmodel.dart';


class TweetSummaryWidget extends ConsumerStatefulWidget {
  const TweetSummaryWidget({
    super.key,
    required this.tweetId,
    //required this.summerizeBody   ** waiting for it to finish to see if it will be passed or inpelmented in this class
  });
  final String tweetId;
  //final void Function() summerizeBody;  ** waiting for it to finish to see if it will be passed or inpelmented in this class
  @override
  ConsumerState<TweetSummaryWidget> createState() {
    return _TweetState();
  }
}

class _TweetState extends ConsumerState<TweetSummaryWidget> with TickerProviderStateMixin {
  
  @override
  Widget build(BuildContext context) {

   final tweetAsync = ref.watch(tweetByIdProvider(widget.tweetId));

  bool isLiked = false;
  bool isReposted = false;
    //get how many days pased since date posted
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
                 tweetAsync.when( 
                  data : (tweet) =>
               TweetUserInfo(tweet: tweet, daysPosted: DateTime.now().day - tweet.date.day ),
                loading : ()=>  const CircularProgressIndicator(),
                  error: (e ,st)=> Text('Error $e')
                 ),
                 tweetAsync.when( 
                  data : (tweet) => IconButton(icon: Icon(Icons.rocket),
                   onPressed:ref.read(tweetViewModelProvider(tweet.id).notifier).summarizeBody),
                   loading : ()=>  const CircularProgressIndicator(),
                  error: (e ,st)=> Text('Error $e')
                 ),
              ],  
            ),
            //tweet body
            GestureDetector(
              onTap: () {
                  ref.read(tweetViewModelProvider(widget.tweetId).notifier).handleViews();
                  Navigator.push(context,MaterialPageRoute(
                  builder: (_)=>TweetDetailedWidget(tweetId: widget.tweetId,)));
              },
              child: Container(
                color: Colors.transparent,
                child: tweetAsync.when( 
                  data : (tweet) => TweetBodySummaryWidget(post: tweet),
                  loading : ()=>  const CircularProgressIndicator(),
                  error: (e ,st)=> Text('Error $e')
            ),
              )
            ),
              // feed
              tweetAsync.when( 
                  data : (tweet) => TweetFeed(post: tweet,isLiked: isLiked,isReposted:  isReposted,),
                   loading : ()=>  const CircularProgressIndicator(),
                  error: (e ,st)=> Text('Error $e')
              )
          ],
        ),
      ),
    );
  }
}
