import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/profile/utils/profile_tweet_mapper.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

void main() {
  group('read<T>()', () {
    test('returns first non-null key value', () {
      final json = {
        'a': null,
        'b': 5,
        'c': 10,
      };

      final result = read<int>(json, ['a', 'b', 'c']);
      expect(result, 5);
    });

    test('returns null when all keys are missing or null', () {
      final json = {'a': null};

      final result = read<String>(json, ['x', 'y']);
      expect(result, isNull);
    });
  });

  group('convertProfileJsonToTweetModel', () {
    test('maps normal tweet correctly', () {
      final json = {
        'postId': 1,
        'userId': 2,
        'username': 'user',
        'name': 'User Name',
        'text': 'Hello world',
        'likesCount': 3,
        'retweetsCount': 1,
        'commentsCount': 2,
        'date': '2024-01-01T12:00:00Z',
      };

      final tweet = convertProfileJsonToTweetModel(json);

      expect(tweet, isA<TweetModel>());
      expect(tweet.id, '1');
      expect(tweet.userId, '2');
      expect(tweet.body, 'Hello world');
      expect(tweet.likes, 3);
      expect(tweet.repost, 1);
      expect(tweet.comments, 2);
      expect(tweet.isRepost, false);
      expect(tweet.isQuote, false);
    });

    test('maps repost tweet correctly', () {
      final json = {
        'postId': 100,
        'userId': 1,
        'username': 'reposter',
        'name': 'Reposter',
        'date': '2024-01-02T10:00:00Z',
        'isRepost': true,
        'originalPostData': {
          'postId': 50,
          'userId': 9,
          'username': 'original',
          'name': 'Original User',
          'text': 'Original tweet',
          'likesCount': 10,
          'retweetsCount': 5,
          'commentsCount': 3,
          'date': '2024-01-01T09:00:00Z',
        },
      };

      final tweet = convertProfileJsonToTweetModel(json);

      expect(tweet.isRepost, true);
      expect(tweet.originalTweet, isNotNull);
      expect(tweet.body, 'Original tweet');
      expect(tweet.originalTweet!.username, 'original');
    });

    test('maps quote tweet correctly', () {
      final json = {
        'postId': 200,
        'userId': 3,
        'username': 'quoter',
        'name': 'Quoter',
        'text': 'My opinion',
        'likesCount': 1,
        'retweetsCount': 0,
        'commentsCount': 0,
        'date': '2024-01-03T11:00:00Z',
        'isQuote': true,
        'originalPostData': {
          'postId': 80,
          'userId': 7,
          'username': 'parent',
          'name': 'Parent User',
          'text': 'Parent tweet',
          'likesCount': 20,
          'retweetsCount': 2,
          'commentsCount': 4,
          'date': '2024-01-02T08:00:00Z',
        },
      };

      final tweet = convertProfileJsonToTweetModel(json);

      expect(tweet.isQuote, true);
      expect(tweet.originalTweet, isNotNull);
      expect(tweet.body, 'My opinion');
      expect(tweet.originalTweet!.body, 'Parent tweet');
    });
  });
}
