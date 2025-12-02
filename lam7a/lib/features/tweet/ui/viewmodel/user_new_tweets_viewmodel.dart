import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_new_tweets_viewmodel.g.dart';

@riverpod
class UserNewTweetsViewModel extends _$UserNewTweetsViewModel {
  @override
  List<TweetModel> build() {
    return [];
  }

  void addTweet(TweetModel tweet) {
    final existing = state;
    final existingIds = existing.map((t) => t.id).toSet();

    if (existingIds.contains(tweet.id)) {
      state = [
        tweet,
        ...existing.where((t) => t.id != tweet.id),
      ];
    } else {
      state = [tweet, ...existing];
    }
  }

  void removeTweet(String id) {
    state = state.where((t) => t.id != id).toList();
  }

  void clear() {
    state = [];
  }
}
