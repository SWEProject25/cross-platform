import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import '../../../core/models/user_model.dart';
import 'search_api_service_mock.dart';
import 'search_api_service_implementation.dart';

part 'search_api_service.g.dart';

// @riverpod
// SearchApiService searchApiServiceMock(Ref ref) {
//   return SearchApiServiceMock();
// }

@riverpod
SearchApiService searchApiServiceImpl(Ref ref) {
  return SearchApiServiceImpl(ref.read(apiServiceProvider));
}

abstract class SearchApiService {
  //Future<List<String>> autocompleteSearch(String query);
  Future<List<UserModel>> searchUsers(String query, int limit, int page);
  Future<List<TweetModel>> searchTweets(
    String query,
    int limit,
    int page, {
    String? tweetsOrder,
  }); // tweetsType can be top/latest

  Future<List<TweetModel>> searchHashtagTweets(
    String hashtag,
    int limit,
    int page, {
    String? tweetsOrder,
  }); // tweetsType can be top/latest
}
