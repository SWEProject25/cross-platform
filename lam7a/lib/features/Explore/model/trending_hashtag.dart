class TrendingHashtag {
  final String hashtag;
  final int? order;
  final String? trendCategory;
  final int? tweetsCount;

  TrendingHashtag({
    required this.hashtag,
    this.order,
    this.trendCategory,
    this.tweetsCount,
  });

  TrendingHashtag copyWith({
    String? hashtag,
    int? order,
    String? trendCategory,
    int? tweetsCount,
  }) {
    return TrendingHashtag(
      hashtag: hashtag ?? this.hashtag,
      order: order ?? this.order,
      trendCategory: trendCategory ?? this.trendCategory,
      tweetsCount: tweetsCount ?? this.tweetsCount,
    );
  }

  factory TrendingHashtag.fromJson(
    Map<String, dynamic> json, {
    String? category,
    int? order,
  }) {
    return TrendingHashtag(
      hashtag: json['tag'] as String,
      trendCategory: category,
      tweetsCount: json['totalPosts'] as int?,
      order: order,
    );
  }
}
