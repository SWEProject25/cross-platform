import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class MockTweetsApiService extends Mock implements TweetsApiService {}

void main() {
  late MockTweetsApiService mockApi;
  late TweetRepository repository;

  setUp(() {
    mockApi = MockTweetsApiService();
    repository = TweetRepository(mockApi);
  });

  group('TweetRepository', () {
    test('fetchAllTweets delegates to getAllTweets', () async {
      final tweets = [
        TweetModel(
          id: '1',
          userId: '1',
          body: 't1',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: const [],
          mediaVideos: const [],
        ),
      ];

      when(() => mockApi.getAllTweets(10, 1)).thenAnswer((_) async => tweets);

      final result = await repository.fetchAllTweets(10, 1);

      expect(result, tweets);
      verify(() => mockApi.getAllTweets(10, 1)).called(1);
    });

    test('fetchTweets delegates to getTweets', () async {
      when(() => mockApi.getTweets(5, 2, 'for-you'))
          .thenAnswer((_) async => const []);

      final result = await repository.fetchTweets(5, 2, 'for-you');

      expect(result, isEmpty);
      verify(() => mockApi.getTweets(5, 2, 'for-you')).called(1);
    });

    test('fetchTweetById delegates to getTweetById', () async {
      final tweet = TweetModel(
        id: '42',
        userId: '1',
        body: 'answer',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      when(() => mockApi.getTweetById('42')).thenAnswer((_) async => tweet);

      final result = await repository.fetchTweetById('42');

      expect(result, tweet);
      verify(() => mockApi.getTweetById('42')).called(1);
    });

    test('updateTweet delegates to updateTweet', () async {
      final tweet = TweetModel(
        id: '1',
        userId: '1',
        body: 'update',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      when(() => mockApi.updateTweet(tweet)).thenAnswer((_) async {});

      await repository.updateTweet(tweet);

      verify(() => mockApi.updateTweet(tweet)).called(1);
    });

    test('deleteTweet delegates to deleteTweet', () async {
      when(() => mockApi.deleteTweet('1')).thenAnswer((_) async {});

      await repository.deleteTweet('1');

      verify(() => mockApi.deleteTweet('1')).called(1);
    });

    test('fetchUserPosts delegates to getTweetsByUser', () async {
      when(() => mockApi.getTweetsByUser('10')).thenAnswer((_) async => const []);

      final result = await repository.fetchUserPosts('10');

      expect(result, isEmpty);
      verify(() => mockApi.getTweetsByUser('10')).called(1);
    });

    test('fetchUserReplies delegates to getRepliesByUser', () async {
      when(() => mockApi.getRepliesByUser('10')).thenAnswer((_) async => const []);

      final result = await repository.fetchUserReplies('10');

      expect(result, isEmpty);
      verify(() => mockApi.getRepliesByUser('10')).called(1);
    });

    test('fetchUserLikes delegates to getUserLikedPosts', () async {
      when(() => mockApi.getUserLikedPosts('10'))
          .thenAnswer((_) async => const []);

      final result = await repository.fetchUserLikes('10');

      expect(result, isEmpty);
      verify(() => mockApi.getUserLikedPosts('10')).called(1);
    });

    test('getTweetSummery delegates to getTweetSummery', () async {
      when(() => mockApi.getTweetSummery('55'))
          .thenAnswer((_) async => 'summary');

      final result = await repository.getTweetSummery('55');

      expect(result, 'summary');
      verify(() => mockApi.getTweetSummery('55')).called(1);
    });
  });
}
