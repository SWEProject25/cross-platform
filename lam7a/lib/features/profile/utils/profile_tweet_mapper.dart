import 'package:lam7a/features/common/models/tweet_model.dart';

T? read<T>(Map json, List<String> keys) {
  for (final k in keys) {
    if (json[k] != null) return json[k] as T;
  }
  return null;
}

TweetModel convertProfileJsonToTweetModel(Map<String, dynamic> json) {
  final bool isRepost = json["isRepost"] == true;
  final bool isQuote = json["isQuote"] == true;
  final original = json["originalPostData"];

  // REPOST
  if (isRepost && original is Map<String, dynamic>) {
    final inner = original;

    final originalTweet = TweetModel(
      id: read(inner, ["postId"])!.toString(),
      userId: read(inner, ["userId"])!.toString(),
      username: read(inner, ["username"]) ?? "",
      authorName: read(inner, ["name"]) ?? "",
      authorProfileImage: read(inner, ["avatar"]),
      body: inner["text"] ?? "",
      likes: inner["likesCount"] ?? 0,
      repost: inner["retweetsCount"] ?? 0,
      comments: inner["commentsCount"] ?? 0,
      date: DateTime.parse(read(inner, ["date"])!),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: read(json, ["postId"])!.toString(),
      userId: read(json, ["userId"])!.toString(),
      username: read(json, ["username"]) ?? "",
      authorName: read(json, ["name"]) ?? "",
      authorProfileImage: read(json, ["avatar"]),
      body: originalTweet.body,
      likes: originalTweet.likes,
      repost: originalTweet.repost,
      comments: originalTweet.comments,
      date: DateTime.parse(read(json, ["date"])!),
      isRepost: true,
      originalTweet: originalTweet,
    );
  }

  // QUOTE
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
      date: DateTime.parse(read(parent, ["date"])!),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: read(json, ["postId"])!.toString(),
      userId: read(json, ["userId"])!.toString(),
      username: read(json, ["username"]) ?? "",
      authorName: read(json, ["name"]) ?? "",
      authorProfileImage: read(json, ["avatar"]),
      body: json["text"] ?? "",
      likes: json["likesCount"] ?? 0,
      repost: json["retweetsCount"] ?? 0,
      comments: json["commentsCount"] ?? 0,
      date: DateTime.parse(read(json, ["date"])!),
      isQuote: true,
      originalTweet: parentTweet,
    );
  }

  // NORMAL
  return TweetModel(
    id: read(json, ["postId", "id"])!.toString(),
    userId: read(json, ["userId"])!.toString(),
    username: read(json, ["username"]) ?? "",
    authorName: read(json, ["name"]) ?? "",
    authorProfileImage: read(json, ["avatar"]),
    body: json["text"] ?? "",
    likes: json["likesCount"] ?? 0,
    repost: json["retweetsCount"] ?? 0,
    comments: json["commentsCount"] ?? 0,
    date: DateTime.parse(read(json, ["date"])!),
    isRepost: false,
    isQuote: false,
  );
}
