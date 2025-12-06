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

  factory TrendingHashtag.fromJson(Map<String, dynamic> json) {
    return TrendingHashtag(
      hashtag: json['hashtag'] as String,
      order: json['order'] as int?,
      tweetsCount: json['tweetsCount'] as int?,
    );
  }
}
