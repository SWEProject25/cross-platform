import 'package:flutter/animation.dart';
import 'package:lam7a/features/tweet_summary/models/tweet.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_tweet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_viewmodel.g.dart';

@riverpod
class TweetViewModel extends _$TweetViewModel {
  bool isLiked=false;
  bool isReposted=false;
  bool isViewed=false;
  @override
  FutureOr<TweetModel> build(String tweetId) async {
    // Listen to the tweetByIdProvider (mock repository)
    final tweet = await ref.watch(tweetByIdProvider(tweetId).future);
    return tweet;
  }

  //  Handle Like toggle
 void handleLike({
    required AnimationController controller,
  }) {
    if (isLiked) {
      isLiked = false;
      state = AsyncData(
        state.value!.copyWith(likes: state.value!.likes - 1),
      );
    } else {
      controller.forward().then((_) => controller.reverse());
      isLiked = true;
      state = AsyncData(
        state.value!.copyWith(likes: state.value!.likes + 1),
      );
    }
  }

  // Handle Repost toggle
  void handleRepost({
    required AnimationController controllerRepost,
  }) {
    if (isReposted) {
      isReposted = false;
      state = AsyncData(
        state.value!.copyWith(repost: state.value!.repost - 1),
      );
    } else {
      controllerRepost.forward().then((_) => controllerRepost.reverse());
      isReposted = true;
      state = AsyncData(
        state.value!.copyWith(repost: state.value!.repost + 1),
      );
    }
  }

  // Format large numbers (K, M, B)
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

    String formatted = (m % 1 == 0)
        ? m.toInt().toString()
        : m.toStringAsFixed(2).replaceAll(RegExp(r'\.0+$'), '');
    return '$formatted$s';
  }

  void handleViews() {
    if(!isViewed)
    {state = AsyncData(
        state.value!.copyWith(views: state.value!.views +1),
      );
      isViewed=true;
    }
    
  }

  void handleComment() {
    // TODO: add comment logic
  }

  void summarizeBody() {
    // TODO: implement tweet summarization
  }
  void handleShare()
  {

  }
  void handleBookmark()
  {

  }
  bool getIsLiked()
  {
    return isLiked;
  }
  bool getisReposted()
  {
    return isReposted;
  }
}
