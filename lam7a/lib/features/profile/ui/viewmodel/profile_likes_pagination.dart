import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import '../../utils/profile_tweet_mapper.dart';

final profileLikesProvider = NotifierProvider.family<
    ProfileLikesPaginationNotifier,
    PaginationState<TweetModel>,
    String>(
  ProfileLikesPaginationNotifier.new,
);

class ProfileLikesPaginationNotifier
    extends PaginationNotifier<TweetModel> {

  final String userId;
  ProfileLikesPaginationNotifier(this.userId);

  TweetRepository get _repo => ref.read(tweetRepositoryProvider);

  @override
  PaginationState<TweetModel> build() {

    Future.microtask(loadInitial);
    return const PaginationState();
  }

  @override
  Future<(List<TweetModel>, bool)> fetchPage(int page) async {
    final allLikes = await _repo.fetchUserLikes(userId);

    if (allLikes.isEmpty) {
      return (<TweetModel>[], false);
    }

    final start = (page - 1) * pageSize;
    if (start >= allLikes.length) {
      return (<TweetModel>[], false);
    }

    final end = (start + pageSize) > allLikes.length
        ? allLikes.length
        : (start + pageSize);

    final items = allLikes.sublist(start, end);
    final hasMore = end < allLikes.length;

    return (items, hasMore);
  }

  Map<String, dynamic> normalizeTweetJson(Map<String, dynamic> e) {
    return {
      "id": e["postId"],
      "text": e["text"],
      "createdAt": e["date"],

      // 👇 REQUIRED BY TweetModel
      "user": {
        "id": e["userId"],
        "username": e["username"],
        "name": e["name"],
        "avatar": e["avatar"],
        "verified": e["verified"] ?? false,
      },

      "likesCount": e["likesCount"] ?? 0,
      "retweetsCount": e["retweetsCount"] ?? 0,
      "commentsCount": e["commentsCount"] ?? 0,

      "isLikedByMe": e["isLikedByMe"] ?? false,
      "isRepostedByMe": e["isRepostedByMe"] ?? false,
      "isFollowedByMe": e["isFollowedByMe"] ?? false,

      "media": e["media"] ?? [],
      "mentions": e["mentions"] ?? [],

      "isRepost": e["isRepost"] ?? false,
      "isQuote": e["isQuote"] ?? false,
    };
  }
}
