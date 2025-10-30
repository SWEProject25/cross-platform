import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart';
// import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart'; // Uncomment for mock
import 'package:lam7a/core/api/authenticated_dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';


part 'tweet_api_service.g.dart';

@riverpod
Future<TweetsApiService> tweetsApiService(Ref ref) async {
  // SWITCHED TO REAL BACKEND: Now using backend API
  final dio = await ref.watch(authenticatedDioProvider.future);
  return TweetsApiServiceImpl(dio: dio);
  
  // MOCK SERVICE (commented out): Uncomment below for local testing without backend
  // return TweetsApiServiceMock();
}
abstract class TweetsApiService {
  Future<List<TweetModel>> getAllTweets();
  Future<TweetModel> getTweetById(String id);
  Future<void> addTweet(TweetModel tweet);
  Future<void> updateTweet(TweetModel tweet);
  Future<void> deleteTweet(String id);
}
