// import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart'; // Uncomment for real backend
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';
// import 'package:lam7a/core/api/authenticated_dio_provider.dart'; // Uncomment for real backend
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';


part 'tweet_api_service.g.dart';

@riverpod
TweetsApiService tweetsApiService(Ref ref) {
  // SWITCHED TO MOCK: Using mock service for local testing (no backend needed)
  return TweetsApiServiceMock();
  
  // REAL SERVICE (commented out): Uncomment below AND the imports above to use real backend
  // final dio = await ref.watch(authenticatedDioProvider.future);
  // return TweetsApiServiceImpl(dio: dio);
}
abstract class TweetsApiService {
  Future<List<TweetModel>> getAllTweets();
  Future<TweetModel> getTweetById(String id);
  Future<void> addTweet(TweetModel tweet);
  Future<void> updateTweet(TweetModel tweet);
  Future<void> deleteTweet(String id);
}
