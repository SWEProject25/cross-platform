import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_home_viewmodel.g.dart';

/// ViewModel for Tweet Home Screen
/// Manages fetching and displaying all tweets
@riverpod
class TweetHomeViewModel extends _$TweetHomeViewModel {
  @override
  Future<List<TweetModel>> build() async {
    return await _fetchAllTweets();
  }

  /// Fetch all tweets from repository
  Future<List<TweetModel>> _fetchAllTweets() async {
    final repository = ref.read(tweetRepositoryProvider);
    return await repository.fetchAllTweets();
  }

  /// Refresh tweets (call this after posting a new tweet)
  Future<void> refreshTweets() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchAllTweets();
    });
  }
}
