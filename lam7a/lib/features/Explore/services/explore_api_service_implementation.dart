import 'explore_api_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/user_model.dart';
import '../model/trending_hashtag.dart';
import '../../../features/common/models/tweet_model.dart';
import '../../../features/profile/model/profile_model.dart';

class ExploreApiServiceImpl implements ExploreApiService {
  final ApiService _apiService;

  ExploreApiServiceImpl(this._apiService);

  // -------------------------------------------------------
  // Fetch Trending Hashtags
  // -------------------------------------------------------
  @override
  Future<List<TrendingHashtag>> fetchTrendingHashtags() async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/explore/hashtags",
      );

      List<dynamic> jsonList = response["data"] ?? [];

      List<TrendingHashtag> hashtags = jsonList.map((item) {
        return TrendingHashtag.fromJson(item);
      }).toList();

      print("Explore Hashtags fetched: ${hashtags.length}");
      return hashtags;
    } catch (e) {
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
        endpoint: "/explore/hashtags/interests",
        queryParameters: {"interest": interest},
      );

      List<dynamic> jsonList = response["data"] ?? [];

      List<TrendingHashtag> hashtags = jsonList.map((item) {
        return TrendingHashtag.fromJson(item);
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

      List<UserModel> users = (response['data'] as List).map((userJson) {
        return UserModel(
          id: userJson['user_id'],
          username: userJson['User']['username'],
          name: userJson['name'],
          bio: userJson['bio'],
          profileImageUrl: userJson['profile_image_url'],
          bannerImageUrl: userJson['banner_image_url'],
          followersCount: userJson['followers_count'],
          followingCount: userJson['following_count'],
          stateFollow: userJson['is_followed_by_me'] == 'true'
              ? ProfileStateOfFollow.following
              : ProfileStateOfFollow.notfollowing,
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
  // Fetch Explore Tweets (generic explore feed)
  // -------------------------------------------------------
  @override
  Future<List<TweetModel>> fetchForYouTweets(int limit, int page) async {
    try {
      Map<String, dynamic> response = await _apiService.get(
        endpoint: "/posts/timeline/explore",
        queryParameters: {"limit": limit, "page": page},
      );

      List<dynamic> postsJson = response["data"]["posts"] ?? [];

      List<TweetModel> tweets = postsJson.map((post) {
        return TweetModel.fromJsonPosts(post);
      }).toList();

      print("Explore Tweets fetched: ${tweets.length}");
      return tweets;
    } catch (e) {
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
        queryParameters: {"limit": limit, "page": page, "interests": interest},
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
