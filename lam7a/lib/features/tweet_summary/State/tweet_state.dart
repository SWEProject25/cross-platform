import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/models/tweet.dart';


class TweetState {
  final bool isLiked;
  final bool isReposted;
  final bool isViewed;
  final AsyncValue<TweetModel> tweet;

  const TweetState({
    required this.isLiked,
    required this.isReposted,
    required this.isViewed,
    required this.tweet,
  });

  // CopyWith for immutability
  TweetState copyWith({
    bool? isLiked,
    bool? isReposted,
    bool? isViewed,
    AsyncValue<TweetModel>? tweet,
  }) {
    return TweetState(
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      isViewed: isViewed ?? this.isViewed,
      tweet: tweet ?? this.tweet,
    );
  }

  @override
  String toString() {
    return 'TweetState(isLiked: $isLiked, isReposted: $isReposted, isViewed: $isViewed, tweet: $tweet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TweetState &&
        other.isLiked == isLiked &&
        other.isReposted == isReposted &&
        other.isViewed == isViewed &&
        other.tweet == tweet;
  }

  @override
  int get hashCode {
    return isLiked.hashCode ^
        isReposted.hashCode ^
        isViewed.hashCode ^
        tweet.hashCode;
  }
}
