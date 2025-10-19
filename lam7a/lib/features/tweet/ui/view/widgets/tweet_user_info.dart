import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/models/user_profile.dart';
class TweetUserInfo extends ConsumerStatefulWidget
{
   //need userProvider to check for changes for now i use static data
  TweetUserInfo({super.key, required this.user, required this.daysPosted});
  final UserProf user;
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
final user= widget.user;
var daysPosted=widget.daysPosted;
    return  Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundImage: NetworkImage(user.profilePic),
                  backgroundColor:
                      Colors.grey[200], // optional placeholder color
                ),
                SizedBox(width: 10, height: 5),
                Text(
                  user.username,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(width: 10),
                Text(
                  user.hashUserName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(width: 10),
                Text('${daysPosted.toString()}d'),
                SizedBox(width: 10),
               
              ],
            );
  }
}