import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

// ------------------ POSTS ------------------
final profilePostsProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  return await repo.fetchUserPosts(userId);   // 👈 Already returns List<TweetModel>
});

// ------------------ REPLIES ------------------
final profileRepliesProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  return await repo.fetchUserReplies(userId); // 👈 Already returns List<TweetModel>
});

// ------------------ LIKES ------------------
final profileLikesProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  return await repo.fetchUserLikes(userId);   // 👈 Already returns List<TweetModel>
});
