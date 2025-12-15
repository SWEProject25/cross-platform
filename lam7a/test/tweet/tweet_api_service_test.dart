import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_impl.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/api/api_config.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late TweetsApiServiceImpl service;
  late MockApiService mockApiService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockApiService = MockApiService();
    service = TweetsApiServiceImpl(apiService: mockApiService);
  });

  group('TweetsApiServiceImpl Tests', () {
    test('getAllTweets fetches and parses tweets correctly', () async {
      // Arrange
      final responseData = {
        'status': 'success',
        'data': {
          'posts': [
            {
              'postId': '1',
              'userId': 1,
              'text': 'Tweet 1',
              'date': DateTime.now().toIso8601String(),
              'likesCount': 10,
              'retweetsCount': 5,
              'commentsCount': 2,
              'media': []
            },
            {
              'postId': '2',
              'userId': 2,
              'text': 'Tweet 2',
              'date': DateTime.now().toIso8601String(),
              'likesCount': 0,
              'retweetsCount': 0,
              'commentsCount': 0,
              'media': []
            }
          ]
        }
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => responseData);

      // Act
      final tweets = await service.getAllTweets(10, 1);

      // Assert
      expect(tweets.length, 2);
      expect(tweets[0].body, 'Tweet 1');
      expect(tweets[1].body, 'Tweet 2');

      verify(() => mockApiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/timeline/for-you',
        queryParameters: {'limit': 10, 'page': 1},
      )).called(1);
    });

    test('getRepliesForPost fetches replies', () async {
      final responseData = {
        'status': 'success',
        'data': [
             {
              'postId': '3',
              'userId': 3,
              'text': 'Reply 1',
              'date': DateTime.now().toIso8601String(),
              'likesCount': 1,
              'retweetsCount': 0,
              'commentsCount': 0,
            }
        ]
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        queryParameters: any(named: 'queryParameters'),
      )).thenAnswer((_) async => responseData);

      final replies = await service.getRepliesForPost('1');

      expect(replies.length, 1);
      expect(replies.first.body, 'Reply 1');

      verify(() => mockApiService.get<Map<String, dynamic>>(
        endpoint: '${ApiConfig.postsEndpoint}/1/replies',
        queryParameters: {'page': 1, 'limit': 50},
      )).called(1);
    });

    test('getInteractionFlags loads stored flags and returns null when absent',
        () async {
      final flags = await service.getInteractionFlags('123');

      expect(flags, isNull);
    });

    test(
        'updateInteractionFlag updates in-memory flags and local views can be set/read',
        () async {
      await service.getInteractionFlags('init');

      service.updateInteractionFlag('123', 'isLikedByMe', true);

      final flags = await service.getInteractionFlags('123');
      expect(flags, isNotNull);
      expect(flags!['isLikedByMe'], isTrue);

      expect(service.getLocalViews('123'), isNull);
      service.setLocalViews('123', 42);
      expect(service.getLocalViews('123'), 42);
    });

    test('getInteractionFlags loads flags and views from SharedPreferences',
        () async {
      final storedFlags = {
        'abc': {'isLikedByMe': true, 'isRepostedByMe': false},
      };
      final storedViews = {
        'abc': 7,
      };

      SharedPreferences.setMockInitialValues({
        'tweet_interaction_flags': jsonEncode(storedFlags),
        'tweet_views_overrides': jsonEncode(storedViews),
      });

      mockApiService = MockApiService();
      service = TweetsApiServiceImpl(apiService: mockApiService);

      final flags = await service.getInteractionFlags('abc');

      expect(flags, isNotNull);
      expect(flags!['isLikedByMe'], isTrue);
      expect(flags['isRepostedByMe'], isFalse);
      expect(service.getLocalViews('abc'), 7);
    });

    test('getTweets fetches timeline for given tweetsType', () async {
      final responseData = {
        'status': 'success',
        'data': {
          'posts': [
            {
              'postId': '1',
              'userId': 1,
              'text': 'Tweet 1',
              'date': DateTime.now().toIso8601String(),
              'likesCount': 10,
              'retweetsCount': 5,
              'commentsCount': 2,
              'media': []
            },
            {
              'postId': '2',
              'userId': 2,
              'text': 'Tweet 2',
              'date': DateTime.now().toIso8601String(),
              'likesCount': 0,
              'retweetsCount': 0,
              'commentsCount': 0,
              'media': []
            }
          ]
        }
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '/posts/timeline/following',
            queryParameters: {'limit': 5, 'page': 2},
          )).thenAnswer((_) async => responseData);

      final tweets = await service.getTweets(5, 2, 'following');

      expect(tweets.length, 2);
      expect(tweets[0].body, 'Tweet 1');
      expect(tweets[1].body, 'Tweet 2');

      verify(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '/posts/timeline/following',
            queryParameters: {'limit': 5, 'page': 2},
          )).called(1);
    });

    test('getTweetSummery calls summary endpoint and returns data string',
        () async {
      final responseData = <String, dynamic>{
        'data': 'short summary',
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '/posts/summary/123',
          )).thenAnswer((_) async => responseData);

      final summary = await service.getTweetSummery('123');

      expect(summary, 'short summary');

      verify(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '/posts/summary/123',
          )).called(1);
    });

    test('getTweetsByUser maps profile posts', () async {
      final now = DateTime.now().toIso8601String();
      final responseData = {
        'data': [
          {
            'postId': '1',
            'userId': 1,
            'username': 'user1',
            'name': 'User 1',
            'avatar': 'avatar.png',
            'text': 'Profile tweet',
            'date': now,
            'likesCount': 1,
            'retweetsCount': 2,
            'commentsCount': 3,
            'media': [],
          },
        ],
      };

      when(() => mockApiService.get(
            endpoint: '/posts/profile/42',
          )).thenAnswer((_) async => responseData);

      final tweets = await service.getTweetsByUser('42');

      expect(tweets.length, 1);
      expect(tweets.first.body, 'Profile tweet');
      expect(tweets.first.username, 'user1');

      verify(() => mockApiService.get(
            endpoint: '/posts/profile/42',
          )).called(1);
    });

    test('getRepliesByUser maps profile replies', () async {
      final now = DateTime.now().toIso8601String();
      final responseData = {
        'data': [
          {
            'postId': '2',
            'userId': 2,
            'username': 'user2',
            'name': 'User 2',
            'avatar': 'avatar2.png',
            'text': 'Reply from profile',
            'date': now,
            'likesCount': 0,
            'retweetsCount': 0,
            'commentsCount': 1,
            'media': [],
          },
        ],
      };

      when(() => mockApiService.get(
            endpoint: '/posts/profile/42/replies',
          )).thenAnswer((_) async => responseData);

      final replies = await service.getRepliesByUser('42');

      expect(replies.length, 1);
      expect(replies.first.body, 'Reply from profile');
      expect(replies.first.username, 'user2');

      verify(() => mockApiService.get(
            endpoint: '/posts/profile/42/replies',
          )).called(1);
    });

    test('getUserLikedPosts re-fetches posts via getTweetById', () async {
      final likedResponse = {
        'data': [
          {'postId': '99'},
        ],
      };

      final now = DateTime.now().toIso8601String();
      final postResponse = {
        'data': {
          'postId': '99',
          'userId': 10,
          'text': 'Liked tweet',
          'date': now,
          'likesCount': 5,
          'retweetsCount': 0,
          'commentsCount': 0,
          'media': [],
        },
      };

      when(() => mockApiService.get(
            endpoint: '/posts/liked/7',
          )).thenAnswer((_) async => likedResponse);

      when(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/99',
          )).thenAnswer((_) async => postResponse);

      final liked = await service.getUserLikedPosts('7');

      expect(liked.length, 1);
      expect(liked.first.body, 'Liked tweet');

      verify(() => mockApiService.get(
            endpoint: '/posts/liked/7',
          )).called(1);

      verify(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/99',
          )).called(1);
    });

    test('getTweetById maps legacy flat post with media array', () async {
      final now = DateTime.now().toIso8601String();
      final responseData = <String, dynamic>{
        'data': {
          'id': '123',
          'userId': 5,
          'username': 'legacy',
          'name': 'Legacy User',
          'avatar': 'avatar.png',
          'text': 'Legacy tweet',
          'createdAt': now,
          '_count': {
            'likes': 2,
            'repostedBy': 3,
            'Replies': 4,
          },
          'likes': 10,
          'repost': 20,
          'comments': 30,
          'viewsCount': 40,
          'qoutes': 50,
          'bookmarks': 60,
          'media': [
            {
              'url': 'https://image.example.com/img.png',
              'type': 'IMAGE',
            },
            {
              'url': 'https://video.example.com/clip.mp4',
              'type': 'VIDEO',
            },
          ],
          'isLikedByMe': true,
          'isRepostedByMe': false,
        },
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/123',
          )).thenAnswer((_) async => responseData);

      final tweet = await service.getTweetById('123');

      expect(tweet.id, '123');
      expect(tweet.body, 'Legacy tweet');
      expect(tweet.username, 'legacy');
      expect(tweet.authorName, 'Legacy User');
      expect(tweet.authorProfileImage, 'avatar.png');
      expect(tweet.mediaImages,
          contains('https://image.example.com/img.png'));
      expect(tweet.mediaVideos,
          contains('https://video.example.com/clip.mp4'));

      final flags = await service.getInteractionFlags('123');
      expect(flags?['isLikedByMe'], isTrue);
      expect(flags?['isRepostedByMe'], isFalse);

      verify(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/123',
          )).called(1);
    });

    test('getTweetById maps mediaUrls array into images and videos', () async {
      final now = DateTime.now().toIso8601String();
      final responseData = <String, dynamic>{
        'data': {
          'id': '124',
          'userId': 6,
          'username': 'urls',
          'name': 'Urls User',
          'avatar': 'avatar2.png',
          'text': 'With mediaUrls',
          'createdAt': now,
          'mediaUrls': [
            'https://cdn.example.com/photo.jpg',
            'https://cdn.example.com/video.mp4',
          ],
        },
      };

      when(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/124',
          )).thenAnswer((_) async => responseData);

      final tweet = await service.getTweetById('124');

      expect(tweet.id, '124');
      expect(tweet.body, 'With mediaUrls');
      expect(tweet.mediaImages,
          contains('https://cdn.example.com/photo.jpg'));
      expect(
          tweet.mediaVideos, contains('https://cdn.example.com/video.mp4'));

      verify(() => mockApiService.get<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/124',
          )).called(1);
    });

    test('updateTweet delegates to ApiService.put with correct endpoint',
        () async {
      final tweet = TweetModel(
        id: '321',
        body: 'update me',
        date: DateTime.now(),
        userId: '1',
      );

      when(() => mockApiService.put<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/321',
            data: any(named: 'data'),
          )).thenAnswer((_) async => <String, dynamic>{});

      await service.updateTweet(tweet);

      verify(() => mockApiService.put<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/321',
            data: tweet.toJson(),
          )).called(1);
    });

    test('deleteTweet delegates to ApiService.delete with correct endpoint',
        () async {
      when(() => mockApiService.delete<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/555',
          )).thenAnswer((_) async => <String, dynamic>{});

      await service.deleteTweet('555');

      verify(() => mockApiService.delete<Map<String, dynamic>>(
            endpoint: '${ApiConfig.postsEndpoint}/555',
          )).called(1);
    });
  });
}
