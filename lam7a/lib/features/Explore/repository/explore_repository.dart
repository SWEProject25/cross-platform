// coverage:ignore-file

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/explore_api_service.dart';
import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

part 'explore_repository.g.dart';

@riverpod
ExploreRepository exploreRepository(Ref ref) {
  return ExploreRepository(ref.read(exploreApiServiceImplProvider));
}

class ExploreRepository {
  final ExploreApiService _api;

  ExploreRepository(this._api);
  Future<List<TrendingHashtag>> getTrendingHashtags() =>
      _api.fetchTrendingHashtags();
  Future<List<TrendingHashtag>> getInterestHashtags(String interest) =>
      _api.fetchInterestHashtags(interest);
  Future<List<UserModel>> getSuggestedUsers({int? limit}) =>
      _api.fetchSuggestedUsers(limit: limit);
  Future<Map<String, List<TweetModel>>> getForYouTweets(int limit) =>
      _api.fetchForYouTweets(limit: limit);
  Future<List<TweetModel>> getExploreTweetsWithFilter(
    int limit,
    int page,
    String filter,
  ) => _api.fetchInterestBasedTweets(limit, page, filter);
}
