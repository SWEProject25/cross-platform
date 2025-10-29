import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/services/mock_user_api_service.dart';
class TweetUserSummaryInfo extends ConsumerStatefulWidget
{
   //need userProvider to check for changes for now i use static data
  const TweetUserSummaryInfo({super.key, required this.tweetState, required this.daysPosted});
  final TweetState tweetState;
  final int daysPosted;
  @override
  ConsumerState<TweetUserSummaryInfo> createState() {
    return _TweetUserSummaryInfoState();
}
}

class _TweetUserSummaryInfoState extends ConsumerState<TweetUserSummaryInfo>{
  @override
  Widget build(BuildContext context) {
//need userProvider to check for changes for now i use static data
   final userAsync = ref.watch(userByIdProvider(widget.tweetState.tweet.value!.userId));
  var daysPosted=widget.daysPosted;
    return  Row(
              children: [
                userAsync.when(
                data :(user) =>CircleAvatar(
                  radius: 19,
                  backgroundImage: NetworkImage(user.profilePic.toString()),
                  backgroundColor:
                      Colors.grey[200], // optional placeholder color
                ),
                loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
                error: (err, _) => const Icon(Icons.error),
                ),
                SizedBox(width: 10, height: 5),
                userAsync.when(
                  data:(user)=> Text(
                  user.username,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                  loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
                   error: (err, _) => const Icon(Icons.error),
                ),
                SizedBox(width: 10),
                 userAsync.when(
                  data:(user)=>Text(
                  user.hashUserName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                 loading: () => const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
                   error: (err, _) => const Icon(Icons.error),
                 ),
                SizedBox(width: 10),
                Text('${daysPosted.toString()}d'),
                SizedBox(width: 10),
               
              ],
            );
  }
}