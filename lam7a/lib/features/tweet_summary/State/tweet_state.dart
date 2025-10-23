import 'package:lam7a/features/models/tweet.dart';

class TweetState {
  final TweetModel tweet;
  final bool isLiked;
  final bool isReposted;
  final bool isViewed;

  const TweetState({
    required this.tweet,
    this.isLiked = false,
    this.isReposted = false,
    this.isViewed = false,
  });

  TweetState copyWith({
    TweetModel? tweet,
    bool? isLiked,
    bool? isReposted,
    bool? isViewed,
  }) {
    return TweetState(
      tweet: tweet ?? this.tweet,
      isLiked: isLiked ?? this.isLiked,
      isReposted: isReposted ?? this.isReposted,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}

