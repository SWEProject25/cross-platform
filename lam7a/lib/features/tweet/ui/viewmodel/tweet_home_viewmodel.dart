import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_home_viewmodel.g.dart';

/// ViewModel for Tweet Home Screen with proper pagination
@riverpod
class TweetHomeViewModel extends _$TweetHomeViewModel {
  Map<String, List<TweetModel>> _cachedTweets = Map();
  int _currentPage = 1;
  bool _hasMoreForYou = true;
  bool _hasMoreFollowing = true;
  bool _isLoadingMore = false;
  int currentTab = 0;
  static const int _pageSize = 5;

  @override
  Future<Map<String, List<TweetModel>>> build() async {
    ref.keepAlive();

    // If we have cached tweets, return them immediately
    if (_cachedTweets.isNotEmpty) {
      return _cachedTweets;
    }
    Map<String, List<TweetModel>> tweets = Map();
    tweets = await _fetchInitialTweets();
    return tweets;
  }

  /// Fetch initial tweets (first page)
  Future<Map<String, List<TweetModel>>> _fetchInitialTweets() async {
    final repository = ref.read(tweetRepositoryProvider);
    final tweetsForYou = await repository.fetchTweets(_pageSize, 1, 'for-you');
    final tweetsFollownig = await repository.fetchTweets(
      _pageSize,
      1,
      'following',
    );

    _cachedTweets['for-you'] = tweetsForYou;
    _cachedTweets['following'] = tweetsFollownig;
    _currentPage = 1;
    _hasMoreForYou = tweetsForYou.length >= _pageSize;
    _hasMoreFollowing = tweetsFollownig.length >= _pageSize;

    return {'for-you': tweetsForYou, 'following': tweetsFollownig};
  }

  /// Load more tweets (next page) - called when scrolling near end
  Future<void> loadMoreTweets(String tweetsType) async {
    // Prevent multiple simultaneous loads
    if (_isLoadingMore || (!_hasMoreForYou && tweetsType == 'for-you')) return;
    if (_isLoadingMore || (!_hasMoreFollowing && tweetsType == 'following'))
      return;

    _isLoadingMore = true;

    try {
      final repository = ref.read(tweetRepositoryProvider);
      final nextPage = _currentPage + 1;

      final newTweets = await repository.fetchTweets(
        _pageSize,
        nextPage,
        tweetsType,
      );

      if (newTweets.isEmpty && tweetsType == 'for-you') {
        _hasMoreForYou = false;
        return;
      }

      if (newTweets.isEmpty && tweetsType == 'following') {
        _hasMoreFollowing = false;
        return;
      }
      // Append new tweets to existing list
      final existingIds = _cachedTweets[tweetsType]!.map((t) => t.id).toSet();
      final uniqueNewTweets = newTweets
          .where((t) => !existingIds.contains(t.id))
          .toList();

      _cachedTweets[tweetsType] = [
        ..._cachedTweets[tweetsType]!,
        ...uniqueNewTweets,
      ];
      _currentPage = nextPage;
      if (tweetsType == 'for-you') {
        _hasMoreForYou = newTweets.length >= _pageSize;
      } else {
        _hasMoreFollowing = newTweets.length >= _pageSize;
      }

      // Update state with appended list
      state = AsyncValue.data(_cachedTweets);
    } catch (e) {
      _hasMoreForYou = false;
      _hasMoreFollowing = false;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh tweets (pull-to-refresh) - resets to page 1
  Future<void> refreshTweets() async {
    print('🔄 Refreshing tweets...');

    // Reset pagination state
    _currentPage = 1;
    _hasMoreForYou = true;
    _hasMoreFollowing = true;
    _isLoadingMore = false;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final tweets = await _fetchInitialTweets();
      return tweets;
    });
  }

  void upsertTweetLocally(TweetModel tweet) {
    final current = state.value!['for-you'];

    if (current == null) {
      _cachedTweets['for-you'] = [tweet];
      state = AsyncValue.data({
        'for-you': [tweet],
        'following': _cachedTweets['following'] ?? [],
      });
      return;
    }

    // Add new tweet at the beginning, remove if it already exists
    final updated = <TweetModel>[
      tweet,
      ...current.where((t) => t.id != tweet.id),
    ];

    _cachedTweets['for-you'] = updated;
    _cachedTweets['following'] = _cachedTweets['following'] ?? [];
    state = AsyncValue.data({'for-you': updated, 'following': _cachedTweets['following']!});

    print('✅ Tweet upserted locally');
  }

  bool get hasMoreForYou => _hasMoreForYou;
  bool get hasMoreFollowing => _hasMoreFollowing;
  bool get isLoadingMore => _isLoadingMore;
}
