import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

@freezed
abstract class  TweetModel with _$TweetModel {
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
  factory TweetModel.empty() => TweetModel(
        id: '',
        body: '',
        date: DateTime.now()
        userId: '',
      );

  /// From JSON
  factory TweetModel.fromJson(Map<String, dynamic> json) =>
      _$TweetModelFromJson(json);
}
