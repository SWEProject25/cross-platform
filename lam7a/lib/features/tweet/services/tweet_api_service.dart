import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart'; // Uncomment for mock
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

part 'tweet_api_service.g.dart';

@Riverpod(keepAlive: true)
TweetsApiService tweetsApiService(Ref ref) {
  // SWITCHED TO REAL BACKEND: Now using backend API
  // keepAlive: true ensures the service instance persists and doesn't lose interaction flags
  final apiService = ref.watch(apiServiceProvider);
  //return TweetsApiServiceMock();
  return TweetsApiServiceImpl(apiService: apiService);
  // MOCK SERVICE (commented out): Uncomment below for local testing without backend
  //return TweetsApiServiceMock();
}

abstract class TweetsApiService {
  Future<List<TweetModel>> getAllTweets(int limit, int page);
  Future<TweetModel> getTweetById(String id);
  Future<void> updateTweet(TweetModel tweet);
  Future<void> deleteTweet(String id);

  /// Get interaction flags (isLikedByMe, isRepostedByMe) for a tweet
  Future<Map<String, bool>?> getInteractionFlags(String tweetId);

  /// Update interaction flag after toggle operation
  void updateInteractionFlag(String tweetId, String flagName, bool value);

  /// Get locally stored views override for a tweet, if any
  int? getLocalViews(String tweetId);

  /// Set locally stored views override for a tweet
  void setLocalViews(String tweetId, int views);

  /// Get replies for a given post
  Future<List<TweetModel>> getRepliesForPost(String postId);

  // use this to get the tweets in my explore and intresets
  Future<List<TweetModel>> getTweets(int limit, int page, String tweetsType);

  Future<String> getTweetSummery(String tweetId);

  // Future<Future<List<TweetModel>>> getFollowingTweets(int limit, int page, String tweetsType) async {}

  // Profile related methods
  Future<List<TweetModel>> getTweetsByUser(String userId);
  Future<List<TweetModel>> getRepliesByUser(String userId);
  Future<List<TweetModel>> getUserLikedPosts(String userId);
}
