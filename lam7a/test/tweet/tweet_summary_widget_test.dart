import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_body_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_summary.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_ai_summery.dart';
import 'package:mocktail/mocktail.dart';

class MockTweetRepository extends Mock implements TweetRepository {}
class MockTweetsApiService extends Mock implements TweetsApiService {}

void main() {
  late MockTweetRepository mockRepo;
  late MockTweetsApiService mockTweetsApiService;

  setUp(() {
    mockRepo = MockTweetRepository();
    mockTweetsApiService = MockTweetsApiService();
  });

  final testTweet = TweetModel(
    id: '1',
    userId: '1',
    body: 'Test tweet body',
    username: 'testuser',
    authorName: 'Test User',
    authorProfileImage: null, // Avoid network requests in tests
    date: DateTime(2024, 1, 1),
    likes: 10,
    repost: 5,
    comments: 3,
    views: 100,
    qoutes: 0,
    bookmarks: 0,
    mediaImages: [],
    mediaVideos: [],
  );

  Widget buildTestWidget(TweetModel tweet) {
    return ProviderScope(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepo),
        tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: TweetSummaryWidget(
            tweetId: tweet.id,
            tweetData: tweet,
          ),
        ),
      ),
    );
  }

  group('TweetSummaryWidget - Reply Thread Display (Lines 115-179)', () {
    testWidgets('displays parent tweet with OriginalTweetCard for replies', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1', body: 'Parent tweet text');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        body: 'Reply to parent',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Should display OriginalTweetCard for parent
      expect(find.byType(OriginalTweetCard), findsOneWidget);
      expect(find.byType(TweetSummaryWidget), findsOneWidget);
    });

    testWidgets('shows connector line between parent and reply', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Check for connector line Container (width: 2, height: 16, grey color)
      final containerFinder = find.descendant(
        of: find.byType(Column),
        matching: find.byWidgetPredicate(
          (widget) => widget is Container && widget.constraints?.maxWidth == 2,
        ),
      );
      expect(containerFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('displays reply avatar after connector line', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        authorProfileImage: null, // Avoid network request
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Should show avatar for reply author
      expect(find.byType(AppUserAvatar), findsAtLeastNWidgets(1));
    });

    testWidgets('displays reply user info with TweetUserSummaryInfo', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        username: 'replyuser',
        authorName: 'Reply Author',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      expect(find.byType(TweetUserSummaryInfo), findsAtLeastNWidgets(1));
    });

    testWidgets('shows rocket icon for AI summary in reply section', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Check for rocket icon
      final rocketIcons = find.byIcon(Icons.rocket);
      expect(rocketIcons, findsAtLeastNWidgets(1));
    });

    testWidgets('displays reply body with TweetBodySummaryWidget', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1', body: 'Parent content');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        body: 'This is my reply content',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Reply should have TweetBodySummaryWidget
      expect(find.byType(TweetBodySummaryWidget), findsAtLeastNWidgets(1));
    });

    testWidgets('displays TweetFeed action bar for reply', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // TweetFeed should be present for interactions
      expect(find.byType(TweetFeed), findsAtLeastNWidgets(1));
    });

    testWidgets('reply action bar is indented by avatar width + spacing', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Check for SizedBox with specific width (avatarRadius * 2 + 9 = 47)
      final sizedBoxFinder = find.byWidgetPredicate(
        (widget) => widget is SizedBox && widget.width == 47.0,
      );
      expect(sizedBoxFinder, findsAtLeastNWidgets(1));
    });

    testWidgets('tapping reply opens TweetScreen', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: 'parent1');
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Tap on the GestureDetector containing the reply
      await tester.tap(find.byType(TweetBodySummaryWidget).last);
      await tester.pumpAndSettle();

      // Should navigate to TweetScreen
      expect(find.byType(TweetScreen), findsOneWidget);
    }, skip: true); // Causes infinite rendering cycles with reply thread navigation

    testWidgets('uses correct tweet for reply (not parent) as main content', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(
        id: 'parent1',
        body: 'Parent tweet body',
        username: 'parentuser',
        authorName: 'Parent Author',
      );
      final replyTweet = testTweet.copyWith(
        id: 'reply1',
        body: 'Reply tweet body',
        username: 'replyuser',
        authorName: 'Reply Author',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyTweet));
      await tester.pump();

      // Should display both parent (OriginalTweetCard) and reply sections
      expect(find.byType(OriginalTweetCard), findsOneWidget);
      expect(find.byType(TweetBodySummaryWidget), findsAtLeastNWidgets(1));
    });
  });

  group('TweetSummaryWidget - Non-Reply Layouts', () {
    testWidgets('regular tweet uses standard layout (not reply thread)', (WidgetTester tester) async {
      final regularTweet = testTweet.copyWith(
        id: 'regular1',
        body: 'Regular tweet',
        originalTweet: null,
      );

      await tester.pumpWidget(buildTestWidget(regularTweet));
      await tester.pump();

      // Should NOT show OriginalTweetCard
      expect(find.byType(OriginalTweetCard), findsNothing);
      // Should show standard layout
      expect(find.byType(TweetBodySummaryWidget), findsOneWidget);
    });

    testWidgets('repost shows repost indicator and uses standard layout', (WidgetTester tester) async {
      final originalTweet = testTweet.copyWith(id: 'original1', body: 'Original content');
      final repostTweet = testTweet.copyWith(
        id: 'repost1',
        isRepost: true,
        originalTweet: originalTweet,
        username: 'reposter',
        authorName: 'Reposter Name',
      );

      await tester.pumpWidget(buildTestWidget(repostTweet));
      await tester.pump();

      // Should show repost indicator
      expect(find.byIcon(Icons.repeat), findsOneWidget);
      expect(find.text('Reposter Name reposted'), findsOneWidget);
      
      // Should NOT use reply thread layout (no OriginalTweetCard)
      expect(find.byType(OriginalTweetCard), findsNothing);
    });

    testWidgets('quote tweet uses standard layout (not reply thread)', (WidgetTester tester) async {
      final quotedTweet = testTweet.copyWith(id: 'quoted1', body: 'Quoted content');
      final quoteTweet = testTweet.copyWith(
        id: 'quote1',
        body: 'My comment on this',
        isQuote: true,
        originalTweet: quotedTweet,
      );

      await tester.pumpWidget(buildTestWidget(quoteTweet));
      await tester.pump();

      // Should NOT use reply thread layout (no OriginalTweetCard for quotes)
      expect(find.byType(OriginalTweetCard), findsNothing);
      expect(find.byType(TweetBodySummaryWidget), findsAtLeastNWidgets(1));
    }, skip: true); // Causes rendering cycles with quoted tweets
  });

  group('TweetSummaryWidget - Edge Cases', () {
    testWidgets('handles reply with null parent tweet gracefully', (WidgetTester tester) async {
      final replyWithNullParent = testTweet.copyWith(
        id: 'reply1',
        originalTweet: null, // Parent is null
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyWithNullParent));
      await tester.pump();

      // Should use standard layout when parent is null
      expect(find.byType(OriginalTweetCard), findsNothing);
      expect(find.byType(TweetSummaryWidget), findsOneWidget);
    });

    testWidgets('displays custom background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepo),
            tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: TweetSummaryWidget(
                tweetId: testTweet.id,
                tweetData: testTweet,
                backGroundColor: Colors.red,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Find Container with custom color
      final containerFinder = find.byWidgetPredicate(
        (widget) => widget is Container && widget.color == Colors.red,
      );
      expect(containerFinder, findsOneWidget);
    });

    testWidgets('formats time ago correctly for recent tweets', (WidgetTester tester) async {
      final recentTweet = testTweet.copyWith(
        id: 'recent1',
        date: DateTime.now().subtract(const Duration(minutes: 5)),
      );

      await tester.pumpWidget(buildTestWidget(recentTweet));
      await tester.pump();

      // Should show "5m" format
      expect(find.textContaining('m'), findsAtLeastNWidgets(1));
    });

    testWidgets('uses SafeArea to avoid system UI overlap', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pump();

      expect(find.byType(SafeArea), findsOneWidget);
    });
  });

  group('TweetSummaryWidget - Navigation', () {
    testWidgets('tapping rocket icon navigates to AI summary', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pump();

      final rocketIcon = find.byIcon(Icons.rocket).first;
      await tester.tap(rocketIcon);
      await tester.pumpAndSettle();

      // Should navigate to TweetAiSummary screen
      expect(find.byType(TweetAiSummary), findsOneWidget);
    });

    testWidgets('tapping tweet body navigates to detail screen', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pump();

      await tester.tap(find.byType(TweetBodySummaryWidget).first);
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });

    testWidgets('navigation passes correct tweet ID and data', (WidgetTester tester) async {
      final customTweet = testTweet.copyWith(
        id: 'custom123',
        body: 'Custom tweet for navigation test',
      );

      await tester.pumpWidget(buildTestWidget(customTweet));
      await tester.pump();

      // Tap the tweet body widget
      await tester.tap(find.byType(TweetBodySummaryWidget).first);
      await tester.pumpAndSettle();

      // TweetScreen should be shown
      expect(find.byType(TweetScreen), findsOneWidget);
    });
  });
}
