import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet_summary/models/tweet.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_user_provider.dart';
class TweetUserInfo extends ConsumerStatefulWidget
{
   //need userProvider to check for changes for now i use static data
  TweetUserInfo({super.key, required this.tweet, required this.daysPosted});
  final TweetModel tweet;
  final int daysPosted;
  @override
  ConsumerState<TweetUserInfo> createState() {
    return _TweetUserInfo();
}
}

class _TweetUserInfo extends ConsumerState<TweetUserInfo>{
  @override
  Widget build(BuildContext context) {
//need userProvider to check for changes for now i use static data
   final userAsync = ref.watch(userByIdProvider(widget.tweet.userId));
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