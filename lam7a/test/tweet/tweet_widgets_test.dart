import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

/// ---- MOCK CLASSES ----
class MockTweetRepository extends Mock implements TweetRepository {}

class MockTweetsApiService extends Mock implements TweetsApiService {}

class MockPostInteractionsService extends Mock
    implements PostInteractionsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const tweetId = 't1';

  final testTweet = TweetModel(
    id: tweetId,
    body: 'Hello from widget test',
    mediaPic: null,
    mediaVideo: null,
    mediaImages: const [],
    mediaVideos: const [],
    date: DateTime(2025, 1, 1),
    likes: 5,
    qoutes: 2,
    bookmarks: 1,
    repost: 3,
    comments: 4,
    views: 10,
    userId: 'u1',
    username: 'tester',
    authorName: 'Test User',
  );

  late MockTweetRepository mockRepo;
  late MockTweetsApiService mockTweetsApiService;
  late MockPostInteractionsService mockInteractionsService;

  setUp(() {
    mockRepo = MockTweetRepository();
    mockTweetsApiService = MockTweetsApiService();
    mockInteractionsService = MockPostInteractionsService();

    // Stub repository and API calls used by TweetViewModel.build
    when(() => mockRepo.fetchTweetById(tweetId))
        .thenAnswer((_) async => testTweet);
    when(() => mockTweetsApiService.getInteractionFlags(tweetId))
        .thenAnswer((_) async => {
              'isLikedByMe': false,
              'isRepostedByMe': false,
              'isViewedByMe': false,
            });
    when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);
    // Default: no replies for this tweet (can be overridden per test)
    when(() => mockTweetsApiService.getRepliesForPost(any()))
        .thenAnswer((_) async => <TweetModel>[]);
  });

  group('TweetSummaryWidget', () {
    testWidgets('renders tweet body and navigates to TweetScreen on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepo),
            tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
            postInteractionsServiceProvider
                .overrideWithValue(mockInteractionsService),
          ],
          child: MaterialApp(
            home: TweetSummaryWidget(
              tweetId: tweetId,
              tweetData: testTweet,
            ),
          ),
        ),
      );

      // Let async providers resolve
      await tester.pumpAndSettle();

      // TweetBodySummaryWidget should be visible
      expect(find.byType(TweetBodySummaryWidget), findsWidgets);

      // Tapping the summary body should navigate to TweetScreen
      await tester.tap(find.byType(TweetBodySummaryWidget).first);
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });
  });

  group('TweetScreen', () {
    testWidgets('renders main tweet and replies when tweetData is provided',
        (WidgetTester tester) async {
      const replyId = 'reply1';
      final replyTweet = testTweet.copyWith(
        id: replyId,
        body: 'This is a reply',
      );

      // Override replies for this tweet via the mocked API service
      when(() => mockTweetsApiService.getRepliesForPost(tweetId))
          .thenAnswer((_) async => <TweetModel>[replyTweet]);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Use mocked API service so TweetRepliesViewModel reads stubbed replies
            tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
          ],
          child: MaterialApp(
            home: TweetScreen(
              tweetId: tweetId,
              tweetData: testTweet,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // App bar title
      expect(find.text('Post'), findsOneWidget);

      // Main tweet and reply should be rendered
      expect(find.byType(TweetSummaryWidget), findsWidgets);
    });
  });
}
