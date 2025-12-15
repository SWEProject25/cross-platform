// coverage:ignore-file

import 'explore_api_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/user_model.dart';
import '../model/trending_hashtag.dart';
import '../../../features/common/models/tweet_model.dart';

class ExploreApiServiceImpl implements ExploreApiService {
  final ApiService _apiService;

  ExploreApiServiceImpl(this._apiService);

  // -------------------------------------------------------
  // Fetch Trending Hashtags
  // -------------------------------------------------------
  @override
  Future<List<TrendingHashtag>> fetchTrendingHashtags({int limit = 30}) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/hashtags/trending",
        queryParameters: {"limit": limit, "Category": "general"},
      );

      List<dynamic> jsonList = response["data"]["trending"] ?? [];

      List<TrendingHashtag> hashtags = jsonList.map((item) {
        return TrendingHashtag.fromJson(
          item,
          order: jsonList.indexOf(item) + 1,
        );
      }).toList();

      print("Explore Hashtags fetched: ${hashtags.length}");
      return hashtags;
    } catch (e) {
      // print("Error fetching trending hashtags: $e");
      rethrow;
    }
  }

  // -------------------------------------------------------
  // Fetch Interest-Based Hashtags
  // -------------------------------------------------------
  @override
  Future<List<TrendingHashtag>> fetchInterestHashtags(String interest) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/hashtags/trending",
        queryParameters: {"Category": interest, "limit": 30},
      );

      List<dynamic> jsonList = response["data"]["trending"] ?? [];

      List<TrendingHashtag> hashtags = jsonList.map((item) {
        return TrendingHashtag.fromJson(item, category: interest);
      }).toList();

      print("Interest-Based Hashtags fetched ($interest): ${hashtags.length}");
      return hashtags;
    } catch (e) {
      rethrow;
    }
  }

  // -------------------------------------------------------
  // Fetch Suggested Users
  // -------------------------------------------------------
  @override
  Future<List<UserModel>> fetchSuggestedUsers({int? limit}) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/users/suggested",
        queryParameters: (limit != null) ? {"limit": limit} : null,
      );

      List<UserModel> users = (response['data']['users'] as List).map((
        userJson,
      ) {
        return UserModel(
          id: userJson['id'],
          username: userJson['username'],
          name: userJson['profile']['name'],
          bio: userJson['profile']['bio'],
          profileImageUrl: userJson['profile']['profileImageUrl'],
          bannerImageUrl: userJson['profile']['bannerImageUrl'],
          followersCount: userJson['followersCount'],

          stateFollow: ProfileStateOfFollow.notfollowing,
        );
      }).toList();

      print("searched users: ");
      print(users);
      return users;
    } catch (e) {
      rethrow;
    }
  }

  // -------------------------------------------------------
  // Fetch Explore Tweets for certain interests
  // -------------------------------------------------------

  @override
  Future<Map<String, List<TweetModel>>> fetchForYouTweets({
    int? limit = 3,
  }) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/posts/explore/for-you",
        queryParameters: {"limit": limit},
      );

      final data = response["data"] as Map<String, dynamic>? ?? {};
      final Map<String, List<TweetModel>> result = {};

      data.forEach((key, value) {
        final List<dynamic> postsJson = value ?? [];

        result[key] = postsJson
            .map((post) => TweetModel.fromJsonPosts(post))
            .toList();
      });

      print("Explore Tweets fetched: ${result.length} categories");
      return result;
    } catch (e, stackTrace) {
      print("Error fetching For You tweets: $stackTrace");
      rethrow;
    }
  }

  // -------------------------------------------------------
  // Interest-Based Explore Tweets
  // -------------------------------------------------------
  @override
  Future<List<TweetModel>> fetchInterestBasedTweets(
    int limit,
    int page,
    String interest,
  ) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/posts/timeline/explore/interests",
        // if there will be pagination
        // queryParameters: {"limit": limit, "page": page, "interests": interest},
        queryParameters: {"interests": interest},
      );

      List<dynamic> postsJson = response["data"]["posts"] ?? [];

      List<TweetModel> tweets = postsJson.map((post) {
        return TweetModel.fromJsonPosts(post);
      }).toList();

      print("Interest-Based Tweets fetched ($interest): ${tweets.length}");
      return tweets;
    } catch (e) {
      rethrow;
    }
  }
}
