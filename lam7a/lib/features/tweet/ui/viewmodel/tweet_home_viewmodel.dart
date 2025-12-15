import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_home_viewmodel.g.dart';

/// ViewModel for Tweet Home Screen with proper pagination
@riverpod
class TweetHomeViewModel extends _$TweetHomeViewModel {
  Map<String, List<TweetModel>> _cachedTweets = Map();
  int _currentPage = 1;
  int _currentPageFollowing = 1;
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

  bool isFollowingEmptyInState() {
    final currentState = state.value;
    if (currentState == null) return true;

    final followingTweets = currentState['following'] ?? [];
    return followingTweets.isEmpty;
  }

  /// Fetch initial tweets (first page)
  Future<Map<String, List<TweetModel>>> _fetchInitialTweets() async {
    final repository = ref.read(tweetRepositoryProvider);
    final tweetsForYou = await repository.fetchTweetsForYou(_pageSize, 1);

    _cachedTweets['for-you'] = tweetsForYou;
    _cachedTweets['following'] = [];
    print(
      "there is cashed tweets" + _cachedTweets['for-you']!.length.toString(),
    );
    _currentPage = 1;
    _hasMoreForYou = tweetsForYou.length >= _pageSize;

    return {'for-you': tweetsForYou, 'following': []};
  }

  /// Load more tweets (next page) - called when scrolling near end
  Future<void> loadMoreTweetsForYou() async {
    // Prevent multiple simultaneous loads
    if (_isLoadingMore || (!_hasMoreForYou)) return;

    _isLoadingMore = true;

    try {
      final repository = ref.read(tweetRepositoryProvider);
      final nextPage = _currentPage + 1;

      final newTweets = await repository.fetchTweetsForYou(_pageSize, nextPage);

      if (newTweets.isEmpty) {
        _hasMoreForYou = false;
        return;
      }
      // Append new tweets to existing list
      final forYouTweets = _cachedTweets['for-you'] ?? [];
      final existingIds = forYouTweets.map((t) => t.id).toSet();
      final uniqueNewTweets = newTweets
          .where((t) => !existingIds.contains(t.id))
          .toList();

      _cachedTweets['for-you'] = [...forYouTweets, ...uniqueNewTweets];
      _currentPage = nextPage;
      _hasMoreForYou = newTweets.length >= _pageSize;
      // Update state with appended list
      state = AsyncValue.data(_cachedTweets);
    } catch (e) {
      _hasMoreForYou = false;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> loadMoreTweetsFollowing() async {
    // Prevent multiple simultaneous loads
    if (_isLoadingMore || (!_hasMoreFollowing)) return;

    _isLoadingMore = true;

    try {
      final repository = ref.read(tweetRepositoryProvider);
      final nextPage = _currentPageFollowing + 1;

      final newTweets = await repository.fetchTweetsFollowing(
        _pageSize,
        nextPage,
      );

      if (newTweets.isEmpty) {
        _hasMoreFollowing = false;
        return;
      }
      // Append new tweets to existing list
      final followingTweets = _cachedTweets['following'] ?? [];
      final existingIds = followingTweets.map((t) => t.id).toSet();
      final uniqueNewTweets = newTweets
          .where((t) => !existingIds.contains(t.id))
          .toList();

      _cachedTweets['following'] = [...followingTweets, ...uniqueNewTweets];
      _currentPageFollowing = nextPage;
      _hasMoreFollowing = newTweets.length >= _pageSize;
      // Update state with appended list
      state = AsyncValue.data(_cachedTweets);
    } catch (e) {
      _hasMoreFollowing = false;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Refresh tweets (pull-to-refresh) - resets to page 1
  Future<void> refreshTweetsForYou() async {
    // Reset pagination state
    _currentPageFollowing = 1;
    _isLoadingMore = false;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final tweets = await _fetchInitialTweets();
      return tweets;
    });
  }

  Future<void> refreshFollowingTweets() async {
    _isLoadingMore = false;

    state = const AsyncValue.loading();

    // Preserve current state
    final currentTweets = state.value ?? {'for-you': [], 'following': []};

    // Fetch new following tweets
    final repository = ref.read(tweetRepositoryProvider);

    state = await AsyncValue.guard(() async {
      final followingTweets = await repository.fetchTweetsFollowing(
        _pageSize,
        1,
      );

      _cachedTweets['following'] = followingTweets;
      _hasMoreFollowing = followingTweets.length >= _pageSize;
      return {
        'for-you': currentTweets['for-you'] ?? [],
        'following': followingTweets,
      };
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
    state = AsyncValue.data({
      'for-you': updated,
      'following': _cachedTweets['following']!,
    });

    print('✅ Tweet upserted locally');
  }

  bool get hasMoreForYou => _hasMoreForYou;
  bool get hasMoreFollowing => _hasMoreFollowing;
  bool get isLoadingMore => _isLoadingMore;
}
