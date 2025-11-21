import '../../../../core/models/user_model.dart';
import '../../../common/models/tweet_model.dart';

enum CurrentResultType { top, latest, people }

class SearchResultState {
  final CurrentResultType currentResultType;
  final List<UserModel> searchedPeople;
  final List<TweetModel> searchedTweets;

  SearchResultState({
    this.currentResultType = CurrentResultType.top,
    this.searchedPeople = const [],
    this.searchedTweets = const [],
  });

  SearchResultState copyWith({
    CurrentResultType? currentResultType,
    List<UserModel>? searchedPeople,
    List<TweetModel>? searchedTweets,
  }) {
    return SearchResultState(
      currentResultType: currentResultType ?? this.currentResultType,
      searchedPeople: searchedPeople ?? this.searchedPeople,
      searchedTweets: searchedTweets ?? this.searchedTweets,
    );
  }
}
