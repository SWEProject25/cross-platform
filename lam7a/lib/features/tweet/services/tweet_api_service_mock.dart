import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';


// Dummy in-memory mock tweets
final _mockTweets = <String, TweetModel>{
  't1': TweetModel(
    id: 't1',
    userId: '1',
    body: 'This is a mocked tweet about Riverpod!',
    likes: 23,
    repost: 4,
    comments: 3,
    views: 230,
    date: DateTime.now().subtract(const Duration(days: 1)),
    mediaPic:
        'https://media.istockphoto.com/id/1703754111/photo/sunset-dramatic-sky-clouds.jpg?s=612x612&w=0&k=20&c=6vevvAvvqvu5MxfOC0qJuxLZXmus3hyUCfzVAy-yFPA=',
    qoutes: 777000,
    mediaVideo: null,
    bookmarks: 6000000,
  ),
  't2': TweetModel(
    id: 't2',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing ',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    qoutes: 1000000,
    bookmarks: 5000000000,
  ),
  't3': TweetModel(
    id: "t3",
    userId: "1",
    body:
        "Hi This Is The Tweet Body\nHappiness comes from within. Focus on gratitude, surround yourself with kind people, and do what brings meaning. Accept what you can’t control, forgive easily, and celebrate small wins. Stay present, care for your body and mind, and spread kindness daily.",
    mediaPic:
        'https://tse4.mm.bing.net/th/id/OIP.u7kslI7potNthBAIm93JDwHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3',
    mediaVideo:
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
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

  Future<void> _simulateDelay() async =>
      Future.delayed(const Duration(milliseconds: 300));

  @override
  Future<List<TweetModel>> getAllTweets() async {
    await _simulateDelay();
    return _tweets.values.toList();
  }

  @override
  Future<TweetModel> getTweetById(String id) async {
    await _simulateDelay();
    return _tweets[id] ?? _tweets.values.first;
  }

  @override
  Future<void> addTweet(TweetModel tweet) async {
    await _simulateDelay();
    _tweets[tweet.id] = tweet;
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
  }
}

