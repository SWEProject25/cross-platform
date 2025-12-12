import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive/hive.dart';

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

  static const String autocompletesBox = 'autocomplete_stack';
  static const String usersBox = 'recent_users_stack';
  static const int maxSize = 8;

  SearchRepository(this._api);

  // -------------------------------
  // HIVE STACK HELPER FUNCTIONS
  // -------------------------------

  Future<void> pushAutocomplete(String value) async {
    final box = await Hive.openBox<String>(autocompletesBox);

    box.values.where((v) => v == value).toList().forEach((v) {
      final index = box.values.toList().indexOf(v);
      if (index != -1) box.deleteAt(index);
    });

    await box.add(value);

    if (box.length > maxSize) {
      await box.deleteAt(0); // remove oldest
    }
  }

  Future<List<String>> getCachedAutocompletes() async {
    final box = await Hive.openBox<String>(autocompletesBox);
    return box.values.toList().reversed.toList();
  }

  Future<void> pushUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>(usersBox);

    // Remove duplicates by id
    final existingIndex = box.values.toList().indexWhere(
      (u) => u.id != null && u.id == user.id,
    );

    if (existingIndex != -1) {
      await box.deleteAt(existingIndex);
    }

    // Insert newest user at top
    await box.add(user);

    // Enforce max size
    if (box.length > maxSize) {
      await box.deleteAt(0);
    }
  }

  /// GET all recent cached users (LIFO)
  Future<List<UserModel>> getCachedUsers() async {
    final box = await Hive.openBox<UserModel>(usersBox);
    return box.values.toList().reversed.toList();
  }

  // --------------------------------------
  // API FUNCTIONS (unchanged)
  // --------------------------------------

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
}
