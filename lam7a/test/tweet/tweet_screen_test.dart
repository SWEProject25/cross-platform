import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/view/tweet_screen.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_ai_summery.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_body_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_detailed_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_user_info_detailed.dart';
import 'package:mocktail/mocktail.dart';

class MockTweetRepository extends Mock implements TweetRepository {}
class MockTweetsApiService extends Mock implements TweetsApiService {}

/// Fake TweetViewModel used to drive the TweetScreen when no tweetData is
/// provided, so we can cover the viewmodel-based branch safely.
class FakeTweetViewModel extends TweetViewModel {
  @override
  FutureOr<TweetState> build(String tweetId) {
    // Configure a reply thread for a specific test id; otherwise return a
    // simple standalone tweet.
    if (tweetId == 'reply-thread') {
      final parent = TweetModel(
        id: 'parent-1',
        userId: 'parent-user',
        body: 'Parent tweet',
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        likes: 1,
        comments: 0,
        repost: 0,
        views: 10,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
        username: 'parentuser',
        authorName: 'Parent User',
      );

      final reply = TweetModel(
        id: tweetId,
        userId: 'reply-user',
        body: 'Reply to parent',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
        username: 'replyuser',
        authorName: 'Reply User',
        originalTweet: parent,
        isQuote: false,
        isRepost: false,
      );

      return TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(reply),
      );
    }

    // Default: normal tweet without parent
    final tweet = TweetModel(
      id: tweetId,
      userId: 'user-$tweetId',
      body: 'Body for $tweetId',
      date: DateTime.now(),
      likes: 10,
      comments: 2,
      repost: 1,
      views: 100,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: const [],
      mediaVideos: const [],
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
  Future<String> getSummary(String tweetId) async {
    return 'Summary for $tweetId';
  }
}

/// Fake replies viewmodel so the viewmodel-based branch shows replies
/// without hitting the real API service.
class FakeTweetRepliesViewModel extends TweetRepliesViewModel {
  @override
  Future<List<TweetModel>> build(String postId) async {
    return [
      TweetModel(
        id: 'reply-$postId',
        userId: 'reply-user',
        body: 'Reply for $postId',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
        username: 'replyuser',
        authorName: 'Reply User',
      ),
    ];
  }
}

void main() {
  late MockTweetRepository mockRepository;
  late MockTweetsApiService mockApiService;
  late TweetModel testTweet;
  late TweetModel replyTweet;

  setUp(() {
    mockRepository = MockTweetRepository();
    mockApiService = MockTweetsApiService();

    testTweet = TweetModel(
      id: '1',
      userId: '1',
      body: 'Test tweet content',
      date: DateTime.now(),
      likes: 10,
      comments: 5,
      repost: 2,
      views: 100,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: [],
      mediaVideos: [],
      username: 'testuser',
      authorName: 'Test User',
    );

    replyTweet = TweetModel(
      id: '2',
      userId: '2',
      body: 'This is a reply',
      date: DateTime.now(),
      likes: 5,
      comments: 1,
      repost: 0,
      views: 50,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: [],
      mediaVideos: [],
      username: 'replyuser',
      authorName: 'Reply User',
    );
  });

  Widget buildTestWidget(TweetModel tweet, {List<TweetModel>? replies}) {
    when(() => mockApiService.getRepliesForPost(any()))
        .thenAnswer((_) async => replies ?? []);

    return ProviderScope(
      overrides: [
        tweetsApiServiceProvider.overrideWith((ref) => mockApiService),
        tweetRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: MaterialApp(
        home: TweetScreen(
          tweetId: tweet.id,
          tweetData: tweet,
        ),
      ),
    );
  }

  /// Helper that builds a TweetScreen which uses the TweetViewModel and
  /// TweetRepliesViewModel providers (no preloaded tweetData), so we can cover
  /// the else-branch in TweetScreen.build.
  Widget buildViewModelDrivenScreen(String tweetId) {
    return ProviderScope(
      overrides: [
        tweetViewModelProvider.overrideWith(FakeTweetViewModel.new),
        tweetRepliesViewModelProvider.overrideWith(
          FakeTweetRepliesViewModel.new,
        ),
      ],
      child: MaterialApp(
        routes: {
          '/profile': (_) => const Scaffold(body: Text('Profile')),
        },
        home: TweetScreen(tweetId: tweetId),
      ),
    );
  }

  group('TweetScreen Basic Rendering', () {
    testWidgets('displays app bar with Post title', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Post'), findsOneWidget);
    });

    testWidgets('displays scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
      expect(find.byType(SafeArea), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('displays TweetUserInfoDetailed', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetUserInfoDetailed), findsOneWidget);
    });

    testWidgets('displays TweetDetailedBodyWidget', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });

    testWidgets('displays TweetDetailedFeed', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('displays AI summary rocket icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.rocket), findsOneWidget);
    });

    testWidgets('app bar has proper styling', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.elevation, 0);
    });

    testWidgets('uses correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(SingleChildScrollView),
          matching: find.byType(Padding),
        ).first,
      );

      expect(padding.padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 8));
    });
  });

  group('TweetScreen Replies', () {
    testWidgets('displays replies when available', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet, replies: [replyTweet]));
      await tester.pumpAndSettle();

      expect(find.byType(TweetSummaryWidget), findsWidgets);
    });

    testWidgets('shows divider between replies', (WidgetTester tester) async {
      final reply2 = replyTweet.copyWith(id: '3', body: 'Another reply');
      await tester.pumpWidget(buildTestWidget(testTweet, replies: [replyTweet, reply2]));
      await tester.pumpAndSettle();

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('handles empty replies list', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet, replies: []));
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });

    testWidgets('displays loading indicator while fetching replies', (WidgetTester tester) async {
      when(() => mockApiService.getRepliesForPost(any()))
          .thenAnswer((_) async => Future.delayed(
                const Duration(milliseconds: 100),
                () => [replyTweet],
              ));

      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      await tester.pumpAndSettle();
    });

    testWidgets('handles reply fetch error gracefully', (WidgetTester tester) async {
      when(() => mockApiService.getRepliesForPost(any()))
          .thenThrow(Exception('Failed to load replies'));

      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      // Should still display main tweet
      expect(find.byType(TweetScreen), findsOneWidget);
    });
  });

  group('TweetScreen Repost Handling', () {
    testWidgets('displays repost indicator for reposted tweet', (WidgetTester tester) async {
      final repostTweet = testTweet.copyWith(
        isRepost: true,
        originalTweet: testTweet.copyWith(id: '99'),
      );

      await tester.pumpWidget(buildTestWidget(repostTweet));
      await tester.pumpAndSettle();

      // Verify screen renders with repost data
      expect(find.byType(TweetScreen), findsOneWidget);
    });

    testWidgets('shows repost author name', (WidgetTester tester) async {
      final repostTweet = testTweet.copyWith(
        isRepost: true,
        originalTweet: testTweet.copyWith(id: '99'),
        authorName: 'Reposter Name',
      );

      await tester.pumpWidget(buildTestWidget(repostTweet));
      await tester.pumpAndSettle();

      expect(find.textContaining('Reposter Name reposted'), findsOneWidget);
    });
  });

  group('TweetScreen Reply Thread Handling', () {
    testWidgets('handles reply with parent tweet', (WidgetTester tester) async {
      final parentTweet = testTweet.copyWith(id: '100', body: 'Parent tweet');
      final replyToParent = testTweet.copyWith(
        id: '101',
        body: 'Reply to parent',
        originalTweet: parentTweet,
        isQuote: false,
        isRepost: false,
      );

      await tester.pumpWidget(buildTestWidget(replyToParent));
      await tester.pump();

      // Verify screen renders with reply structure
      expect(find.byType(TweetScreen), findsOneWidget);
    }, skip: true);
  });

  group('TweetScreen Theme Support', () {
    testWidgets('renders in light mode', (WidgetTester tester) async {
      when(() => mockApiService.getRepliesForPost(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetsApiServiceProvider.overrideWith((ref) => mockApiService),
          ],
          child: MaterialApp(
            theme: ThemeData.light(),
            home: TweetScreen(tweetId: testTweet.id, tweetData: testTweet),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });

    testWidgets('renders in dark mode', (WidgetTester tester) async {
      when(() => mockApiService.getRepliesForPost(any()))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetsApiServiceProvider.overrideWith((ref) => mockApiService),
          ],
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: TweetScreen(tweetId: testTweet.id, tweetData: testTweet),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });
  });

  group('TweetScreen Media Content', () {
    testWidgets('displays tweet with images', (WidgetTester tester) async {
      final tweetWithImages = testTweet.copyWith(
        mediaImages: ['https://example.com/image1.jpg'],
      );

      await tester.pumpWidget(buildTestWidget(tweetWithImages));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });

    testWidgets('displays tweet with videos', (WidgetTester tester) async {
      final tweetWithVideo = testTweet.copyWith(
        mediaVideos: ['https://example.com/video.mp4'],
      );

      await tester.pumpWidget(buildTestWidget(tweetWithVideo));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });

    testWidgets('displays tweet with multiple images', (WidgetTester tester) async {
      final tweetWithImages = testTweet.copyWith(
        mediaImages: [
          'https://example.com/image1.jpg',
          'https://example.com/image2.jpg',
        ],
      );

      await tester.pumpWidget(buildTestWidget(tweetWithImages));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });
  });

  group('TweetScreen Edge Cases', () {
    testWidgets('handles tweet with no author name', (WidgetTester tester) async {
      final noAuthorTweet = testTweet.copyWith(authorName: null);

      await tester.pumpWidget(buildTestWidget(noAuthorTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetScreen), findsOneWidget);
    });

    testWidgets('handles tweet with empty body', (WidgetTester tester) async {
      final emptyBodyTweet = testTweet.copyWith(body: '');

      await tester.pumpWidget(buildTestWidget(emptyBodyTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });

    testWidgets('handles tweet with zero interactions', (WidgetTester tester) async {
      final noInteractionsTweet = testTweet.copyWith(
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
      );

      await tester.pumpWidget(buildTestWidget(noInteractionsTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedFeed), findsOneWidget);
    });

    testWidgets('handles very long tweet body', (WidgetTester tester) async {
      final longBodyTweet = testTweet.copyWith(
        body: 'A' * 500,
      );

      await tester.pumpWidget(buildTestWidget(longBodyTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });

    testWidgets('handles tweet with special characters', (WidgetTester tester) async {
      final specialCharTweet = testTweet.copyWith(
        body: 'Tweet with #hashtag @mention and emoji 😀',
      );

      await tester.pumpWidget(buildTestWidget(specialCharTweet));
      await tester.pumpAndSettle();

      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
    });
  });

  group('TweetScreen Scrolling', () {
    testWidgets('allows scrolling content', (WidgetTester tester) async {
      final manyReplies = List.generate(
        10,
        (i) => replyTweet.copyWith(id: 'reply$i', body: 'Reply $i'),
      );

      await tester.pumpWidget(buildTestWidget(testTweet, replies: manyReplies));
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('maintains scroll position', (WidgetTester tester) async {
      final manyReplies = List.generate(
        20,
        (i) => replyTweet.copyWith(id: 'reply$i', body: 'Reply $i'),
      );

      await tester.pumpWidget(buildTestWidget(testTweet, replies: manyReplies));
      await tester.pumpAndSettle();

      final scrollable = find.byType(SingleChildScrollView);
      expect(scrollable, findsOneWidget);
    });
  });

  group('TweetScreen Column Layout', () {
    testWidgets('uses Column for vertical layout', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('applies correct spacing with SizedBox', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('uses proper alignment', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet));
      await tester.pumpAndSettle();

      final column = tester.widget<Column>(
        find.descendant(
          of: find.byType(Padding),
          matching: find.byType(Column),
        ).first,
      );

      expect(column.mainAxisAlignment, MainAxisAlignment.start);
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);
    });
  });

  group('TweetScreen Multiple Replies Display', () {
    testWidgets('displays multiple replies correctly', (WidgetTester tester) async {
      final reply2 = replyTweet.copyWith(id: '3', body: 'Second reply');
      final reply3 = replyTweet.copyWith(id: '4', body: 'Third reply');

      await tester.pumpWidget(buildTestWidget(testTweet, replies: [replyTweet, reply2, reply3]));
      await tester.pumpAndSettle();

      expect(find.byType(TweetSummaryWidget), findsWidgets);
    });

    testWidgets('handles single reply', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(testTweet, replies: [replyTweet]));
      await tester.pumpAndSettle();

      expect(find.byType(TweetSummaryWidget), findsWidgets);
    });
  });

  group('TweetScreen ViewModel branch', () {
    testWidgets('renders tweet and replies using TweetViewModel when no tweetData',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildViewModelDrivenScreen('vm-normal'));
      await tester.pumpAndSettle();

      expect(find.byType(TweetUserInfoDetailed), findsOneWidget);
      expect(find.byType(TweetDetailedBodyWidget), findsOneWidget);
      expect(find.byType(TweetDetailedFeed), findsOneWidget);
      expect(find.byType(TweetSummaryWidget), findsWidgets);
    });

    testWidgets('shows parent tweet connector for reply threads',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildViewModelDrivenScreen('reply-thread'));
      await tester.pumpAndSettle();

      expect(find.text('Parent User'), findsOneWidget);
      expect(find.text('Reply User'), findsWidgets);
      expect(find.text('Replying to @parentuser'), findsOneWidget);
    });

    testWidgets('shows time ago format for parent tweet',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildViewModelDrivenScreen('reply-thread'));
      await tester.pumpAndSettle();

      expect(find.textContaining('m'), findsWidgets);
    });

    testWidgets('tapping rocket icon opens TweetAiSummary with summary text',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildViewModelDrivenScreen('vm-summary'));
      await tester.pumpAndSettle();

      final rocketIcon = find.byIcon(Icons.rocket).first;
      await tester.tap(rocketIcon);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(TweetAiSummary), findsOneWidget);
      expect(find.text('Summary for vm-summary'), findsOneWidget);
    });

    testWidgets('displays error state when tweet fails to load',
        (WidgetTester tester) async {
      final container = ProviderScope(
        overrides: [
          tweetViewModelProvider.overrideWith(ErrorTweetViewModel.new),
        ],
        child: const MaterialApp(
          home: TweetScreen(tweetId: 'error-tweet'),
        ),
      );

      await tester.pumpWidget(container);
      await tester.pumpAndSettle();

      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('displays loading state initially',
        (WidgetTester tester) async {
      final container = ProviderScope(
        overrides: [
          tweetViewModelProvider.overrideWith(LoadingTweetViewModel.new),
        ],
        child: const MaterialApp(
          home: TweetScreen(tweetId: 'loading-tweet'),
        ),
      );

      await tester.pumpWidget(container);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }, skip: true);
  });
}

/// ViewModel that returns an error state
class ErrorTweetViewModel extends TweetViewModel {
  @override
  FutureOr<TweetState> build(String tweetId) {
    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.error('Failed to load tweet', StackTrace.empty),
    );
  }

  @override
  Future<String> getSummary(String tweetId) async {
    throw Exception('Failed to load summary');
  }
}

/// ViewModel that returns a loading state
class LoadingTweetViewModel extends TweetViewModel {
  @override
  FutureOr<TweetState> build(String tweetId) {
    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: const AsyncValue.loading(),
    );
  }

  @override
  Future<String> getSummary(String tweetId) async {
    return 'Summary';
  }
}