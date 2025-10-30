import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_repository.g.dart';

@riverpod
Future<TweetRepository> tweetRepository(Ref ref) async {
  // Using real backend API service
  final apiService = await ref.read(tweetsApiServiceProvider.future);
  return TweetRepository(apiService);
}

class TweetRepository {
  final TweetsApiService _apiService;

  TweetRepository(this._apiService);

  Future<List<TweetModel>> fetchAllTweets() async {
    return await _apiService.getAllTweets();
  }

  Future<TweetModel> fetchTweetById(String id) async {
    return await _apiService.getTweetById(id);
  }

  Future<void> addTweet(TweetModel tweet) async {
    await _apiService.addTweet(tweet);
  }

  Future<void> updateTweet(TweetModel tweet) async {
    await _apiService.updateTweet(tweet);
  }

  Future<void> deleteTweet(String id) async {
    await _apiService.deleteTweet(id);
  }
}
