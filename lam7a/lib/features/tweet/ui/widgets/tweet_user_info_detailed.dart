import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/services/mock_user_api_service.dart';

class TweetUserInfoDetailed extends ConsumerStatefulWidget {
  //need userProvider to check for changes for now i use static data
  const TweetUserInfoDetailed({
    super.key,
    required this.tweetState,
  });
  final TweetState tweetState;
  @override
  ConsumerState<TweetUserInfoDetailed> createState() {
    return _TweetUserInfoDetailed();
  }
}

class _TweetUserInfoDetailed extends ConsumerState<TweetUserInfoDetailed> {
  @override
  Widget build(BuildContext context) {
    final tweet= widget.tweetState.tweet;
    
    // Handle null tweet
    if (tweet.value == null) {
      return const SizedBox.shrink();
    }
    
    //need userProvider to check for changes for now i use static data
    final userAsync = ref.watch(userByIdProvider(tweet.value!.userId));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        userAsync.when(
          data: (user) => CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.profileImageUrl ?? 'https://i.pravatar.cc/150'),
            backgroundColor: Colors.grey[200], // optional placeholder color
          ),
          loading: () =>
              const CircleAvatar(radius: 30, backgroundColor: Colors.grey),
           error: (e ,st)=> Text('Error $e'),
        ),
        SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userAsync.when(
              data: (user) => Text(
                user.name ?? user.username ?? 'Unknown',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
              loading: () =>
                  const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
               error: (e ,st)=> Text('Error $e'),
            ),
            SizedBox(height: 2),
            userAsync.when(
              data: (user) => Text(
                '@${user.username ?? 'unknown'}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
              loading: () =>
                  const CircleAvatar(radius: 22, backgroundColor: Colors.grey),
               error: (e ,st)=> Text('Error $e'),
            ),
          ],
        ),
       const Spacer(), // pushes the button to the right
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2), // slimmer vertically
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // avoids extra height
          minimumSize: Size.zero, // removes default min constraints
        ),
        child: const Text("Follow"),
      ),
    ),
      ],
    );
  }
}
