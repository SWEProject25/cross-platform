import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/trending_hashtag.dart';
import '../../../../core/models/user_model.dart';
import '../state/explore_state.dart';

final exploreViewModelProvider =
    AsyncNotifierProvider<ExploreViewModel, ExploreState>(() {
      return ExploreViewModel();
    });

class ExploreViewModel extends AsyncNotifier<ExploreState> {
  @override
  Future<ExploreState> build() async {
    await Future.delayed(const Duration(milliseconds: 700));

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

  void selectTap(ExplorePageView newPage) {
    final prev = state.value;
    if (prev == null) return;

    state = AsyncData(prev.copyWith(selectedPage: newPage));
  }

  Future<void> refreshHashtags() async {
    final prev = state.value;
    if (prev == null) return;

    await Future.delayed(const Duration(milliseconds: 600));

    final newHashtags = [
      TrendingHashtag(hashtag: "#UpdatedTag"),
      TrendingHashtag(hashtag: "#MoreTrends"),
      TrendingHashtag(hashtag: "#FlutterDev"),
    ];

    state = AsyncData(prev.copyWith(trendingHashtags: newHashtags));
  }

  Future<void> refreshUsers() async {
    final prev = state.value;
    if (prev == null) return;

    await Future.delayed(const Duration(milliseconds: 600));

    final newUsers = [
      UserModel(id: 10, username: "NewUser1"),
      UserModel(id: 11, username: "NewUser2"),
    ];

    state = AsyncData(prev.copyWith(suggestedUsers: newUsers));
  }
}
