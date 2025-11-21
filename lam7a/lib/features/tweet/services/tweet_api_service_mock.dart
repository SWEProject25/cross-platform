import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';

// Dummy in-memory mock tweets with multiple media support
final _mockTweets = <String, TweetModel>{
  't1': TweetModel(
    id: 't1',
    userId: '1',
    body: 'This is a mocked tweet about Riverpod with multiple images!',
    likes: 23,
    repost: 4,
    comments: 3,
    views: 230,
    date: DateTime.now().subtract(const Duration(days: 1)),
    // Multiple images
    mediaImages: [
      'https://media.istockphoto.com/id/1703754111/photo/sunset-dramatic-sky-clouds.jpg?s=612x612&w=0&k=20&c=6vevvAvvqvu5MxfOC0qJuxLZXmus3hyUCfzVAy-yFPA=',
      'https://picsum.photos/seed/img1/800/600',
      'https://picsum.photos/seed/img2/800/600',
    ],
    mediaVideos: [],
    qoutes: 777000,
    bookmarks: 6000000,
  ),
  't2': TweetModel(
    id: 't2',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing with videos!',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    // Multiple videos
    mediaImages: [],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ],
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't3': TweetModel(
    id: "t3",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
  ),
  't4': TweetModel(
    id: 't4',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing with videos!',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    // Multiple videos
    mediaImages: [],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ],
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't5': TweetModel(
    id: "t5",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
  ),
  't6': TweetModel(
    id: 't6',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing with videos!',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    // Multiple videos
    mediaImages: [],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ],
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't7': TweetModel(
    id: "t7",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
  ),
  't8': TweetModel(
    id: 't8',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing with videos!',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    // Multiple videos
    mediaImages: [],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ],
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't9': TweetModel(
    id: "t9",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
  ),
  't10': TweetModel(
    id: 't10',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing with videos!',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    // Multiple videos
    mediaImages: [],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    ],
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't11': TweetModel(
    id: "t11",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can't control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    // Mix of images and videos
    mediaImages: [
      'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
      'https://picsum.photos/seed/nature/800/600',
    ],
    mediaVideos: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    ],
    date: DateTime.now().subtract(const Duration(days: 1)),
    likes: 999,
    comments: 8900,
    views: 5700000,
    repost: 54,
    qoutes: 9000000000,
    bookmarks: 10,
  ),
};

class TweetsApiServiceMock implements TweetsApiService {
  final Map<String, TweetModel> _tweets = Map.of(_mockTweets);
  final Map<String, Map<String, bool>> _interactionFlags = {};

  Future<void> _simulateDelay() async =>
      Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<Map<String, bool>?> getInteractionFlags(String tweetId) async {
    final flags = _interactionFlags[tweetId];
    if (flags == null) {
      return null;
    }
    await _simulateDelay();
    return flags;
  }

  @override
  void updateInteractionFlag(String tweetId, String flagName, bool value) {
    if (_interactionFlags[tweetId] == null) {
      _interactionFlags[tweetId] = {};
    }
    _interactionFlags[tweetId]![flagName] = value;
  }

  @override
  Future<List<TweetModel>> getAllTweets() async {
    // await _simulateDelay();
    return _tweets.values.toList();
  }

  @override
  Future<TweetModel> getTweetById(String id) async {
    await _simulateDelay();
    return _tweets[id] ?? _tweets.values.first;
  }

  @override
  Future<void> updateTweet(TweetModel tweet) async {
    await _simulateDelay();
    _tweets[tweet.id] = tweet;
  }

  @override
  Future<void> deleteTweet(String id) async {
    await _simulateDelay();
    _tweets.remove(id);
    print('🗑️ Tweet deleted: $id');
  }

  /// Helper method to get all tweet IDs (for debugging)
  List<String> getAllTweetIds() {
    return _tweets.keys.toList();
  }

  /// Helper method to check if a tweet exists
  bool hasTweet(String id) {
    return _tweets.containsKey(id);
  }
}
