// test/features/tweet/repository/tweet_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for TweetsApiService
class MockTweetsApiService extends Mock implements TweetsApiService {}

void main() {
  late MockTweetsApiService mockApiService;
  late TweetRepository tweetRepository;

  // Sample test data
  final sampleTweet = TweetModel(
    id: '1',
    body: 'Test tweet',
    userId: 'user1',
    date: DateTime(2025, 1, 1),
    likes: 5,
    repost: 2,
    comments: 3,
    views: 100,
    qoutes: 1,
    bookmarks: 0,
    mediaImages: [],
    mediaVideos: [],
  );

  final sampleTweetsList = [
    TweetModel(
      id: '1',
      body: 'Tweet 1',
      userId: 'user1',
      date: DateTime(2025, 1, 1),
      likes: 0,
      repost: 0,
      comments: 0,
      views: 0,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: [],
      mediaVideos: [],
    ),
    TweetModel(
      id: '2',
      body: 'Tweet 2',
      userId: 'user2',
      date: DateTime(2025, 1, 2),
      likes: 0,
      repost: 0,
      comments: 0,
      views: 0,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: [],
      mediaVideos: [],
    ),
  ];

  setUp(() {
    mockApiService = MockTweetsApiService();
    tweetRepository = TweetRepository(mockApiService);
  });

  group('TweetRepository', () {
    group('fetchAllTweets', () {
      test('should call getAllTweets with correct parameters and return tweets',
          () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getAllTweets(limit, page))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchAllTweets(limit, page);

        // Assert
        expect(result, equals(sampleTweetsList));
        expect(result.length, 2);
        verify(() => mockApiService.getAllTweets(limit, page)).called(1);
      });

      test('should propagate exceptions from API service', () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getAllTweets(limit, page))
            .thenThrow(Exception('Network error'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchAllTweets(limit, page),
          throwsException,
        );
        verify(() => mockApiService.getAllTweets(limit, page)).called(1);
      });

      test('should handle different page numbers correctly', () async {
        // Arrange
        const limit = 5;
        const page = 3;
        when(() => mockApiService.getAllTweets(limit, page))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchAllTweets(limit, page);

        // Assert
        expect(result, isNotEmpty);
        verify(() => mockApiService.getAllTweets(limit, page)).called(1);
      });
    });

    group('fetchTweetsForYou', () {
      test('should call getTweets with "for-you" filter and return tweets',
          () async {
        // Arrange
        const limit = 20;
        const page = 2;
        when(() => mockApiService.getTweets(limit, page, "for-you"))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchTweetsForYou(limit, page);

        // Assert
        expect(result, equals(sampleTweetsList));
        verify(() => mockApiService.getTweets(limit, page, "for-you"))
            .called(1);
      });

      test('should handle empty list from API', () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getTweets(limit, page, "for-you"))
            .thenAnswer((_) async => []);

        // Act
        final result = await tweetRepository.fetchTweetsForYou(limit, page);

        // Assert
        expect(result, isEmpty);
        verify(() => mockApiService.getTweets(limit, page, "for-you"))
            .called(1);
      });

      test('should propagate API errors', () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getTweets(limit, page, "for-you"))
            .thenThrow(Exception('Server error'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchTweetsForYou(limit, page),
          throwsException,
        );
      });
    });

    group('fetchTweetsFollowing', () {
      test('should call getTweets with "following" filter and return tweets',
          () async {
        // Arrange
        const limit = 15;
        const page = 3;
        when(() => mockApiService.getTweets(limit, page, "following"))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchTweetsFollowing(limit, page);

        // Assert
        expect(result, equals(sampleTweetsList));
        verify(() => mockApiService.getTweets(limit, page, "following"))
            .called(1);
      });

      test('should handle empty following list', () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getTweets(limit, page, "following"))
            .thenAnswer((_) async => []);

        // Act
        final result = await tweetRepository.fetchTweetsFollowing(limit, page);

        // Assert
        expect(result, isEmpty);
      });

      test('should propagate network errors', () async {
        // Arrange
        const limit = 10;
        const page = 1;
        when(() => mockApiService.getTweets(limit, page, "following"))
            .thenThrow(Exception('Connection timeout'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchTweetsFollowing(limit, page),
          throwsException,
        );
      });
    });

    group('fetchTweetById', () {
      test('should call getTweetById with correct id and return tweet',
          () async {
        // Arrange
        const tweetId = '123';
        when(() => mockApiService.getTweetById(tweetId))
            .thenAnswer((_) async => sampleTweet);

        // Act
        final result = await tweetRepository.fetchTweetById(tweetId);

        // Assert
        expect(result, equals(sampleTweet));
        expect(result.id, '1');
        expect(result.body, 'Test tweet');
        verify(() => mockApiService.getTweetById(tweetId)).called(1);
      });

      test('should propagate exceptions when tweet not found', () async {
        // Arrange
        const tweetId = 'nonexistent';
        when(() => mockApiService.getTweetById(tweetId))
            .thenThrow(Exception('Tweet not found'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchTweetById(tweetId),
          throwsException,
        );
        verify(() => mockApiService.getTweetById(tweetId)).called(1);
      });

      test('should handle different tweet IDs', () async {
        // Arrange
        const tweetId = '999';
        final tweet = TweetModel(
          id: tweetId,
          body: 'Different tweet',
          userId: 'user999',
          date: DateTime(2025, 1, 1),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        );

        when(() => mockApiService.getTweetById(tweetId))
            .thenAnswer((_) async => tweet);

        // Act
        final result = await tweetRepository.fetchTweetById(tweetId);

        // Assert
        expect(result.id, tweetId);
        expect(result.body, 'Different tweet');
      });
    });

    group('updateTweet', () {
      test('should call updateTweet with correct tweet object', () async {
        // Arrange
        when(() => mockApiService.updateTweet(sampleTweet))
            .thenAnswer((_) async => Future.value());

        // Act
        await tweetRepository.updateTweet(sampleTweet);

        // Assert
        verify(() => mockApiService.updateTweet(sampleTweet)).called(1);
      });

      test('should propagate exceptions from API service', () async {
        // Arrange
        when(() => mockApiService.updateTweet(sampleTweet))
            .thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => tweetRepository.updateTweet(sampleTweet),
          throwsException,
        );
        verify(() => mockApiService.updateTweet(sampleTweet)).called(1);
      });

      test('should handle updating different tweets', () async {
        // Arrange
        final anotherTweet = TweetModel(
          id: '2',
          body: 'Updated content',
          userId: 'user2',
          date: DateTime(2025, 1, 1),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        );

        when(() => mockApiService.updateTweet(anotherTweet))
            .thenAnswer((_) async => Future.value());

        // Act
        await tweetRepository.updateTweet(anotherTweet);

        // Assert
        verify(() => mockApiService.updateTweet(anotherTweet)).called(1);
        verifyNever(() => mockApiService.updateTweet(sampleTweet));
      });
    });

    group('deleteTweet', () {
      test('should call deleteTweet with correct id', () async {
        // Arrange
        const tweetId = '123';
        when(() => mockApiService.deleteTweet(tweetId))
            .thenAnswer((_) async => Future.value());

        // Act
        await tweetRepository.deleteTweet(tweetId);

        // Assert
        verify(() => mockApiService.deleteTweet(tweetId)).called(1);
      });

      test('should propagate exceptions when deletion fails', () async {
        // Arrange
        const tweetId = '123';
        when(() => mockApiService.deleteTweet(tweetId))
            .thenThrow(Exception('Deletion failed'));

        // Act & Assert
        expect(
          () => tweetRepository.deleteTweet(tweetId),
          throwsException,
        );
        verify(() => mockApiService.deleteTweet(tweetId)).called(1);
      });

      test('should handle deleting different tweet IDs', () async {
        // Arrange
        const tweetId1 = '111';
        const tweetId2 = '222';

        when(() => mockApiService.deleteTweet(tweetId1))
            .thenAnswer((_) async => Future.value());
        when(() => mockApiService.deleteTweet(tweetId2))
            .thenAnswer((_) async => Future.value());

        // Act
        await tweetRepository.deleteTweet(tweetId1);
        await tweetRepository.deleteTweet(tweetId2);

        // Assert
        verify(() => mockApiService.deleteTweet(tweetId1)).called(1);
        verify(() => mockApiService.deleteTweet(tweetId2)).called(1);
      });
    });

    group('fetchUserPosts', () {
      test('should call getTweetsByUser with correct userId and return posts',
          () async {
        // Arrange
        const userId = 'user123';
        when(() => mockApiService.getTweetsByUser(userId))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchUserPosts(userId);

        // Assert
        expect(result, equals(sampleTweetsList));
        expect(result.length, 2);
        verify(() => mockApiService.getTweetsByUser(userId)).called(1);
      });

      test('should return empty list when user has no posts', () async {
        // Arrange
        const userId = 'user123';
        when(() => mockApiService.getTweetsByUser(userId))
            .thenAnswer((_) async => []);

        // Act
        final result = await tweetRepository.fetchUserPosts(userId);

        // Assert
        expect(result, isEmpty);
        verify(() => mockApiService.getTweetsByUser(userId)).called(1);
      });

      test('should propagate API exceptions', () async {
        // Arrange
        const userId = 'user123';
        when(() => mockApiService.getTweetsByUser(userId))
            .thenThrow(Exception('User not found'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchUserPosts(userId),
          throwsException,
        );
      });

      test('should handle different user IDs', () async {
        // Arrange
        const userId1 = 'user1';
        const userId2 = 'user2';

        when(() => mockApiService.getTweetsByUser(userId1))
            .thenAnswer((_) async => [sampleTweetsList[0]]);
        when(() => mockApiService.getTweetsByUser(userId2))
            .thenAnswer((_) async => [sampleTweetsList[1]]);

        // Act
        final result1 = await tweetRepository.fetchUserPosts(userId1);
        final result2 = await tweetRepository.fetchUserPosts(userId2);

        // Assert
        expect(result1.length, 1);
        expect(result2.length, 1);
        expect(result1[0].userId, 'user1');
        expect(result2[0].userId, 'user2');
      });
    });

    group('fetchUserReplies', () {
      test('should call getRepliesByUser with correct userId and return replies',
          () async {
        // Arrange
        const userId = 'user456';
        when(() => mockApiService.getRepliesByUser(userId))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchUserReplies(userId);

        // Assert
        expect(result, equals(sampleTweetsList));
        expect(result.length, 2);
        verify(() => mockApiService.getRepliesByUser(userId)).called(1);
      });

      test('should return empty list when user has no replies', () async {
        // Arrange
        const userId = 'user456';
        when(() => mockApiService.getRepliesByUser(userId))
            .thenAnswer((_) async => []);

        // Act
        final result = await tweetRepository.fetchUserReplies(userId);

        // Assert
        expect(result, isEmpty);
      });

      test('should propagate errors from API', () async {
        // Arrange
        const userId = 'user456';
        when(() => mockApiService.getRepliesByUser(userId))
            .thenThrow(Exception('Server error'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchUserReplies(userId),
          throwsException,
        );
      });
    });

    group('fetchUserLikes', () {
      test('should call getUserLikedPosts with correct userId and return likes',
          () async {
        // Arrange
        const userId = 'user789';
        when(() => mockApiService.getUserLikedPosts(userId))
            .thenAnswer((_) async => sampleTweetsList);

        // Act
        final result = await tweetRepository.fetchUserLikes(userId);

        // Assert
        expect(result, equals(sampleTweetsList));
        expect(result.length, 2);
        verify(() => mockApiService.getUserLikedPosts(userId)).called(1);
      });

      test('should return empty list when user has no likes', () async {
        // Arrange
        const userId = 'user789';
        when(() => mockApiService.getUserLikedPosts(userId))
            .thenAnswer((_) async => []);

        // Act
        final result = await tweetRepository.fetchUserLikes(userId);

        // Assert
        expect(result, isEmpty);
      });

      test('should handle API failures', () async {
        // Arrange
        const userId = 'user789';
        when(() => mockApiService.getUserLikedPosts(userId))
            .thenThrow(Exception('Failed to fetch likes'));

        // Act & Assert
        expect(
          () => tweetRepository.fetchUserLikes(userId),
          throwsException,
        );
      });
    });

    group('getTweetSummery', () {
      test('should call getTweetSummery with correct tweetId and return summary',
          () async {
        // Arrange
        const tweetId = 'tweet123';
        const summary = 'This is a summary of the tweet';
        when(() => mockApiService.getTweetSummery(tweetId))
            .thenAnswer((_) async => summary);

        // Act
        final result = await tweetRepository.getTweetSummery(tweetId);

        // Assert
        expect(result, equals(summary));
        expect(result, isNotEmpty);
        verify(() => mockApiService.getTweetSummery(tweetId)).called(1);
      });

      test('should handle empty summary', () async {
        // Arrange
        const tweetId = 'tweet123';
        when(() => mockApiService.getTweetSummery(tweetId))
            .thenAnswer((_) async => '');

        // Act
        final result = await tweetRepository.getTweetSummery(tweetId);

        // Assert
        expect(result, isEmpty);
        verify(() => mockApiService.getTweetSummery(tweetId)).called(1);
      });

      test('should handle different tweet summaries', () async {
        // Arrange
        const tweetId1 = 'tweet1';
        const tweetId2 = 'tweet2';
        const summary1 = 'Summary for tweet 1';
        const summary2 = 'Summary for tweet 2';

        when(() => mockApiService.getTweetSummery(tweetId1))
            .thenAnswer((_) async => summary1);
        when(() => mockApiService.getTweetSummery(tweetId2))
            .thenAnswer((_) async => summary2);

        // Act
        final result1 = await tweetRepository.getTweetSummery(tweetId1);
        final result2 = await tweetRepository.getTweetSummery(tweetId2);

        // Assert
        expect(result1, summary1);
        expect(result2, summary2);
      });

      test('should propagate exceptions from API', () async {
        // Arrange
        const tweetId = 'tweet123';
        when(() => mockApiService.getTweetSummery(tweetId))
            .thenThrow(Exception('Summary generation failed'));

        // Act & Assert
        expect(
          () => tweetRepository.getTweetSummery(tweetId),
          throwsException,
        );
      });
    });
  });
}