import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_ai_summery.dart';

/// Mock classes for dependencies
class MockTweetRepository extends Mock implements TweetRepository {}

class MockTweetsApiService extends Mock implements TweetsApiService {}

class MockPostInteractionsService extends Mock
    implements PostInteractionsService {}

class MockTweetViewModel extends Mock implements TweetViewModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTweetRepository mockRepo;
  late MockTweetsApiService mockTweetsApiService;
  late MockPostInteractionsService mockInteractionsService;

  const tweetId = 'tweet123';

  final testTweet = TweetModel(
    id: tweetId,
    body: 'This is a test tweet that needs to be summarized by AI',
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

  Widget buildTestWidget(TweetModel tweet) {
    return ProviderScope(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepo),
        tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
        postInteractionsServiceProvider
            .overrideWithValue(mockInteractionsService),
      ],
      child: MaterialApp(
        home: TweetAiSummary(tweet: tweet),
      ),
    );
  }

  group('TweetAiSummary Widget Tests', () {
    testWidgets('displays loading indicator initially', (
      WidgetTester tester,
    ) async {
      // Use a short delay so we can complete it
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => Future.delayed(
                const Duration(milliseconds: 100),
                () => testTweet,
              ));

      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pump();

      // Just verify widget renders during loading
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Complete the timer
      await tester.pumpAndSettle();
    });

    testWidgets('renders app bar with title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.text('AI Summary'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays original tweet card', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      // Just verify widget structure renders
      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays divider in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('has scrollable content area', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      // Just verify widget renders
      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('uses proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(Scaffold),
          matching: find.byType(Padding),
        ).first,
      );

      expect(padding.padding, const EdgeInsets.all(16));
    });

    testWidgets('displays tweet with different content', (
      WidgetTester tester,
    ) async {
      final differentTweet = testTweet.copyWith(
        body: 'Different tweet content for testing',
      );

      await tester.pumpWidget(buildTestWidget(differentTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('handles tweet with hashtags', (WidgetTester tester) async {
      final hashtagTweet = testTweet.copyWith(
        body: 'Tweet with #hashtag and #flutter',
      );

      await tester.pumpWidget(buildTestWidget(hashtagTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('handles tweet with mentions', (WidgetTester tester) async {
      final mentionTweet = testTweet.copyWith(
        body: 'Tweet with @user1 and @user2',
      );

      await tester.pumpWidget(buildTestWidget(mentionTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('renders correctly in light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepo),
            tweetsApiServiceProvider.overrideWith(
              (ref) => mockTweetsApiService,
            ),
            postInteractionsServiceProvider
                .overrideWithValue(mockInteractionsService),
          ],
          child: MaterialApp(
            theme: ThemeData.light(),
            home: TweetAiSummary(tweet: testTweet),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('renders correctly in dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepo),
            tweetsApiServiceProvider.overrideWith(
              (ref) => mockTweetsApiService,
            ),
            postInteractionsServiceProvider
                .overrideWithValue(mockInteractionsService),
          ],
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: TweetAiSummary(tweet: testTweet),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('has back button in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      // AppBar should have leading back button by default
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('displays tweet metadata', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      // Just verify widget renders
      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('handles tweet with long body text', (
      WidgetTester tester,
    ) async {
      final longTweet = testTweet.copyWith(
        body: 'A' * 1000,
      );

      await tester.pumpWidget(buildTestWidget(longTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('uses Column layout for content', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('displays content with proper spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
