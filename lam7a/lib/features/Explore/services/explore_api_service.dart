import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/models/user_model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'explore_api_service_mock.dart';

part 'explore_api_service.g.dart';

@riverpod
ExploreApiService exploreApiServiceMock(Ref ref) {
  return MockExploreApiService();
}

// @riverpod
// ExploreApiService exploreApiServiceImpl(Ref ref) {
//   return exploreApiServiceImpl(ref.read(apiServiceProvider));
// }

abstract class ExploreApiService {
  // Define your API methods here
  Future<List<TrendingHashtag>> fetchTrendingHashtags();
  Future<List<TrendingHashtag>> fetchInterestHashtags(String interest);

  Future<List<UserModel>> fetchSuggestedUsers({int? limit});
  Future<List<TweetModel>> fetchForYouTweets(int limit, int page);
  Future<List<TweetModel>> fetchInterestBasedTweets(
    int limit,
    int page,
    String interest,
  );

  // the tweets for explore will be in the tweet service
}
