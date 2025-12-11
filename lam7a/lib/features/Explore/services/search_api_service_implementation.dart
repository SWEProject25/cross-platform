import 'search_api_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/models/user_model.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class SearchApiServiceImpl implements SearchApiService {
  final ApiService _apiService;

  SearchApiServiceImpl(this._apiService);

  @override
  Future<List<UserModel>> searchUsers(String query, int limit, int page) async {
    Map<String, dynamic> response = await _apiService.get(
      endpoint: '/profile/search',
      queryParameters: {'query': query, 'limit': limit, 'page': page},
    );

    //we can add the rest if needed later
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
  }

  @override
  Future<List<TweetModel>> searchTweets(
    String query,
    int limit,
    int page, {
    String? tweetsOrder,
    String? time,
  }) async {
    print("running searchTweets API");
    Map<String, dynamic> response = await _apiService.get(
      endpoint: "/posts/search",
      queryParameters: {
        "limit": limit,
        "page": page,
        "searchQuery": query,

        if (tweetsOrder != null) "order_by": tweetsOrder,
        if (time != null) "before_date": time,
      },
    );

    List<dynamic> postsJson = response['data']['posts'];

    List<TweetModel> tweets = postsJson.map((post) {
      return TweetModel.fromJsonPosts(post);
    }).toList();
    print("searched tweets: ");
    print(tweets);
    return tweets;
  }

  @override
  Future<List<TweetModel>> searchHashtagTweets(
    String hashtag,
    int limit,
    int page, {
    String? tweetsOrder,
    String? time,
  }) async {
    Map<String, dynamic> response = await _apiService.get(
      endpoint: "/posts/search/hashtag",
      queryParameters: {
        "limit": limit,
        "page": page,
        "hashtag": hashtag,
        if (tweetsOrder != null) "order_by": tweetsOrder,
        if (time != null) "before_date": time,
      },
    );

    List<dynamic> postsJson = response['data']['posts'];

    List<TweetModel> tweets = postsJson.map((post) {
      return TweetModel.fromJsonPosts(post);
    }).toList();

    return tweets;
  }
}
