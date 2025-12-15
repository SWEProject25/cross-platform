import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/user_new_tweets_viewmodel.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('UserNewTweetsViewModel Tests', () {
    test('Initial state is empty', () {
      final state = container.read(userNewTweetsViewModelProvider);
      expect(state, isEmpty);
    });

    test('addTweet adds new tweet to the top', () {
      final notifier = container.read(userNewTweetsViewModelProvider.notifier);
      final tweet1 = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      final tweet2 = TweetModel(id: '2', userId: '1', body: 'Tweet 2', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);

      notifier.addTweet(tweet1);
      expect(container.read(userNewTweetsViewModelProvider), [tweet1]);

      notifier.addTweet(tweet2);
      final state = container.read(userNewTweetsViewModelProvider);
      expect(state.length, 2);
      expect(state.first, tweet2);
      expect(state.last, tweet1);
    });

    test('addTweet updates existing tweet', () {
      final notifier = container.read(userNewTweetsViewModelProvider.notifier);
      final tweet1 = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      final tweet1Updated = tweet1.copyWith(body: 'Tweet 1 Updated');

      notifier.addTweet(tweet1);
      notifier.addTweet(tweet1Updated);

      final state = container.read(userNewTweetsViewModelProvider);
      expect(state.length, 1);
      expect(state.first.body, 'Tweet 1 Updated');
    });

    test('removeTweet removes tweet by id', () {
      final notifier = container.read(userNewTweetsViewModelProvider.notifier);
      final tweet1 = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      
      notifier.addTweet(tweet1);
      notifier.removeTweet('1');

      expect(container.read(userNewTweetsViewModelProvider), isEmpty);
    });

     test('removeTweet does nothing if id not found', () {
      final notifier = container.read(userNewTweetsViewModelProvider.notifier);
      final tweet1 = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      
      notifier.addTweet(tweet1);
      notifier.removeTweet('999');

      expect(container.read(userNewTweetsViewModelProvider), [tweet1]);
    });

    test('clear resets state', () {
      final notifier = container.read(userNewTweetsViewModelProvider.notifier);
      final tweet1 = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      
      notifier.addTweet(tweet1);
      notifier.clear();

      expect(container.read(userNewTweetsViewModelProvider), isEmpty);
    });
  });
}
