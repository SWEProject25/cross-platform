import 'package:flutter/widgets.dart';
import 'package:lam7a/features/tweet_summary/models/tweet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_viewmodel.g.dart';

@riverpod
class TweetViewModel extends _$TweetViewModel{
  @override
  TweetModel build(String tweetId, {TweetModel? initialTweet}) {
    // Could check from Firestore, REST API, or local cache
    return initialTweet ?? TweetModel.empty(); // default (not liked)
  }
    bool handleLike({ required AnimationController controller ,required bool isLiked }) {
      
    if (isLiked) {
        isLiked = !isLiked;
       state = state.copyWith(likes: state.likes - 1);
      
    } else {
      controller.forward().then((_) => controller.reverse());
      isLiked = !isLiked;
      state = state.copyWith(likes: state.likes + 1);
    }
    return isLiked;
  }
    bool handlerepost({required bool isReposted , required AnimationController controllerRepost}) {
    if (isReposted) {
      isReposted = !isReposted;

      state=state.copyWith(repost: state.repost-1);
    } else {
      controllerRepost.forward().then((_) => controllerRepost.reverse());
      isReposted = !isReposted;
       state=state.copyWith(repost: state.repost+1);

    }
      return isReposted;
  }
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
  void handleViews() {

  }

  void handleComment() {

  }
    //TO DO
  void summerizeBody() {}

  ///
}
