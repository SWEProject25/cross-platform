import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_body_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_detailed.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';

class TweetScreen extends ConsumerWidget {
  final String tweetId;
  final TweetModel? tweetData; // Optional: pre-loaded tweet to avoid 404

  const TweetScreen({
    super.key,
    required this.tweetId,
    this.tweetData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If tweet data provided, use it directly (avoids 404 from backend)
    if (tweetData != null) {
      final tweetState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(tweetData!),
      );
      
      return SafeArea(
        child: Container(
          alignment: Alignment.topLeft,
          color: Colors.black,
          padding: const EdgeInsets.only(left: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweetUserInfoDetailed(tweetState: tweetState),
                const SizedBox(height: 10),
                TweetDetailedBodyWidget(tweetState: tweetState),
                TweetDetailedFeed(tweetState: tweetState),
              ],
            ),
          ),
        ),
      );
    }
    
    // Otherwise fetch using ViewModel (will fail with 404 if backend doesn't support it)
    final tweetAsync = ref.watch(tweetViewModelProvider(tweetId));

    return SafeArea(
      child: Container(
        alignment: Alignment.topLeft,
        color: Colors.black,
        padding: const EdgeInsets.only(left: 10),
        child: SingleChildScrollView(
          child: tweetAsync.when(
            data: (tweet) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // user
                TweetUserInfoDetailed(tweetState: tweet),

                // body
                const SizedBox(height: 10),
                TweetDetailedBodyWidget(tweetState: tweet),

                // feed
                TweetDetailedFeed(tweetState: tweet),
              ],
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ),
    );
  }
}
