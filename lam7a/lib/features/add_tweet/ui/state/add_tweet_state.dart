import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_tweet_state.freezed.dart';

@freezed
abstract class AddTweetState with _$AddTweetState {
  const factory AddTweetState({
    @Default("") String body,
    @Default(false) bool isValidBody,
    @Default(false) bool isLoading,
    String? mediaPicPath,
    String? mediaVideoPath,
    String? errorMessage,
    @Default(false) bool isTweetPosted,
    int? parentPostId,
    @Default('POST') String postType,
  }) = _AddTweetState;
}
