import 'package:lam7a/features/common/models/tweet_model.dart';

T? read<T>(Map json, List<String> keys) {
  for (final k in keys) {
    if (json[k] != null) return json[k] as T;
  }
  return null;
}

List<String> _extractImages(Map<String, dynamic> json) {
  final media = json['media'];
  if (media == null || media is! List) return <String>[];

  final images = <String>[];
  for (final item in media) {
    if (item == null) continue;
    if (item is String) {
      images.add(item);
      continue;
    }
    if (item is Map) {
      final type = (item['type'] ?? item['mediaType'])
          ?.toString()
          .toUpperCase();
      final url = (item['url'] ?? item['media_url'] ?? item['mediaUrl'])
          ?.toString();
      if (url == null || url.isEmpty) continue;
      if (type != 'VIDEO') images.add(url);
    }
  }
  return images;
}

List<String> _extractVideos(Map<String, dynamic> json) {
  final media = json['media'];
  if (media == null || media is! List) return <String>[];

  final videos = <String>[];
  for (final item in media) {
    if (item == null) continue;
    if (item is String) {
      final lower = item.toLowerCase();
      if (lower.endsWith('.mp4') || lower.contains('video')) videos.add(item);
      continue;
    }
    if (item is Map) {
      final type = (item['type'] ?? item['mediaType'])
          ?.toString()
          .toUpperCase();
      final url = (item['url'] ?? item['media_url'] ?? item['mediaUrl'])
          ?.toString();
      if (url == null || url.isEmpty) continue;
      if (type == 'VIDEO' || url.toLowerCase().contains('mp4')) videos.add(url);
    }
  }
  return videos;
}

TweetModel convertProfileJsonToTweetModel(Map<String, dynamic> json) {
  if (json.containsKey('postId') && json.containsKey('date')) {
    try {
      return TweetModel.fromJsonPosts(json);
    } catch (_) {}
  }

  final bool isRepost = json["isRepost"] == true;
  final bool isQuote = json["isQuote"] == true;
  final original = json["originalPostData"];

  // REPOST
  if (isRepost && original is Map<String, dynamic>) {
    final merged = <String, dynamic>{
      ...Map<String, dynamic>.from(original),
    };

    if (json['userId'] != null) merged['userId'] = json['userId'];
    if (json['username'] != null) merged['username'] = json['username'];
    if (json['name'] != null) merged['name'] = json['name'];
    if (json['avatar'] != null) merged['avatar'] = json['avatar'];
    if (json['date'] != null) merged['date'] = json['date'];

    merged['isRepost'] = true;
    merged['originalPostData'] = Map<String, dynamic>.from(original);

    try {
      return TweetModel.fromJsonPosts(merged);
    } catch (_) {}

    final inner = Map<String, dynamic>.from(original);

    final originalTweet = TweetModel(
      id: inner['postId'].toString(),
      userId: inner['userId'].toString(),
      username: inner['username'],
      authorName: inner['name'],
      authorProfileImage: inner['avatar'],
      body: inner['text'] ?? '',
      date: DateTime.parse(inner['date']),
      likes: inner['likesCount'] ?? 0,
      repost: inner['retweetsCount'] ?? 0,
      comments: inner['commentsCount'] ?? 0,
      mediaImages: _extractImages(inner),
      mediaVideos: _extractVideos(inner),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: json['postId'].toString(),
      userId: json['userId'].toString(),
      username: json['username'],
      authorName: json['name'],
      authorProfileImage: json['avatar'],
      body: originalTweet.body,
      date: DateTime.parse(json['date']),
      likes: originalTweet.likes,
      repost: originalTweet.repost,
      comments: originalTweet.comments,
      isRepost: true,
      isQuote: false,
      mediaImages: originalTweet.mediaImages,
      mediaVideos: originalTweet.mediaVideos,
      originalTweet: originalTweet,
    );
  }

  // QUOTE
  if (isQuote && original is Map<String, dynamic>) {
    final parent = Map<String, dynamic>.from(original);

    final parentTweet = TweetModel(
      id: parent['postId'].toString(),
      userId: parent['userId'].toString(),
      username: parent['username'],
      authorName: parent['name'],
      authorProfileImage: parent['avatar'],
      body: parent['text'] ?? '',
      date: DateTime.parse(parent['date']),
      likes: parent['likesCount'] ?? 0,
      repost: parent['retweetsCount'] ?? 0,
      comments: parent['commentsCount'] ?? 0,
      mediaImages: _extractImages(parent),
      mediaVideos: _extractVideos(parent),
      isRepost: false,
      isQuote: false,
    );

    return TweetModel(
      id: json['postId'].toString(),
      userId: json['userId'].toString(),
      username: json['username'],
      authorName: json['name'],
      authorProfileImage: json['avatar'],
      body: json['text'] ?? '',
      date: DateTime.parse(json['date']),
      likes: json['likesCount'] ?? 0,
      repost: json['retweetsCount'] ?? 0,
      comments: json['commentsCount'] ?? 0,
      isRepost: false,
      isQuote: true,
      mediaImages: _extractImages(json),
      mediaVideos: _extractVideos(json),
      originalTweet: parentTweet,
    );
  }

  // NORMAL
  return TweetModel(
    id: json['postId']?.toString() ?? json['id']?.toString() ?? '',
    userId: json['userId']?.toString() ?? '',
    username: json['username'] ?? '',
    authorName: json['name'] ?? '',
    authorProfileImage: json['avatar'],
    body: json['text'] ?? '',
    date: DateTime.parse(json['date']),
    likes: json['likesCount'] ?? 0,
    repost: json['retweetsCount'] ?? 0,
    comments: json['commentsCount'] ?? 0,
    isRepost: false,
    isQuote: false,
    mediaImages: _extractImages(json),
    mediaVideos: _extractVideos(json),
  );
}
