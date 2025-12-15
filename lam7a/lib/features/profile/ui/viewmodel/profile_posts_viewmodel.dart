// feature/profile/ui/viewmodel/profile_posts_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';

T? read<T>(Map json, List<String> keys) {
  for (final k in keys) {
    if (json[k] != null) return json[k] as T;
  }
  return null;
}

/// Converts ANY kind of profile JSON into a proper TweetModel
TweetModel convertProfileJsonToTweetModel(Map<String, dynamic> json) {
  final bool isRepost = json["isRepost"] == true;
  final bool isQuote = json["isQuote"] == true;

  final original = json["originalPostData"];

  // -------------------------------------------------------------------
  // CASE 1: REPOST
  // -------------------------------------------------------------------
  if (isRepost && original is Map<String, dynamic>) {
    final inner = original;

    final originalTweet = TweetModel(
      id: read(inner, ["postId"])!.toString(),
      userId: read(inner, ["userId"])!.toString(),
      username: read(inner, ["username"]) ?? "Unknown",
      authorName: read(inner, ["name"]) ?? "",
      authorProfileImage: read(inner, ["avatar"]),
      body: inner["text"] ?? "",
      likes: inner["likesCount"] ?? 0,
      repost: inner["retweetsCount"] ?? 0,
      comments: inner["commentsCount"] ?? 0,
      date: DateTime.parse(
        read(inner, ["date", "createdAt"]) ?? DateTime.now().toIso8601String(),
      ),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: read(json, ["post_id", "postId"])!.toString(),
      userId: read(json, ["user_id", "userId"])!.toString(),
      username: read(json, ["username"]) ?? "",
      authorName: read(json, ["name"]) ?? "",
      authorProfileImage: read(json, ["avatar"]),
      body: originalTweet.body,
      likes: originalTweet.likes,
      repost: originalTweet.repost,
      comments: originalTweet.comments,
      date: DateTime.parse(
        read(json, ["created_at", "createdAt"]) ??
            DateTime.now().toIso8601String(),
      ),
      isRepost: true,
      originalTweet: originalTweet,
    );
  }

  // -------------------------------------------------------------------
  // CASE 2: QUOTE TWEET
  // -------------------------------------------------------------------
  if (isQuote && original is Map<String, dynamic>) {
    final parent = original;

    final parentTweet = TweetModel(
      id: read(parent, ["postId"])!.toString(),
      userId: read(parent, ["userId"])!.toString(),
      username: read(parent, ["username"]) ?? "",
      authorName: read(parent, ["name"]) ?? "",
      authorProfileImage: read(parent, ["avatar"]),
      body: parent["text"] ?? "",
      likes: parent["likesCount"] ?? 0,
      repost: parent["retweetsCount"] ?? 0,
      comments: parent["commentsCount"] ?? 0,
      date: DateTime.parse(
        read(parent, ["date", "createdAt"]) ??
            DateTime.now().toIso8601String(),
      ),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: read(json, ["post_id", "postId"])!.toString(),
      userId: read(json, ["user_id", "userId"])!.toString(),
      username: read(json, ["username"]) ?? "",
      authorName: read(json, ["name"]) ?? "",
      authorProfileImage: read(json, ["avatar"]),
      body: json["text"] ?? "",
      likes: json["likesCount"] ?? 0,
      repost: json["retweetsCount"] ?? 0,
      comments: json["commentsCount"] ?? 0,
      date: DateTime.parse(
        read(json, ["date", "createdAt"]) ??
            DateTime.now().toIso8601String(),
      ),
      isRepost: false,
      isQuote: true,
      originalTweet: parentTweet,
    );
  }

  // -------------------------------------------------------------------
  // CASE 3: NORMAL POST or REPLY
  // -------------------------------------------------------------------
  return TweetModel(
    id: read(json, ["post_id", "postId", "id"])!.toString(),
    userId: read(json, ["user_id", "userId"])!.toString(),
    username: read(json, ["username"]) ?? "",
    authorName: read(json, ["name"]) ?? "",
    authorProfileImage: read(json, ["avatar"]),
    body: read(json, ["text", "content"]) ?? "",
    likes: json["likesCount"] ?? 0,
    repost: json["retweetsCount"] ?? 0,
    comments: json["commentsCount"] ?? 0,
    date: DateTime.parse(
      read(json, ["date", "createdAt", "created_at"]) ??
          DateTime.now().toIso8601String(),
    ),
    isRepost: false,
    isQuote: false,
  );
}

// ---------------------------------------------------------------------
// PROVIDERS
// ---------------------------------------------------------------------

final profilePostsProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  return repo.fetchUserPosts(userId);
});

final profileRepliesProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  return repo.fetchUserReplies(userId);
});


final profileLikesProvider =
    FutureProvider.family<List<TweetModel>, String>((ref, userId) async {
  final repo = ref.read(tweetRepositoryProvider);
  final tweets = await repo.fetchUserLikes(userId);

  // FILTER
  return tweets.where((tweet) {
    final state = ref.read(tweetViewModelProvider(tweet.id)).value;
    return state?.isLiked != false;
  }).toList();
});
