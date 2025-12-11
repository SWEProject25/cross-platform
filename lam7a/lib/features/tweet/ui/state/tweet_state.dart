import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

part 'tweet_state.freezed.dart';

@freezed
abstract class TweetState with _$TweetState {
  const factory TweetState({
    required bool isLiked,
    required bool isReposted,
    required bool isViewed,
    required AsyncValue<TweetModel> tweet,

    int? likeCountUpdated,
    int? repostCountUpdated,
    int? commentCountUpdated,
  }) = _TweetState;
}
