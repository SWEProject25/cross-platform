import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import '../state/explore_state.dart';
import '../../repository/explore_repository.dart';
import '../../../common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';

final exploreViewModelProvider =
    AsyncNotifierProvider<ExploreViewModel, ExploreState>(() {
      return ExploreViewModel();
    });

class ExploreViewModel extends AsyncNotifier<ExploreState> {
  static const int _limit = 10;

  // PAGE COUNTERS
  int _currentInterestPage = 1;
  bool _isLoadingMore = false;
  bool _initialized = false;

  List<TrendingHashtag> _hashtags = [];

  late final ExploreRepository _repo;

  @override
  Future<ExploreState> build() async {
    ref.keepAlive();
    _repo = ref.read(exploreRepositoryProvider);

    if (_initialized) return state.value!;
    _initialized = true;

    try {
      _hashtags = await _repo.getTrendingHashtags();
      print("Explore Hashtags loaded: ${_hashtags.length}");

      final randomHashtags = _hashtags.isEmpty
          ? <TrendingHashtag>[]
          : (List.of(_hashtags)..shuffle()).take(5).toList();

      if (randomHashtags.isEmpty) {
        await Future.delayed(const Duration(seconds: 1));
      }

      final users = await _repo.getSuggestedUsers(limit: 7);
      print("Suggested Users loaded: ${users.length}");

      final randomUsers = users.isEmpty
          ? <UserModel>[]
          : (List.of(
              users.length >= 7 ? users.take(7) : users,
            )..shuffle()).take(5).toList();

      final forYouTweetsMap = await _repo.getForYouTweets(_limit);
      print("For You Tweets Map loaded: ${forYouTweetsMap.length} interests");

      print("Explore ViewModel initialized");

      return ExploreState.initial().copyWith(
        forYouHashtags: randomHashtags,
        suggestedUsers: randomUsers,
        interestBasedTweets: forYouTweetsMap,
        isForYouHashtagsLoading: false,
        isSuggestedUsersLoading: false,
        isInterestMapLoading: false,
      );
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      print("Error initializing Explore ViewModel: $e");
      rethrow;
    }
  }

  // --------------------------------------------------------
  // SWITCH TAB
  // --------------------------------------------------------
  Future<void> selectTab(ExplorePageView page) async {
    final prev = state.value!;
    state = AsyncData(prev.copyWith(selectedPage: page));

    switch (page) {
      case ExplorePageView.forYou:
        if (prev.forYouHashtags.isEmpty ||
            prev.suggestedUsers.isEmpty ||
            prev.interestBasedTweets.isEmpty) {
          await loadForYou(reset: true);
        }
        break;

      case ExplorePageView.trending:
        if (prev.trendingHashtags.isEmpty) await loadTrending(reset: true);
        break;

      case ExplorePageView.exploreNews:
        if (prev.newsHashtags.isEmpty) {
          await loadNews(reset: true);
        }
        break;

      case ExplorePageView.exploreSports:
        if (prev.sportsHashtags.isEmpty) {
          await loadSports(reset: true);
        }
        break;

      case ExplorePageView.exploreEntertainment:
        if (prev.entertainmentHashtags.isEmpty) {
          await loadEntertainment(reset: true);
        }
        break;
    }
  }

  // ========================================================
  // FOR YOU
  // ========================================================
  Future<void> loadForYou({bool reset = false}) async {
    try {
      if (reset) {
        _isLoadingMore = false;
      }

      final prev = state.value!;
      final oldList = reset ? <TrendingHashtag>[] : prev.forYouHashtags;

      final oldSuggestedUsers = reset ? <UserModel>[] : prev.suggestedUsers;

      final oldForYouTweetsMap = reset
          ? <String, List<TweetModel>>{}
          : prev.interestBasedTweets;

      state = AsyncData(
        prev.copyWith(
          forYouHashtags: oldList,
          isForYouHashtagsLoading: true,
          suggestedUsers: oldSuggestedUsers,
          isSuggestedUsersLoading: true,
          interestBasedTweets: oldForYouTweetsMap,
          isInterestMapLoading: true,
        ),
      );

      final list = await _repo.getTrendingHashtags();
      final randomHashtags = list.isEmpty
          ? <TrendingHashtag>[]
          : (List.of(list)..shuffle()).take(5).toList();

      final users = await _repo.getSuggestedUsers(limit: 7);
      final randomUsers = users.isEmpty
          ? <UserModel>[]
          : (List.of(
              users.length >= 7 ? users.take(7) : users,
            )..shuffle()).take(5).toList();

      final forYouTweetsMap = await _repo.getForYouTweets(_limit);

      state = AsyncData(
        state.value!.copyWith(
          forYouHashtags: randomHashtags,
          isForYouHashtagsLoading: false,
          suggestedUsers: randomUsers,
          isSuggestedUsersLoading: false,
          interestBasedTweets: forYouTweetsMap,
          isInterestMapLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading For You: $e");
      rethrow;
    }
  }

  // ========================================================
  // TRENDING
  // ========================================================
  Future<void> loadTrending({bool reset = false}) async {
    try {
      if (reset) {
        _isLoadingMore = false;
      }

      final prev = state.value!;
      final oldList = reset ? <TrendingHashtag>[] : prev.trendingHashtags;

      state = AsyncData(
        prev.copyWith(trendingHashtags: oldList, isHashtagsLoading: true),
      );

      final list = await _repo.getTrendingHashtags();

      state = AsyncData(
        state.value!.copyWith(
          trendingHashtags: [...oldList, ...list],
          isHashtagsLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading Trending: $e");
      rethrow;
    }
  }

  // ========================================================
  // NEWS
  // ========================================================
  Future<void> loadNews({bool reset = false}) async {
    try {
      if (reset) {
        _isLoadingMore = false;
      }

      final prev = state.value!;
      final oldList = reset ? <TrendingHashtag>[] : prev.newsHashtags;

      state = AsyncData(
        prev.copyWith(newsHashtags: oldList, isNewsHashtagsLoading: true),
      );

      final list = await _repo.getInterestHashtags("news");

      state = AsyncData(
        state.value!.copyWith(
          newsHashtags: [...oldList, ...list],
          isNewsHashtagsLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading News: $e");
      rethrow;
    }
  }

  // ========================================================
  // SPORTS
  // ========================================================
  Future<void> loadSports({bool reset = false}) async {
    try {
      if (reset) {
        _isLoadingMore = false;
      }

      final prev = state.value!;
      final oldList = reset ? <TrendingHashtag>[] : prev.sportsHashtags;

      state = AsyncData(
        prev.copyWith(sportsHashtags: oldList, isSportsHashtagsLoading: true),
      );

      final list = await _repo.getInterestHashtags("sports");

      state = AsyncData(
        state.value!.copyWith(
          sportsHashtags: [...oldList, ...list],
          isSportsHashtagsLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading Sports: $e");
      rethrow;
    }
  }

  // ========================================================
  // ENTERTAINMENT
  // ========================================================
  Future<void> loadEntertainment({bool reset = false}) async {
    try {
      if (reset) {
        _isLoadingMore = false;
      }

      final prev = state.value!;
      final oldList = reset ? <TrendingHashtag>[] : prev.entertainmentHashtags;

      state = AsyncData(
        prev.copyWith(
          entertainmentHashtags: oldList,
          isEntertainmentHashtagsLoading: true,
        ),
      );

      final list = await _repo.getInterestHashtags("entertainment");

      state = AsyncData(
        state.value!.copyWith(
          entertainmentHashtags: [...oldList, ...list],
          isEntertainmentHashtagsLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading Entertainment: $e");
      rethrow;
    }
  }

  // --------------------------------------------------------
  // REFRESH CURRENT TAB
  // --------------------------------------------------------
  Future<void> refreshCurrentTab() async {
    switch (state.value!.selectedPage) {
      case ExplorePageView.forYou:
        await loadForYou(reset: true);
        break;

      case ExplorePageView.trending:
        await loadTrending(reset: true);
        break;

      case ExplorePageView.exploreNews:
        await loadNews(reset: true);
        break;

      case ExplorePageView.exploreSports:
        await loadSports(reset: true);
        break;

      case ExplorePageView.exploreEntertainment:
        await loadEntertainment(reset: true);
        break;
    }
  }

  Future<void> loadSuggestedUsers() async {
    try {
      final prev = state.value!;
      final oldList = prev.suggestedUsers;

      state = AsyncData(
        prev.copyWith(suggestedUsers: oldList, isSuggestedUsersLoading: true),
      );

      final users = await _repo.getSuggestedUsers(limit: 30);

      state = AsyncData(
        state.value!.copyWith(
          suggestedUsersFull: users,
          isSuggestedUsersLoading: false,
        ),
      );
    } catch (e) {
      print("Error loading Suggested Users: $e");
      rethrow;
    }
  }

  Future<void> loadIntresesTweets(String intreset) async {
    try {
      final prev = state.value!;
      _currentInterestPage = 1;

      state = AsyncData(
        prev.copyWith(
          intrestTweets: <TweetModel>[],
          isIntrestTweetsLoading: true,
        ),
      );

      final list = await _repo.getExploreTweetsWithFilter(
        _limit,
        _currentInterestPage,
        intreset,
      );

      state = AsyncData(
        state.value!.copyWith(
          intrestTweets: list,
          isIntrestTweetsLoading: false,
          hasMoreIntrestTweets: list.length == _limit,
        ),
      );

      if (list.length == _limit) _currentInterestPage++;
    } catch (e) {
      print("Error loading Interest Tweets: $e");
      rethrow;
    }
  }

  Future<void> loadMoreInterestedTweets(String interest) async {
    try {
      final prev = state.value!;
      if (!prev.hasMoreIntrestTweets || _isLoadingMore) return;

      _isLoadingMore = true;

      final oldList = prev.intrestTweets;
      state = AsyncData(prev.copyWith(isIntrestTweetsLoading: true));

      final list = await _repo.getExploreTweetsWithFilter(
        _limit,
        _currentInterestPage,
        interest,
      );

      _isLoadingMore = false;

      state = AsyncData(
        state.value!.copyWith(
          intrestTweets: [...oldList, ...list],
          isIntrestTweetsLoading: false,
          hasMoreIntrestTweets: list.length == _limit,
        ),
      );

      if (list.length == _limit) _currentInterestPage++;
    } catch (e) {
      _isLoadingMore = false;
      print("Error loading more Interest Tweets: $e");
      rethrow;
    }
  }
}


// for you some trends and people to follow 
//trendign -> top hashtags
//sports -> tweet and some trends
//news -> tweets and some trends
//entertainment -> tweets and some trends

// think about caching just the last result



