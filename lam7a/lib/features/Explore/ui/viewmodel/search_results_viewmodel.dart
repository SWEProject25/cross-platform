import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/search_result_state.dart';
import '../../repository/search_repository.dart';
import '../../../common/models/tweet_model.dart';
import '../../../../core/models/user_model.dart';

final searchResultsViewModelProvider =
    AsyncNotifierProvider.autoDispose<
      SearchResultsViewmodel,
      SearchResultState
    >(() {
      return SearchResultsViewmodel();
    });

class SearchResultsViewmodel extends AsyncNotifier<SearchResultState> {
  static const int _limit = 10;

  int _pageTop = 1;
  int _pageLatest = 1;
  int _pagePeople = 1;

  String _query = "";
  bool _isLoadingMore = false;
  bool _hasInitialized = false;

  @override
  Future<SearchResultState> build() async {
    print("BUILD CALLED");
    ref.keepAlive();
    return SearchResultState.initial();
  }

  // NEW SEARCH (full reset) - but only runs once per query
  Future<void> search(String query) async {
    // Prevent double initialization
    if (_hasInitialized && _query == query) {
      print("SEARCH SKIPPED - Already initialized with same query");
      return;
    }

    print("SEARCH CALLED WITH QUERY: $query");
    _query = query;
    _pageTop = 1;
    _pageLatest = 1;
    _pagePeople = 1;
    _isLoadingMore = false;
    _hasInitialized = true;

    state = const AsyncLoading();

    final searchRepo = ref.read(searchRepositoryProvider);
    final top = await searchRepo.searchTweets(_query, _limit, _pageTop);

    state = AsyncData(
      SearchResultState.initial().copyWith(
        currentResultType: CurrentResultType.top,
        topTweets: top,
        hasMoreTop: top.length == _limit,
        isTopLoading: false,
      ),
    );

    if (top.length == _limit) _pageTop++;
  }

  // SWITCH TAB

  Future<void> selectTab(CurrentResultType type) async {
    SearchResultState prev = state.value!;
    state = AsyncData(prev.copyWith(currentResultType: type));

    if (type == CurrentResultType.people && prev.searchedPeople.isEmpty) {
      loadPeople(reset: true);
    } else if (type == CurrentResultType.latest && prev.latestTweets.isEmpty) {
      loadLatest(reset: true);
    }
  }

  // PEOPLE

  Future<void> loadPeople({bool reset = false}) async {
    if (reset) {
      _pagePeople = 1;
      _isLoadingMore = false;
    }

    final previousPeople = reset
        ? List<UserModel>.empty()
        : state.value!.searchedPeople;

    state = AsyncData(
      state.value!.copyWith(
        searchedPeople: previousPeople,
        hasMorePeople: true,
        isPeopleLoading: true,
      ),
    );

    final searchRepo = ref.read(searchRepositoryProvider);
    final list = await searchRepo.searchUsers(_query, _limit, _pagePeople);

    state = AsyncData(
      state.value!.copyWith(
        searchedPeople: [...previousPeople, ...list],
        hasMorePeople: list.length == _limit,
        isPeopleLoading: false,
      ),
    );

    if (list.length == _limit) _pagePeople++;
  }

  Future<void> loadMorePeople() async {
    final prev = state.value!;
    if (!prev.hasMorePeople || _isLoadingMore) return;

    _isLoadingMore = true;

    final previousPeople = prev.searchedPeople;
    state = AsyncData(prev.copyWith(isPeopleLoading: true));

    final searchRepo = ref.read(searchRepositoryProvider);
    final list = await searchRepo.searchUsers(_query, _limit, _pagePeople);

    _isLoadingMore = false;

    state = AsyncData(
      state.value!.copyWith(
        searchedPeople: [...previousPeople, ...list],
        hasMorePeople: list.length == _limit,
        isPeopleLoading: false,
      ),
    );

    if (list.length == _limit) _pagePeople++;
  }

  // TOP

  Future<void> loadTop({bool reset = false}) async {
    print("LOAD TOP CALLED");

    if (reset) {
      _pageTop = 1;
      _isLoadingMore = false;
    }

    final previousTweets = reset
        ? List<TweetModel>.empty()
        : state.value!.topTweets;

    state = AsyncData(
      state.value!.copyWith(
        topTweets: previousTweets,
        hasMoreTop: true,
        isTopLoading: true,
      ),
    );

    final searchRepo = ref.read(searchRepositoryProvider);
    final posts = await searchRepo.searchTweets(_query, _limit, _pageTop);

    print("LOAD TOP RECEIVED POSTS");
    print(posts);

    state = AsyncData(
      state.value!.copyWith(
        topTweets: [...previousTweets, ...posts],
        hasMoreTop: posts.length == _limit,
        isTopLoading: false,
      ),
    );

    if (posts.length == _limit) _pageTop++;
  }

  Future<void> loadMoreTop() async {
    print("LOAD MORE TOP CALLED");
    final prev = state.value!;
    if (!prev.hasMoreTop || _isLoadingMore) return;

    _isLoadingMore = true;

    final previousTweets = prev.topTweets;
    state = AsyncData(prev.copyWith(isTopLoading: true));

    final searchRepo = ref.read(searchRepositoryProvider);
    final posts = await searchRepo.searchTweets(_query, _limit, _pageTop);

    _isLoadingMore = false;

    state = AsyncData(
      state.value!.copyWith(
        topTweets: [...previousTweets, ...posts],
        hasMoreTop: posts.length == _limit,
        isTopLoading: false,
      ),
    );

    if (posts.length == _limit) _pageTop++;
  }

  // LATEST

  Future<void> loadLatest({bool reset = false}) async {
    if (reset) {
      _pageLatest = 1;
      _isLoadingMore = false;
    }

    final previousTweets = reset
        ? List<TweetModel>.empty()
        : state.value!.latestTweets;

    state = AsyncData(
      state.value!.copyWith(
        latestTweets: previousTweets,
        hasMoreLatest: true,
        isLatestLoading: true,
      ),
    );

    final searchRepo = ref.read(searchRepositoryProvider);
    final posts = await searchRepo.searchTweets(
      _query,
      _limit,
      _pageLatest,
      tweetsOrder: "latest",
    );

    state = AsyncData(
      state.value!.copyWith(
        latestTweets: [...previousTweets, ...posts],
        hasMoreLatest: posts.length == _limit,
        isLatestLoading: false,
      ),
    );

    if (posts.length == _limit) _pageLatest++;
  }

  Future<void> loadMoreLatest() async {
    final prev = state.value!;
    if (!prev.hasMoreLatest || _isLoadingMore) return;

    _isLoadingMore = true;

    final previousTweets = prev.latestTweets;
    state = AsyncData(prev.copyWith(isLatestLoading: true));

    final searchRepo = ref.read(searchRepositoryProvider);
    final posts = await searchRepo.searchTweets(
      _query,
      _limit,
      _pageLatest,
      tweetsOrder: "latest",
    );

    _isLoadingMore = false;

    state = AsyncData(
      state.value!.copyWith(
        latestTweets: [...previousTweets, ...posts],
        hasMoreLatest: posts.length == _limit,
        isLatestLoading: false,
      ),
    );

    if (posts.length == _limit) _pageLatest++;
  }

  // REFRESH

  Future<void> refreshCurrentTab() async {
    final current = state.value!.currentResultType;

    if (current == CurrentResultType.top) {
      await loadTop(reset: true);
    } else if (current == CurrentResultType.latest) {
      await loadLatest(reset: true);
    } else if (current == CurrentResultType.people) {
      await loadPeople(reset: true);
    }
  }
}
