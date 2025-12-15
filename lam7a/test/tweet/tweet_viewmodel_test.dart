import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/repository/tweet_updates_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';

// Mocks
class MockTweetRepository extends Mock implements TweetRepository {}
class MockTweetUpdatesRepository extends Mock implements TweetUpdatesRepository {}
class MockTweetsApiService extends Mock implements TweetsApiService {}
class MockPostInteractionsService extends Mock implements PostInteractionsService {}
class MockAnimationController extends Mock implements AnimationController {}

class MockAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState(
      user: UserModel(id: 1, username: 'testuser', email: 'test@example.com', profileId: 1),
      isAuthenticated: true,
    );
  }
}

void main() {
  late ProviderContainer container;
  late MockTweetRepository mockRepository;
  late MockTweetUpdatesRepository mockUpdatesRepository;
  late MockTweetsApiService mockApiService;
  late MockPostInteractionsService mockInteractionsService;

  setUp(() {
    mockRepository = MockTweetRepository();
    mockUpdatesRepository = MockTweetUpdatesRepository();
    mockApiService = MockTweetsApiService();
    mockInteractionsService = MockPostInteractionsService();

    // Mock streams
    when(() => mockUpdatesRepository.onPostLikeUpdates(any())).thenAnswer((_) => Stream.empty());
    when(() => mockUpdatesRepository.onPostRepostUpdates(any())).thenAnswer((_) => Stream.empty());
    when(() => mockUpdatesRepository.onPostCommentUpdates(any())).thenAnswer((_) => Stream.empty());
    when(() => mockUpdatesRepository.joinPost(any())).thenAnswer((_) async {});
    when(() => mockUpdatesRepository.leavePost(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepository),
        tweetUpdatesRepositoryProvider.overrideWithValue(mockUpdatesRepository),
        tweetsApiServiceProvider.overrideWithValue(mockApiService),
        postInteractionsServiceProvider.overrideWithValue(mockInteractionsService),
        authenticationProvider.overrideWith(() => MockAuthentication()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TweetViewModel Tests', () {
    test('build loads tweet and flags', () async {
      final tweet = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      final flags = {'isLikedByMe': true, 'isRepostedByMe': false, 'isViewedByMe': false};

      when(() => mockRepository.fetchTweetById('1')).thenAnswer((_) async => tweet);
      when(() => mockApiService.getInteractionFlags('1')).thenAnswer((_) async => flags);
      when(() => mockApiService.getLocalViews('1')).thenReturn(null);

      final state = await container.read(tweetViewModelProvider('1').future);

      expect(state.tweet.value, tweet);
      expect(state.isLiked, true);
      expect(state.isReposted, false);
      expect(state.isViewed, false);
      
      verify(() => mockUpdatesRepository.joinPost(1)).called(1);
    });

    test('handleLike toggles like state', () async {
      // Arrange
      final tweet = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      when(() => mockRepository.fetchTweetById('1')).thenAnswer((_) async => tweet);
      when(() => mockApiService.getInteractionFlags('1')).thenAnswer((_) async => {});
      when(() => mockApiService.getLocalViews('1')).thenReturn(null);
      
      // Build VM
      await container.read(tweetViewModelProvider('1').future);
      final vmNotifier = container.read(tweetViewModelProvider('1').notifier);
      
      final mockController = MockAnimationController();
      when(() => mockController.forward()).thenAnswer((_) => TickerFuture.complete());
      when(() => mockController.reverse()).thenAnswer((_) => TickerFuture.complete());

      when(() => mockInteractionsService.toggleLike('1')).thenAnswer((_) async => true);
      when(() => mockInteractionsService.getLikesCount('1')).thenAnswer((_) async => 1);
      when(() => mockApiService.updateInteractionFlag('1', 'isLikedByMe', true)).thenReturn(null);

      // Act
      await vmNotifier.handleLike(controller: mockController);

      // Assert
      final state = await container.read(tweetViewModelProvider('1').future);
      expect(state.isLiked, true);
      expect(state.tweet.value!.likes, 1);
      
      verify(() => mockInteractionsService.toggleLike('1')).called(1);
    });

    test('handleRepost toggles repost state', () async {
      // Arrange
      final tweet = TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: []);
      when(() => mockRepository.fetchTweetById('1')).thenAnswer((_) async => tweet);
      when(() => mockApiService.getInteractionFlags('1')).thenAnswer((_) async => {});
      when(() => mockApiService.getLocalViews('1')).thenReturn(null);
      
       // Build VM
      await container.read(tweetViewModelProvider('1').future);
      final vmNotifier = container.read(tweetViewModelProvider('1').notifier);
      
      final mockController = MockAnimationController();
      when(() => mockController.forward()).thenAnswer((_) => TickerFuture.complete());
      when(() => mockController.reverse()).thenAnswer((_) => TickerFuture.complete());

      when(() => mockInteractionsService.toggleRepost('1')).thenAnswer((_) async => true);
      when(() => mockInteractionsService.getRepostsCount('1')).thenAnswer((_) async => 1);
      when(() => mockApiService.updateInteractionFlag('1', 'isRepostedByMe', true)).thenReturn(null);

      // Act
      await vmNotifier.handleRepost(controllerRepost: mockController);

       // Assert
      final state = await container.read(tweetViewModelProvider('1').future);
      expect(state.isReposted, true);
      expect(state.tweet.value!.repost, 1);
    });
  });
}
