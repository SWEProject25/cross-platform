import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';


part 'tweet_api_service.g.dart';

@riverpod
TweetsApiService tweetsApiService(Ref ref) {
  // Using real backend implementation
  return TweetsApiServiceImpl();
}
abstract class TweetsApiService {
  Future<List<TweetModel>> getAllTweets();
  Future<TweetModel> getTweetById(String id);
  Future<void> addTweet(TweetModel tweet);
  Future<void> updateTweet(TweetModel tweet);
  Future<void> deleteTweet(String id);
}
