import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../model/trending_hashtag.dart';
import '../../../../core/models/user_model.dart';
import '../state/explore_state.dart';

part 'explore_viewmodel.g.dart';

@riverpod
class ExploreViewModel extends _$ExploreViewModel {
  @override
  Future<ExploreState> build() async {
    // Pretend we are fetching data from an API
    await Future.delayed(const Duration(milliseconds: 700));

    // Dummy data for now
    final hashtags = [
      TrendingHashtag(hashtag: "#Flutter", order: 1, tweetsCount: 12100),
      TrendingHashtag(hashtag: "#Riverpod", order: 2, tweetsCount: 8000),
      TrendingHashtag(hashtag: "#DartLang", order: 3, tweetsCount: 6000),
      TrendingHashtag(hashtag: "#ArabDev", order: 4, tweetsCount: 4000),
    ];

    final users = [
      UserModel(id: 1, username: "UserA"),
      UserModel(id: 2, username: "UserB"),
      UserModel(id: 3, username: "UserC"),
    ];

    return ExploreState(
      selectedPage: ExplorePageView.forYou,
      trendingHashtags: hashtags,
      suggestedUsers: users,
    );
  }

  /// Switch between For You and Trending tabs
  void selectTap(ExplorePageView newPage) {
    // Update state, keeping existing lists
    state = state.whenData((data) => data.copyWith(selectedPage: newPage));
  }

  /// Refresh hashtags
  Future<void> refreshHashtags() async {
    final prev = state.value;

    await Future.delayed(const Duration(milliseconds: 600));

    final newHashtags = [
      TrendingHashtag(hashtag: "#UpdatedTag"),
      TrendingHashtag(hashtag: "#MoreTrends"),
      TrendingHashtag(hashtag: "#FlutterDev"),
    ];

    state = AsyncData(prev!.copyWith(trendingHashtags: newHashtags));
  }

  /// Refresh suggested users
  Future<void> refreshUsers() async {
    final prev = state.value;
    await Future.delayed(const Duration(milliseconds: 600));

    final newUsers = [
      UserModel(id: 10, username: "NewUser1"),
      UserModel(id: 11, username: "NewUser2"),
    ];

    state = AsyncData(prev!.copyWith(suggestedUsers: newUsers));
  }
}
