import 'package:freezed_annotation/freezed_annotation.dart';

part 'tweet_model.freezed.dart';
part 'tweet_model.g.dart';

@freezed
abstract class TweetModel with _$TweetModel {
  const factory TweetModel({
    required String id,
    required String body,
    String? mediaPic,
    String? mediaVideo,
    required DateTime date,
    required int likes,
    required int qoutes,
    required int bookmarks,
    required int repost,
    required int comments,
    required int views,
    required String userId,
  }) = _TweetModel;

  /// Empty factory constructor
  factory TweetModel.empty() => TweetModel(
        id: '',
        body: '',
        mediaPic: null,
        mediaVideo: null,
        date: DateTime.now(),
        likes: 0,
        qoutes: 0,
        bookmarks: 0,
        repost: 0,
        comments: 0,
        views: 0,
        userId: '',
      );

  /// From JSON
  factory TweetModel.fromJson(Map<String, dynamic> json) =>
      _$TweetModelFromJson(json);
}
