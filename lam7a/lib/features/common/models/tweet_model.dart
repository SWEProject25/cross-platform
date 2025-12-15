import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

List<String> parseMedia(dynamic media) {
  if (media == null) return [];

  if (media is List) {
    return media
        .map<String>((item) {
          if (item is String) return item;

          if (item is Map) return item['url'] ?? "";

          return "";
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return [];
}

@freezed
abstract class TweetModel with _$TweetModel {
  const factory TweetModel({
    required String id,
    required String body,
    String? mediaPic, // Keep for backward compatibility
    String? mediaVideo, // Keep for backward compatibility
    @Default([]) List<String> mediaImages, // Multiple images support
    @Default([]) List<String> mediaVideos, // Multiple videos support
    required DateTime date,
    @Default(0) int likes,
    @Default(0) int qoutes,
    @Default(0) int bookmarks,
    @Default(0) int repost,
    @Default(0) int comments,
    @Default(0) int views,
    required String userId,
    // User information from backend
    String? username,
    String? authorName,
    String? authorProfileImage,
    @Default(false) bool isRepost,
    @Default(false) bool isQuote,
    TweetModel? originalTweet,
  }) = _TweetModel;

  /// Empty factory constructor
  factory TweetModel.empty() =>
      TweetModel(id: '', body: '', date: DateTime.now(), userId: '');

  /// From JSON
  factory TweetModel.fromJson(Map<String, dynamic> json) =>
      _$TweetModelFromJson(json);

  factory TweetModel.fromJsonPosts(Map<String, dynamic> json) {
    final isRepost = json['isRepost'] ?? false;
    final isQuote = json['isQuote'] ?? false;

    // nested original post
    final originalJson = json['originalPostData'];
    TweetModel? originalTweet;

    // Backend now returns originalPostData for reposts, quotes and replies.
    // Whenever a non-deleted originalPostData object is present, recursively
    // map it into originalTweet so we can render hierarchical trees
    // (repost of repost, replies to replies, quotes of quotes, etc.).
    if (originalJson is Map<String, dynamic>) {
      // Some responses may send a lightweight "deleted" marker instead of
      // a full post object. In that case we skip creating an originalTweet.
      if (originalJson['isDeleted'] != true) {
        originalTweet = TweetModel.fromJsonPosts(originalJson);
      }
    }

    // Backend returns media as an array of objects: [{ url, type }, ...].
    // Reuse parseMedia for image-like entries and filter VIDEO into
    // mediaVideos so timelines and detail views can render playable videos.
    final dynamic media = json['media'];
    final List<String> mediaImages;
    final List<String> mediaVideos = [];

    if (media is List) {
      final images = <String>[];
      for (final item in media) {
        if (item == null) continue;
        if (item is String) {
          // Treat bare strings as images by default
          images.add(item);
          continue;
        }
        if (item is Map) {
          final url = (item['url'] ?? item['media_url'] ?? item['mediaUrl'])
              ?.toString();
          if (url == null || url.isEmpty) continue;
          final type = (item['type'] ?? item['mediaType'])
              ?.toString()
              .toUpperCase();
          if (type == 'VIDEO') {
            mediaVideos.add(url);
          } else {
            images.add(url);
          }
        }
      }
      mediaImages = images;
    } else {
      mediaImages = parseMedia(media);
    }

    return TweetModel(
      id: json['postId'].toString(),
      body: json['text'] ?? '',
      mediaImages: mediaImages,
      mediaVideos: mediaVideos,

      date: DateTime.parse(json['date']),
      likes: json['likesCount'] ?? 0,
      qoutes: json['commentsCount'] ?? 0,
      repost: json['retweetsCount'] ?? 0,
      comments: json['commentsCount'] ?? 0,

      userId: json['userId'].toString(),
      username: json['username'],
      authorName: json['name'],
      authorProfileImage: json['avatar'],

      isRepost: isRepost,
      isQuote: isQuote,
      originalTweet: originalTweet,
    );
  }
}
