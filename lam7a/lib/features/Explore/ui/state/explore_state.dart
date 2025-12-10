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
  final List<UserModel> suggestedUsersFull;

  // for you
  final bool isForYouHashtagsLoading;
  final List<TrendingHashtag> forYouHashtags;
  final List<UserModel> suggestedUsers;
  final bool isSuggestedUsersLoading;

  // trending
  final bool isHashtagsLoading;
  final List<TrendingHashtag> trendingHashtags;

  //news
  final bool isNewsHashtagsLoading;
  final List<TrendingHashtag> newsHashtags;
  // final List<TweetModel> newsTweets;
  // final bool isNewsTweetsLoading;
  // final bool hasMoreNewsTweets;

  // sports
  final bool isSportsHashtagsLoading;
  final List<TrendingHashtag> sportsHashtags;
  // final List<TweetModel> sportsTweets;
  // final bool isSportsTweetsLoading;
  // final bool hasMoreSportsTweets;

  // entertainment
  final bool isEntertainmentHashtagsLoading;
  final List<TrendingHashtag> entertainmentHashtags;
  // final List<TweetModel> entertainmentTweets;
  // final bool isEntertainmentTweetsLoading;
  // final bool hasMoreEntertainmentTweets;

  // per interests tweets
  final Map<String, List<TweetModel>> interestBasedTweets;
  final bool isInterestMapLoading;

  final List<TweetModel> intrestTweets;
  final bool isIntrestTweetsLoading;
  final bool hasMoreIntrestTweets;

  ExploreState({
    required this.selectedPage,
    this.suggestedUsersFull = const [],
    // for you
    this.isForYouHashtagsLoading = true,
    this.forYouHashtags = const [],
    this.suggestedUsers = const [],
    this.isSuggestedUsersLoading = true,

    // trending
    this.isHashtagsLoading = true,
    this.trendingHashtags = const [],

    // news
    this.isNewsHashtagsLoading = true,
    this.newsHashtags = const [],
    // this.newsTweets = const [],
    // this.isNewsTweetsLoading = true,
    // this.hasMoreNewsTweets = true,

    // sports
    this.isSportsHashtagsLoading = true,
    this.sportsHashtags = const [],
    // this.sportsTweets = const [],
    // this.isSportsTweetsLoading = true,
    // this.hasMoreSportsTweets = true,

    // entertainment
    this.isEntertainmentHashtagsLoading = true,
    this.entertainmentHashtags = const [],

    // this.entertainmentTweets = const [],
    // this.isEntertainmentTweetsLoading = true,
    // this.hasMoreEntertainmentTweets = true,

    // per interests tweets
    this.interestBasedTweets = const {},
    this.isInterestMapLoading = true,
    this.intrestTweets = const [],
    this.isIntrestTweetsLoading = true,
    this.hasMoreIntrestTweets = true,
  });

  factory ExploreState.initial() =>
      ExploreState(selectedPage: ExplorePageView.forYou);

  ExploreState copyWith({
    ExplorePageView? selectedPage,
    List<UserModel>? suggestedUsersFull,

    List<TrendingHashtag>? trendingHashtags,
    bool? isHashtagsLoading,
    List<UserModel>? suggestedUsers,

    bool? isSuggestedUsersLoading,
    List<TrendingHashtag>? forYouHashtags,
    bool? isForYouHashtagsLoading,
    List<TweetModel>? forYouTweets,
    bool? isForYouTweetsLoading,
    //bool? hasMoreForYouTweets,
    // List<TweetModel>? newsTweets,
    // bool? isNewsTweetsLoading,
    // bool? hasMoreNewsTweets,
    bool? isNewsHashtagsLoading,
    List<TrendingHashtag>? newsHashtags,
    // List<TweetModel>? sportsTweets,
    // bool? isSportsTweetsLoading,
    // bool? hasMoreSportsTweets,
    bool? isSportsHashtagsLoading,
    List<TrendingHashtag>? sportsHashtags,
    // List<TweetModel>? entertainmentTweets,
    // bool? isEntertainmentTweetsLoading,
    // bool? hasMoreEntertainmentTweets,
    bool? isEntertainmentHashtagsLoading,
    List<TrendingHashtag>? entertainmentHashtags,

    Map<String, List<TweetModel>>? interestBasedTweets,
    bool? isInterestMapLoading,
    List<TweetModel>? intrestTweets,
    bool? isIntrestTweetsLoading,
    bool? hasMoreIntrestTweets,
  }) {
    return ExploreState(
      selectedPage: selectedPage ?? this.selectedPage,
      suggestedUsersFull: suggestedUsersFull ?? this.suggestedUsersFull,

      trendingHashtags: trendingHashtags ?? this.trendingHashtags,
      isHashtagsLoading: isHashtagsLoading ?? this.isHashtagsLoading,

      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
      isSuggestedUsersLoading:
          isSuggestedUsersLoading ?? this.isSuggestedUsersLoading,
      forYouHashtags: forYouHashtags ?? this.forYouHashtags,
      isForYouHashtagsLoading:
          isForYouHashtagsLoading ?? this.isForYouHashtagsLoading,

      // newsTweets: newsTweets ?? this.newsTweets,
      // isNewsTweetsLoading: isNewsTweetsLoading ?? this.isNewsTweetsLoading,
      // hasMoreNewsTweets: hasMoreNewsTweets ?? this.hasMoreNewsTweets,
      isNewsHashtagsLoading:
          isNewsHashtagsLoading ?? this.isNewsHashtagsLoading,
      newsHashtags: newsHashtags ?? this.newsHashtags,
      // sportsTweets: sportsTweets ?? this.sportsTweets,

      // isSportsTweetsLoading:
      //     isSportsTweetsLoading ?? this.isSportsTweetsLoading,
      // hasMoreSportsTweets: hasMoreSportsTweets ?? this.hasMoreSportsTweets,
      isSportsHashtagsLoading:
          isSportsHashtagsLoading ?? this.isSportsHashtagsLoading,
      sportsHashtags: sportsHashtags ?? this.sportsHashtags,

      // entertainmentTweets: entertainmentTweets ?? this.entertainmentTweets,
      // isEntertainmentTweetsLoading:
      //     isEntertainmentTweetsLoading ?? this.isEntertainmentTweetsLoading,
      // hasMoreEntertainmentTweets:
      //     hasMoreEntertainmentTweets ?? this.hasMoreEntertainmentTweets,
      isEntertainmentHashtagsLoading:
          isEntertainmentHashtagsLoading ?? this.isEntertainmentHashtagsLoading,
      entertainmentHashtags:
          entertainmentHashtags ?? this.entertainmentHashtags,

      interestBasedTweets: interestBasedTweets ?? this.interestBasedTweets,
      isInterestMapLoading: isInterestMapLoading ?? this.isInterestMapLoading,
      intrestTweets: intrestTweets ?? this.intrestTweets,
      isIntrestTweetsLoading:
          isIntrestTweetsLoading ?? this.isIntrestTweetsLoading,
      hasMoreIntrestTweets: hasMoreIntrestTweets ?? this.hasMoreIntrestTweets,
    );
  }
}
