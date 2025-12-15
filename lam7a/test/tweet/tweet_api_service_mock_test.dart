import 'package:flutter_test/flutter_test.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';

class TestTweetsApiServiceMock extends TweetsApiServiceMock {
  @override
  Future<List<TweetModel>> getTweets(int limit, int page, String tweetsType) {
    return getAllTweets(limit, page);
  }

  @override
  Future<String> getTweetSummery(String tweetId) async {
    return 'summary';
  }

  @override
  Future<List<TweetModel>> getTweetsByUser(String userId) async {
    final all = await getAllTweets(100, 1);
    return all.where((t) => t.userId == userId).toList();
  }

  @override
  Future<List<TweetModel>> getRepliesByUser(String userId) async {
    return const [];
  }

  @override
  Future<List<TweetModel>> getUserLikedPosts(String userId) async {
    return getAllTweets(100, 1);
  }
}

void main() {
  group('TweetsApiServiceMock base behavior', () {
    test('getAllTweets returns all mock tweets', () async {
      final service = TestTweetsApiServiceMock();

      final tweets = await service.getAllTweets(10, 1);

      expect(tweets.length, mockTweets.length);
    });

    test('getTweetById returns specific tweet when present', () async {
      final service = TestTweetsApiServiceMock();

      final tweet = await service.getTweetById('t1');

      expect(tweet.id, 't1');
    });

    test('interaction flags and local views can be updated and read', () async {
      final service = TestTweetsApiServiceMock();

      final initialFlags = await service.getInteractionFlags('t1');
      expect(initialFlags, isNull);

      service.updateInteractionFlag('t1', 'isLikedByMe', true);

      final flags = await service.getInteractionFlags('t1');
      expect(flags, isNotNull);
      expect(flags!['isLikedByMe'], isTrue);

      expect(service.getLocalViews('t1'), isNull);
      service.setLocalViews('t1', 5);
      expect(service.getLocalViews('t1'), 5);
    });

    test('updateTweet replaces stored tweet data', () async {
      final service = TestTweetsApiServiceMock();

      final original = await service.getTweetById('t1');

      final updated = original.copyWith(body: 'Updated body');
      await service.updateTweet(updated);

      final fetched = await service.getTweetById('t1');
      expect(fetched.body, 'Updated body');
    });

    test('deleteTweet removes tweet from storage', () async {
      final service = TestTweetsApiServiceMock();

      final existsBefore = service.hasTweet('t2');
      expect(existsBefore, isTrue);

      await service.deleteTweet('t2');

      final existsAfter = service.hasTweet('t2');
      expect(existsAfter, isFalse);
    });

    test('getRepliesForPost returns empty list by default', () async {
      final service = TestTweetsApiServiceMock();

      final replies = await service.getRepliesForPost('t1');

      expect(replies, isEmpty);
    });
  });
}
