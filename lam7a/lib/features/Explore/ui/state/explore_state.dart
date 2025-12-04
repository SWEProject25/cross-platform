import '../../model/trending_hashtag.dart';
import '../../../../core/models/user_model.dart';
import '../../../common/models/tweet_model.dart';

enum ExplorePageView {
  forYou,
  trending,
  exploreNews,
  exploreSports,
  exploreEntertainment,
}

class ExploreState {
  final ExplorePageView selectedPage;

  // for you
  final bool isForYouHashtagsLoading;
  final List<TrendingHashtag> forYouHashtags;
  final List<UserModel> suggestedUsers;
  final bool isSuggestedUsersLoading;
  final List<TweetModel> forYouTweets;
  final bool isForYouTweetsLoading;
  final bool hasMoreForYouTweets;

  // trending
  final bool isHashtagsLoading;
  final List<TrendingHashtag> trendingHashtags;

  //news
  final bool isNewsHashtagsLoading;
  final List<TrendingHashtag> newsHashtags;
  final List<TweetModel> newsTweets;
  final bool isNewsTweetsLoading;
  final bool hasMoreNewsTweets;

  // sports
  final bool isSportsHashtagsLoading;
  final List<TrendingHashtag> sportsHashtags;
  final List<TweetModel> sportsTweets;
  final bool isSportsTweetsLoading;
  final bool hasMoreSportsTweets;

  // entertainment
  final bool isEntertainmentHashtagsLoading;
  final List<TrendingHashtag> entertainmentHashtags;
  final List<TweetModel> entertainmentTweets;
  final bool isEntertainmentTweetsLoading;
  final bool hasMoreEntertainmentTweets;

  ExploreState({
    required this.selectedPage,

    // for you
    this.isForYouHashtagsLoading = true,
    this.forYouHashtags = const [],
    this.suggestedUsers = const [],
    this.isSuggestedUsersLoading = true,
    this.forYouTweets = const [],
    this.isForYouTweetsLoading = true,
    this.hasMoreForYouTweets = true,

    // trending
    this.isHashtagsLoading = true,
    this.trendingHashtags = const [],

    // news
    this.isNewsHashtagsLoading = true,
    this.newsHashtags = const [],
    this.newsTweets = const [],
    this.isNewsTweetsLoading = true,
    this.hasMoreNewsTweets = true,

    // sports
    this.isSportsHashtagsLoading = true,
    this.sportsHashtags = const [],
    this.sportsTweets = const [],
    this.isSportsTweetsLoading = true,
    this.hasMoreSportsTweets = true,

    // entertainment
    this.isEntertainmentHashtagsLoading = true,
    this.entertainmentHashtags = const [],
    this.entertainmentTweets = const [],
    this.isEntertainmentTweetsLoading = true,
    this.hasMoreEntertainmentTweets = true,
  });

  factory ExploreState.initial() =>
      ExploreState(selectedPage: ExplorePageView.forYou);

  ExploreState copyWith({
    ExplorePageView? selectedPage,
    List<TrendingHashtag>? trendingHashtags,
    bool? isHashtagsLoading,
    List<UserModel>? suggestedUsers,
    bool? isSuggestedUsersLoading,
    List<TrendingHashtag>? forYouHashtags,
    bool? isForYouHashtagsLoading,
    List<TweetModel>? forYouTweets,
    bool? isForYouTweetsLoading,
    bool? hasMoreForYouTweets,
    List<TweetModel>? newsTweets,
    bool? isNewsTweetsLoading,
    bool? hasMoreNewsTweets,
    List<TweetModel>? sportsTweets,
    bool? isSportsTweetsLoading,
    bool? hasMoreSportsTweets,
    List<TweetModel>? entertainmentTweets,
    bool? isEntertainmentTweetsLoading,
    bool? hasMoreEntertainmentTweets,
  }) {
    return ExploreState(
      selectedPage: selectedPage ?? this.selectedPage,

      trendingHashtags: trendingHashtags ?? this.trendingHashtags,
      isHashtagsLoading: isHashtagsLoading ?? this.isHashtagsLoading,

      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      isSuggestedUsersLoading:
          isSuggestedUsersLoading ?? this.isSuggestedUsersLoading,
      newsTweets: newsTweets ?? this.newsTweets,
      isNewsTweetsLoading: isNewsTweetsLoading ?? this.isNewsTweetsLoading,
      hasMoreNewsTweets: hasMoreNewsTweets ?? this.hasMoreNewsTweets,
      sportsTweets: sportsTweets ?? this.sportsTweets,
      isSportsTweetsLoading:
          isSportsTweetsLoading ?? this.isSportsTweetsLoading,
      hasMoreSportsTweets: hasMoreSportsTweets ?? this.hasMoreSportsTweets,
      entertainmentTweets: entertainmentTweets ?? this.entertainmentTweets,
      isEntertainmentTweetsLoading:
          isEntertainmentTweetsLoading ?? this.isEntertainmentTweetsLoading,
      hasMoreEntertainmentTweets:
          hasMoreEntertainmentTweets ?? this.hasMoreEntertainmentTweets,
    );
  }
}
