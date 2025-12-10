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

    _hashtags = await _repo.getTrendingHashtags();
    print("Explore Hashtags loaded: ${_hashtags.length}");

    final randomHashtags = (List.of(_hashtags)..shuffle()).take(5).toList();

    final users = await _repo.getSuggestedUsers(limit: 7);
    print("Suggested Users loaded: ${users.length}");

    final randomUsers = (List.of(
      users.length >= 7 ? users.take(7) : users,
    )..shuffle()).take(5).toList();

    // final forYouTweets = await _repo.getForYouTweets(_limit, _pageForYou);

    //if (forYouTweets.length == _limit) _pageForYou++;

    print("Explore ViewModel initialized");

    return ExploreState.initial().copyWith(
      forYouHashtags: randomHashtags,
      suggestedUsers: randomUsers,

      // hasMoreForYouTweets: forYouTweets.length == _limit,
      //forYouTweets: forYouTweets,
      isForYouHashtagsLoading: false,

      isSuggestedUsersLoading: false,
    );
  }

  // --------------------------------------------------------
  // SWITCH TAB
  // --------------------------------------------------------
  Future<void> selectTab(ExplorePageView page) async {
    final prev = state.value!;
    state = AsyncData(prev.copyWith(selectedPage: page));

    switch (page) {
      case ExplorePageView.forYou:
        if (prev.forYouHashtags.isEmpty || prev.suggestedUsers.isEmpty
        //||prev.forYouTweets.isEmpty
        ) {
          await loadForYou(reset: true);
        }
        break;

      case ExplorePageView.trending:
        if (prev.trendingHashtags.isEmpty) await loadTrending(reset: true);
        break;

      case ExplorePageView.exploreNews:
        if ( //prev.newsTweets.isEmpty) {
        prev.newsHashtags.isEmpty) {
          await loadNews(reset: true);
        }
        break;

      case ExplorePageView.exploreSports:
        if ( //prev.sportsTweets.isEmpty ||
        prev.sportsHashtags.isEmpty) {
          await loadSports(reset: true);
        }
        break;

      case ExplorePageView.exploreEntertainment:
        if ( //prev.entertainmentTweets.isEmpty ||
        prev.entertainmentHashtags.isEmpty) {
          await loadEntertainment(reset: true);
        }
        break;
    }
  }

  // ========================================================
  // FOR YOU
  // ========================================================
  Future<void> loadForYou({bool reset = false}) async {
    if (reset) {
      _isLoadingMore = false;
    }

    final prev = state.value!;
    final oldList = reset
        ? List<TrendingHashtag>.empty()
        : prev.trendingHashtags;

    final oldSuggestedUsers = reset
        ? List<UserModel>.empty()
        : prev.suggestedUsers;

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
    final randomHashtags = (List.of(list)..shuffle()).take(5).toList();
    final users = await _repo.getSuggestedUsers(limit: 7);
    final randomUsers = (List.of(
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
  }

  // Future<void> loadMoreForYou() async {
  //   final prev = state.value!;
  //   if (!prev.hasMoreForYouTweets || _isLoadingMore) return;

  //   _isLoadingMore = true;

  //   final oldList = prev.forYouTweets;
  //   state = AsyncData(prev.copyWith(isForYouTweetsLoading: true));

  //   final list = await _repo.getForYouTweets(_limit, _pageForYou);

  //   _isLoadingMore = false;

  //   state = AsyncData(
  //     state.value!.copyWith(
  //       forYouTweets: [...oldList, ...list],
  //       isForYouTweetsLoading: false,
  //       hasMoreForYouTweets: list.length == _limit,
  //     ),
  //   );

  //   if (list.length == _limit) _pageForYou++;
  // }

  // ========================================================
  // TRENDING
  // ========================================================
  Future<void> loadTrending({bool reset = false}) async {
    if (reset) {
      _isLoadingMore = false;
    }

    final prev = state.value!;
    final oldList = reset
        ? List<TrendingHashtag>.empty()
        : prev.trendingHashtags;

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
  }

  // ========================================================
  // NEWS
  // ========================================================
  Future<void> loadNews({bool reset = false}) async {
    // if (reset) {
    //   _pageNews = 1;
    //   _isLoadingMore = false;
    // }

    // final prev = state.value!;
    // final oldList = reset ? List<TweetModel>.empty() : prev.newsTweets;

    // state = AsyncData(
    //   prev.copyWith(
    //     newsTweets: oldList,
    //     isNewsTweetsLoading: false,
    //     hasMoreNewsTweets: true,
    //   ),
    // );

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageNews,
    //   "news",
    // );

    // state = AsyncData(
    //   state.value!.copyWith(
    //     newsTweets: [...oldList, ...list],
    //     isNewsTweetsLoading: true,
    //     hasMoreNewsTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageNews++;
    if (reset) {
      _isLoadingMore = false;
    }

    final prev = state.value!;
    final oldList = reset ? List<TrendingHashtag>.empty() : prev.newsHashtags;

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
  }

  Future<void> loadMoreNews() async {
    // final prev = state.value!;
    // if (!prev.hasMoreNewsTweets || _isLoadingMore) return;

    // _isLoadingMore = true;

    // final oldList = prev.newsTweets;
    // state = AsyncData(prev.copyWith(isNewsTweetsLoading: true));

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageNews,
    //   "news",
    // );

    // _isLoadingMore = false;

    // state = AsyncData(
    //   state.value!.copyWith(
    //     newsTweets: [...oldList, ...list],
    //     isNewsTweetsLoading: false,
    //     hasMoreNewsTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageNews++;
  }

  // ========================================================
  // SPORTS
  // ========================================================
  Future<void> loadSports({bool reset = false}) async {
    // if (reset) {
    //   _pageSports = 1;
    //   _isLoadingMore = false;
    // }

    // final prev = state.value!;
    // final oldList = reset ? <TweetModel>[] : prev.sportsTweets;

    // state = AsyncData(
    //   prev.copyWith(
    //     sportsTweets: oldList,
    //     isSportsTweetsLoading: true,
    //     hasMoreSportsTweets: true,
    //   ),
    // );

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageSports,
    //   "sports",
    // );

    // state = AsyncData(
    //   state.value!.copyWith(
    //     sportsTweets: [...oldList, ...list],
    //     isSportsTweetsLoading: false,
    //     hasMoreSportsTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageSports++;

    if (reset) {
      _isLoadingMore = false;
    }

    final prev = state.value!;
    final oldList = reset ? List<TrendingHashtag>.empty() : prev.sportsHashtags;

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
  }

  Future<void> loadMoreSports() async {
    // final prev = state.value!;
    // if (!prev.hasMoreSportsTweets || _isLoadingMore) return;

    // _isLoadingMore = true;

    // final oldList = prev.sportsTweets;
    // state = AsyncData(prev.copyWith(isSportsTweetsLoading: true));

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageSports,
    //   "sports",
    // );

    // _isLoadingMore = false;

    // state = AsyncData(
    //   state.value!.copyWith(
    //     sportsTweets: [...oldList, ...list],
    //     isSportsTweetsLoading: false,
    //     hasMoreSportsTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageSports++;
  }

  // ========================================================
  // ENTERTAINMENT
  // ========================================================
  Future<void> loadEntertainment({bool reset = false}) async {
    // if (reset) {
    //   _pageEntertainment = 1;
    //   _isLoadingMore = false;
    // }

    // final prev = state.value!;
    // final oldList = reset ? <TweetModel>[] : prev.entertainmentTweets;

    // state = AsyncData(
    //   prev.copyWith(
    //     entertainmentTweets: oldList,
    //     isEntertainmentTweetsLoading: true,
    //     hasMoreEntertainmentTweets: true,
    //   ),
    // );

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageEntertainment,
    //   "entertainment",
    // );

    // state = AsyncData(
    //   state.value!.copyWith(
    //     entertainmentTweets: [...oldList, ...list],
    //     isEntertainmentTweetsLoading: false,
    //     hasMoreEntertainmentTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageEntertainment++;

    if (reset) {
      _isLoadingMore = false;
    }

    final prev = state.value!;
    final oldList = reset
        ? List<TrendingHashtag>.empty()
        : prev.entertainmentHashtags;

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
  }

  Future<void> loadMoreEntertainment() async {
    // final prev = state.value!;
    // if (!prev.hasMoreEntertainmentTweets || _isLoadingMore) return;

    // _isLoadingMore = true;

    // final oldList = prev.entertainmentTweets;
    // state = AsyncData(prev.copyWith(isEntertainmentTweetsLoading: true));

    // final list = await _repo.getExploreTweetsWithFilter(
    //   _limit,
    //   _pageEntertainment,
    //   "entertainment",
    // );

    // _isLoadingMore = false;

    // state = AsyncData(
    //   state.value!.copyWith(
    //     entertainmentTweets: [...oldList, ...list],
    //     isEntertainmentTweetsLoading: false,
    //     hasMoreEntertainmentTweets: list.length == _limit,
    //   ),
    // );

    // if (list.length == _limit) _pageEntertainment++;
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
  }

  Future<void> loadIntresesTweets(String intreset) async {
    final prev = state.value!;
    _currentInterestPage = 1;

    state = AsyncData(
      prev.copyWith(intrestTweets: List.empty(), isIntrestTweetsLoading: true),
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
  }

  Future<void> loadMoreInterestedTweets(String interest) async {
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
  }
}


// for you some trends and people to follow 
//trendign -> top hashtags
//sports -> tweet and some trends
//news -> tweets and some trends
//entertainment -> tweets and some trends

// think about caching just the last result 



