import 'package:lam7a/features/Explore/model/trending_hashtag.dart';

abstract class ExploreApiService {
  // Define your API methods here
  Future<List<TrendingHashtag>> fetchExploreHashtags();
  Future<List<Map<String, dynamic>>> fetchSuggestedUsers();

  // the tweets for explore will be in the tweet service
}
