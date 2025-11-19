class TrendingHashtag {
  final String hashtag;
  final int? order;
  final int? tweetsCount;

  TrendingHashtag({required this.hashtag, this.order, this.tweetsCount});

  TrendingHashtag copyWith({String? hashtag, int? order, int? tweetsCount}) {
    return TrendingHashtag(
      hashtag: hashtag ?? this.hashtag,
      order: order ?? this.order,
      tweetsCount: tweetsCount ?? this.tweetsCount,
    );
  }
}
