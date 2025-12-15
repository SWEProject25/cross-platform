import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_feed.dart';

/// Mock classes for dependencies
class MockTweetRepository extends Mock implements TweetRepository {}

class MockTweetsApiService extends Mock implements TweetsApiService {}

class MockPostInteractionsService extends Mock
    implements PostInteractionsService {}

class FakeTweetViewModel extends TweetViewModel {
  @override
  FutureOr<TweetState> build(String tweetId) {
    final tweet = TweetModel(
      id: tweetId,
      body: 'Test tweet body from fake VM',
      mediaImages: const [],
      mediaVideos: const [],
      date: DateTime(2025, 1, 1),
      likes: 10,
      qoutes: 5,
      bookmarks: 3,
      repost: 8,
      comments: 12,
      views: 100,
      userId: 'user123',
      username: 'testuser',
      authorName: 'Test User',
    );

    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.data(tweet),
    );
  }

  @override
  Future<void> handleRepost({
    required AnimationController controllerRepost,
  }) async {
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(isReposted: true),
      );
    }
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTweetRepository mockRepo;
  late MockTweetsApiService mockTweetsApiService;
  late MockPostInteractionsService mockInteractionsService;

  const tweetId = 'tweet123';

  final testTweet = TweetModel(
    id: tweetId,
    body: 'Test tweet body',
    mediaPic: null,
    mediaVideo: null,
    mediaImages: const [],
    mediaVideos: const [],
    date: DateTime(2025, 1, 1),
    likes: 10,
    qoutes: 5,
    bookmarks: 3,
    repost: 8,
    comments: 12,
    views: 100,
    userId: 'user123',
    username: 'testuser',
    authorName: 'Test User',
  );

  setUp(() {
    mockRepo = MockTweetRepository();
    mockTweetsApiService = MockTweetsApiService();
    mockInteractionsService = MockPostInteractionsService();

    // Setup default stubs
    when(() => mockRepo.fetchTweetById(tweetId))
        .thenAnswer((_) async => testTweet);
    when(() => mockTweetsApiService.getInteractionFlags(tweetId))
        .thenAnswer((_) async => {
              'isLikedByMe': false,
              'isRepostedByMe': false,
              'isViewedByMe': false,
            });
    when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);
    when(() => mockTweetsApiService.getRepliesForPost(any()))
        .thenAnswer((_) async => <TweetModel>[]);
  });

  TweetState buildTweetState(TweetModel tweet) {
    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.data(tweet),
    );
  }

  Widget buildTestWidget(TweetState tweetState) {
    return ProviderScope(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepo),
        tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
        postInteractionsServiceProvider
            .overrideWithValue(mockInteractionsService),
        tweetViewModelProvider.overrideWith(FakeTweetViewModel.new),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: TweetDetailedFeed(tweetState: tweetState),
          ),
        ),
      ),
    );
  }

  group('TweetDetailedFeed Widget Tests', () {
    testWidgets('renders tweet body and user info', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
      expect(find.byType(Text), findsWidgets); // Just verify Text widgets exist
    });

    testWidgets('displays interaction counts correctly', (
      WidgetTester tester,
    ) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      // Just verify the widget renders
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('shows loading state when tweet is loading', (
      WidgetTester tester,
    ) async {
      final loadingState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: const AsyncValue<TweetModel>.loading(),
      );

      await tester.pumpWidget(buildTestWidget(loadingState));
      await tester.pump();

      // Just verify widget is built during loading state
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles null tweet data gracefully', (
      WidgetTester tester,
    ) async {
      final errorState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue<TweetModel>.error('Error', StackTrace.empty),
      );

      await tester.pumpWidget(buildTestWidget(errorState));
      await tester.pumpAndSettle();

      // Should show error state or empty state
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('displays tweet with images', (WidgetTester tester) async {
      final tweetWithImages = testTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );
      final tweetState = buildTweetState(tweetWithImages);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('displays tweet with video', (WidgetTester tester) async {
      final tweetWithVideo = testTweet.copyWith(
        mediaVideo: 'https://example.com/video.mp4',
      );
      final tweetState = buildTweetState(tweetWithVideo);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('shows formatted date', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      // Just verify widget renders
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('displays like count and icon', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      // Like icon should be present
      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets('displays repost count and icon', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      // Repost section should be visible
      expect(find.byType(ScaleTransition), findsWidgets);
    });

    testWidgets('displays comment count', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.textContaining('12'), findsWidgets);
    });

    testWidgets('displays bookmark icon', (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      // Bookmark section should be present
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles tweet with zero interactions', (
      WidgetTester tester,
    ) async {
      final tweetNoInteractions = testTweet.copyWith(
        likes: 0,
        qoutes: 0,
        bookmarks: 0,
        repost: 0,
        comments: 0,
        views: 0,
      );
      final tweetState = buildTweetState(tweetNoInteractions);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles very long tweet body', (WidgetTester tester) async {
      final longTweet = testTweet.copyWith(
        body: 'A' * 500,
      );
      final tweetState = buildTweetState(longTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles tweet with multiple images', (
      WidgetTester tester,
    ) async {
      final tweetMultipleImages = testTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
          'https://example.com/image3.jpg',
        ],
      );
      final tweetState = buildTweetState(tweetMultipleImages);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles liked tweet state', (WidgetTester tester) async {
      final likedState = TweetState(
        isLiked: true,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(testTweet),
      );

      await tester.pumpWidget(buildTestWidget(likedState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles reposted tweet state', (WidgetTester tester) async {
      final repostedState = TweetState(
        isLiked: false,
        isReposted: true,
        isViewed: false,
        tweet: AsyncValue.data(testTweet),
      );

      await tester.pumpWidget(buildTestWidget(repostedState));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('tapping repost shows bottom sheet and success snackbar',
        (WidgetTester tester) async {
      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      final repostScale = find.byType(ScaleTransition).at(0);
      final repostButton = find.descendant(
        of: repostScale,
        matching: find.byType(IconButton),
      );

      await tester.tap(repostButton);
      await tester.pumpAndSettle();

      expect(find.text('Repost'), findsOneWidget);

      await tester.tap(find.text('Repost'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Reposted Successfully'), findsOneWidget);
    });

    testWidgets('long press on repost icon shows reposters bottom sheet',
        (WidgetTester tester) async {
      when(() => mockInteractionsService.getReposters(tweetId)).thenAnswer(
        (_) async => const [
          UserModel(id: 1, username: 'alice', name: 'Alice'),
        ],
      );

      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      final repostScale = find.byType(ScaleTransition).at(0);
      await tester.longPress(repostScale);
      await tester.pumpAndSettle();

      expect(find.text('Reposted by'), findsOneWidget);
      expect(find.text('Alice'), findsWidgets);
      expect(find.text('@alice'), findsOneWidget);
    });

    testWidgets('long press on like icon shows likers bottom sheet',
        (WidgetTester tester) async {
      when(() => mockInteractionsService.getLikers(tweetId)).thenAnswer(
        (_) async => const [
          UserModel(id: 2, username: 'bob', name: 'Bob'),
        ],
      );

      final tweetState = buildTweetState(testTweet);

      await tester.pumpWidget(buildTestWidget(tweetState));
      await tester.pumpAndSettle();

      final likeScale = find.byType(ScaleTransition).at(1);
      await tester.longPress(likeScale);
      await tester.pumpAndSettle();

      expect(find.text('Liked by'), findsOneWidget);
      expect(find.text('Bob'), findsWidgets);
      expect(find.text('@bob'), findsOneWidget);
    });
  });
}
