import '../../model/trending_hashtag.dart';
import '../../../../core/models/user_model.dart';

enum ExplorePageView { forYou, trending }

class ExploreState {
  final ExplorePageView selectedPage;
  final List<TrendingHashtag>? trendingHashtags;
  final List<UserModel>? suggestedUsers;

  ExploreState({
    this.selectedPage = ExplorePageView.forYou,
    this.trendingHashtags = const [],
    this.suggestedUsers = const [],
  });

  ExploreState copyWith({
    ExplorePageView? selectedPage,
    List<TrendingHashtag>? trendingHashtags,
    List<UserModel>? suggestedUsers,
  }) {
    return ExploreState(
      selectedPage: selectedPage ?? this.selectedPage,
      trendingHashtags: trendingHashtags ?? this.trendingHashtags,
      suggestedUsers: suggestedUsers ?? this.suggestedUsers,
    );
  }
}
