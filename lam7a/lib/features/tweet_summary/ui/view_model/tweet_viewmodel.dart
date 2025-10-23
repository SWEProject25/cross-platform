import 'package:flutter/animation.dart';
import 'package:lam7a/features/tweet_summary/State/tweet_state.dart';
import 'package:lam7a/features/tweet_summary/repository/mock_tweet_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_viewmodel.g.dart';

@riverpod
class TweetViewModel extends _$TweetViewModel {

  @override
  FutureOr<TweetState> build(String tweetId) async {
    // Use the single service provider to fetch the tweet by id
  final MockTweetRepository repo = ref.read(mockTweetRepositoryProvider.notifier);
    final tweet = await repo.getTweetById(tweetId);
    return TweetState(tweet: tweet);
  }

  //  Handle Like toggle
  void handleLike({required AnimationController controller}) {
    final repo = ref.read(mockTweetRepositoryProvider.notifier);
    final current = state.value!;
    final tweet= state.value!.tweet;
    if (current.isLiked) {
      final updated = tweet.copyWith(likes: tweet.likes - 1);
      final updatedState = current.copyWith(tweet: updated,isLiked: false);
      repo.updateTweet(updated);
      state = AsyncData(updatedState);
    } else {
      controller.forward().then((_) => controller.reverse());
      final updated = tweet.copyWith(likes: tweet.likes + 1);
      final updatedState = current.copyWith(tweet: updated,isLiked: true);
      repo.updateTweet(updated);
      state = AsyncData(updatedState);
    }
  }

  // Handle Repost toggle
  void handleRepost({required AnimationController controllerRepost}) {
    final repo = ref.read(mockTweetRepositoryProvider.notifier);
    final current = state.value!;
    final tweet= state.value!.tweet;
    if (current.isReposted) {
       final updated = tweet.copyWith(repost: tweet.repost - 1);
       final updatedState = current.copyWith(tweet: updated,isReposted: false);
      state = AsyncData(updatedState);
       repo.updateTweet(updated);
    } else {
      controllerRepost.forward().then((_) => controllerRepost.reverse());
      final updated = tweet.copyWith(repost: tweet.repost + 1);
      final updatedState = current.copyWith(tweet: updated,isReposted: true);
      state = AsyncData(updatedState);
      repo.updateTweet(updated);
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
    final repo= ref.read(mockTweetRepositoryProvider.notifier);
    final current=state.value!;
    final tweet= state.value!.tweet;
    if (!current.isViewed) {
      final updated=tweet.copyWith(views: tweet.views+1);
      final updatedState= current.copyWith(tweet: updated,isViewed: true);
      state = AsyncData(updatedState);
      repo.updateTweet(updated);
    }
  }

  void handleComment() {
    // TODO: add comment logic
  }

  void summarizeBody() {
    // TODO: implement tweet summarization
  }
  void handleShare() {}
  void handleBookmark() {}
  bool getIsLiked() {
    return state.value!.isLiked;
  }

  bool getisReposted() {
    return state.value!.isReposted;
  }
}
