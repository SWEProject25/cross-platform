// feature/tweet/repository/tweet_repository.dart
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_repository.g.dart';

@riverpod
TweetRepository tweetRepository(Ref ref) {
  // Using real backend API service
  final apiService = ref.read(tweetsApiServiceProvider);
  return TweetRepository(apiService);
}

class TweetRepository {
  final TweetsApiService _apiService;

  TweetRepository(this._apiService);

  Future<List<TweetModel>> fetchAllTweets(int limit, int page) async {
    return await _apiService.getAllTweets(limit, page);
  }

  Future<List<TweetModel>> fetchTweets(
    int limit,
    int page,
    String tweetsType,
  ) async {
    return await _apiService.getTweets(limit, page, tweetsType);
  }

  Future<TweetModel> fetchTweetById(String id) async {
    return await _apiService.getTweetById(id);
  }

  Future<void> updateTweet(TweetModel tweet) async {
    await _apiService.updateTweet(tweet);
  }

  Future<void> deleteTweet(String id) async {
    await _apiService.deleteTweet(id);
  }

  // Add other repository methods as needed for the profile feature

  Future<List<TweetModel>> fetchUserPosts(String userId) async {
    // API already returns List<TweetModel>
    final posts = await _apiService.getTweetsByUser(userId);
    return posts;
  }

  Future<List<TweetModel>> fetchUserReplies(String userId) async {
    // API already returns List<TweetModel>
    final replies = await _apiService.getRepliesByUser(userId);
    return replies;
  }

  Future<List<TweetModel>> fetchUserLikes(String userId) async {
    // API already returns List<TweetModel>
    final likes = await _apiService.getUserLikedPosts(userId);
    return likes;
  }


}
