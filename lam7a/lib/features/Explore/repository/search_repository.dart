import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/search_api_service.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

part 'search_repository.g.dart';

@riverpod
SearchRepository searchRepository(Ref ref) {
  return SearchRepository(ref.read(searchApiServiceImplProvider));
}

class SearchRepository {
  final SearchApiService _api;

  final List<String> _autocompletesCache = [
    'hello',
    'this',
    'is',
    'autocomplete',
    'welcome',
  ];

  final List<UserModel> _usersCache = [
    UserModel(
      id: 1,
      name: 'John Doe',
      username: 'johndoe',
      profileImageUrl: 'https://example.com/avatar1.png',
    ),
    UserModel(
      id: 2,
      name: 'Jane Smith',
      username: 'janesmith',
      profileImageUrl: 'https://example.com/avatar2.png',
    ),
  ];

  SearchRepository(this._api);

  Future<List<UserModel>> searchUsers(String query, int limit, int page) =>
      _api.searchUsers(query, limit, page);
  Future<List<TweetModel>> searchTweets(
    String query,
    int limit,
    int page, {
    String? tweetsOrder,
    String? time,
  }) => _api.searchTweets(
    query,
    limit,
    page,
    tweetsOrder: tweetsOrder,
    time: time,
  );
  Future<List<TweetModel>> searchHashtagTweets(
    String hashtag,
    int limit,
    int page, {
    String? tweetsOrder,
    String? time,
  }) => _api.searchHashtagTweets(
    hashtag,
    limit,
    page,
    tweetsOrder: tweetsOrder,
    time: time,
  );

  Future<List<String>> getCachedAutocompletes() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _autocompletesCache;
  }

  Future<List<UserModel>> getCachedUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return _usersCache;
  }

  // things to fetch in total
  //
  //1- trending hashtags
  //2- suggested users
  //10- explore page tweets
  //11- explore page with certain filter
}
