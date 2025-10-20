import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet_detailed/ui/view/widgets/user_info_detailed.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_tweet_provider.dart';

class TweetDetailedWidget extends ConsumerStatefulWidget
{
  final String tweetId;
  const TweetDetailedWidget({super.key,required this.tweetId});
  @override
  ConsumerState<TweetDetailedWidget> createState()
  {
    return _TweetDetailedWidgetState();
  }
}
class _TweetDetailedWidgetState extends ConsumerState<TweetDetailedWidget>
{

  @override
Widget build(BuildContext context)
{
   final tweetAsync = ref.watch(tweetByIdProvider(widget.tweetId));
 return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        color:  Colors.black,//Theme.of(context).colorScheme.onSurface,
        padding: EdgeInsets.only(left:10),
        //main column
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tweetAsync.when( 
                  data : (tweet) => TweetUserInfoDetailed(tweet:tweet , daysPosted: DateTime.now().day - tweet.date.day),
                  loading : ()=>  const CircularProgressIndicator(),
                  error: (e ,st)=> Text('Error $e')
            )
            
          ]
        )
      )
 );
}
}