import '../../../../core/models/user_model.dart';
import '../../../common/models/tweet_model.dart';

enum CurrentResultType { top, latest, people }

class SearchResultState {
  final CurrentResultType currentResultType;

  // People
  final bool hasMorePeople;
  final List<UserModel> searchedPeople;
  final bool isPeopleLoading;
  // Top tweets
  final bool hasMoreTop;
  final List<TweetModel> topTweets;
  final bool isTopLoading;
  // Latest tweets
  final bool hasMoreLatest;
  final List<TweetModel> latestTweets;
  final bool isLatestLoading;

  SearchResultState({
    required this.currentResultType,
    required this.hasMorePeople,
    required this.searchedPeople,
    required this.hasMoreTop,
    required this.topTweets,
    required this.hasMoreLatest,
    required this.latestTweets,
    this.isPeopleLoading = false,
    this.isTopLoading = false,
    this.isLatestLoading = false,
  });

  factory SearchResultState.initial() => SearchResultState(
    currentResultType: CurrentResultType.top,
    hasMorePeople: true,
    searchedPeople: [],
    hasMoreTop: true,
    topTweets: [],
    hasMoreLatest: true,
    latestTweets: [],
    isPeopleLoading: true,
    isTopLoading: true,
    isLatestLoading: true,
  );

  SearchResultState copyWith({
    CurrentResultType? currentResultType,
    bool? hasMorePeople,
    List<UserModel>? searchedPeople,
    bool? hasMoreTop,
    List<TweetModel>? topTweets,
    bool? hasMoreLatest,
    List<TweetModel>? latestTweets,
    bool? isPeopleLoading,
    bool? isTopLoading,
    bool? isLatestLoading,
  }) {
    return SearchResultState(
      currentResultType: currentResultType ?? this.currentResultType,
      hasMorePeople: hasMorePeople ?? this.hasMorePeople,
      searchedPeople: searchedPeople ?? this.searchedPeople,
      hasMoreTop: hasMoreTop ?? this.hasMoreTop,
      topTweets: topTweets ?? this.topTweets,
      hasMoreLatest: hasMoreLatest ?? this.hasMoreLatest,
      latestTweets: latestTweets ?? this.latestTweets,
      isPeopleLoading: isPeopleLoading ?? this.isPeopleLoading,
      isTopLoading: isTopLoading ?? this.isTopLoading,
      isLatestLoading: isLatestLoading ?? this.isLatestLoading,
    );
  }
}
