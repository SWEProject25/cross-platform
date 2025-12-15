import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';

final profileRepliesProvider = NotifierProvider.family<
    ProfileRepliesPaginationNotifier,
    PaginationState<TweetModel>,
    String>(
  ProfileRepliesPaginationNotifier.new,
);

class ProfileRepliesPaginationNotifier
    extends PaginationNotifier<TweetModel> {

  final String userId;
  ProfileRepliesPaginationNotifier(this.userId);

  TweetRepository get _repo => ref.read(tweetRepositoryProvider);

  @override
  PaginationState<TweetModel> build() {
    Future.microtask(loadInitial);
    return const PaginationState();
  }

  @override
  Future<(List<TweetModel>, bool)> fetchPage(int page) async {
    final allReplies = await _repo.fetchUserReplies(userId);

    if (allReplies.isEmpty) {
      return (<TweetModel>[], false);
    }

    final start = (page - 1) * pageSize;
    if (start >= allReplies.length) {
      return (<TweetModel>[], false);
    }

    final end =
        (start + pageSize) > allReplies.length ? allReplies.length : (start + pageSize);

    final items = allReplies.sublist(start, end);
    final hasMore = end < allReplies.length;

    return (items, hasMore);
  }
}