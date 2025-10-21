import 'package:lam7a/features/tweet_summary/models/tweet.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'mock_tweet_provider.g.dart';

// Dummy in-memory mock tweets
final _mockTweets = {
  't1': TweetModel(
    id: 't1',
    userId: '1',
    body: 'This is a mocked tweet about Riverpod!',
    likes: 23,
    repost: 4,
    comments: 3,
    views: 230,
    date: DateTime.now().subtract(const Duration(days: 1)),
    mediaPic: 'https://media.istockphoto.com/id/1703754111/photo/sunset-dramatic-sky-clouds.jpg?s=612x612&w=0&k=20&c=6vevvAvvqvu5MxfOC0qJuxLZXmus3hyUCfzVAy-yFPA=',
    qoutes: 777000,
    mediaVideo: null,
    bookmarks: 6000000
  ),
  't2': TweetModel(
    id: 't2',
    userId: '2',
    body: 'Mock tweet #2 — Flutter is amazing 💙',
    likes: 54,
    repost: 2,
    comments: 10,
    views: 980,
    date: DateTime.now().subtract(const Duration(hours: 5)),
    qoutes: 1000000,
    bookmarks: 5000000000
  ),
};

@riverpod
Future<TweetModel> tweetById(Ref ref, String tweetId) async {
 // await Future.delayed(const Duration(milliseconds: 600)); // simulate latency
  return _mockTweets[tweetId] ?? _mockTweets.values.first;
}
