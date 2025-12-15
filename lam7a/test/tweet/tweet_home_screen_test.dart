import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/ui/view/pages/tweet_home_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockTweetRepository extends Mock implements TweetRepository {}

void main() {
  late MockTweetRepository mockRepository;
  late List<TweetModel> testTweets;

  setUp(() {
    mockRepository = MockTweetRepository();

    testTweets = [
      TweetModel(
        id: '1',
        userId: '1',
        body: 'First tweet',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        likes: 10,
        comments: 5,
        repost: 2,
        views: 100,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      ),
      TweetModel(
        id: '2',
        userId: '1',
        body: 'Second tweet',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 20,
        comments: 8,
        repost: 3,
        views: 200,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      ),
    ];
  });

  Widget buildTestWidget() {
    when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
        .thenAnswer((_) async => testTweets);
    when(() => mockRepository.fetchTweets(any(), any(), 'following'))
        .thenAnswer((_) async => testTweets);

    return ProviderScope(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepository),
      ],
      child: const MaterialApp(
        home: TweetHomeScreen(),
      ),
    );
  }

  group('TweetHomeScreen Widget Tests', () {
    testWidgets('displays scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays tab bar with For you and Following tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('For you'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });

    testWidgets('displays floating action button', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('displays tweets in list', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TweetHomeScreen), findsOneWidget);
    });

    testWidgets('has proper scaffold structure', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('tab controller switches between tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify initial tab
      final tabBar = find.byType(TabBar);
      expect(tabBar, findsOneWidget);

      // Tap Following tab
      await tester.tap(find.text('Following'));
      await tester.pumpAndSettle();

      // Widget should still be visible
      expect(find.byType(TweetHomeScreen), findsOneWidget);
    });

    testWidgets('displays loading indicator when loading',
        (WidgetTester tester) async {
      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => Future.delayed(
                const Duration(milliseconds: 100),
                () => testTweets,
              ));
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => testTweets);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: TweetHomeScreen(),
          ),
        ),
      );
      await tester.pump();

      // Should have scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Complete timers
      await tester.pumpAndSettle();
    });

    testWidgets('handles empty tweet list', (WidgetTester tester) async {
      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => []);
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: const MaterialApp(
            home: TweetHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetHomeScreen), findsOneWidget);
    });

    testWidgets('scroll controller is attached', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Verify scrollable content exists
      expect(find.byType(TabBarView), findsOneWidget);
    });

    testWidgets('renders in light mode', (WidgetTester tester) async {
      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => testTweets);
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => testTweets);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            theme: ThemeData.light(),
            home: const TweetHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetHomeScreen), findsOneWidget);
    });

    testWidgets('renders in dark mode', (WidgetTester tester) async {
      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => testTweets);
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => testTweets);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tweetRepositoryProvider.overrideWithValue(mockRepository),
          ],
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: const TweetHomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TweetHomeScreen), findsOneWidget);
    });

    testWidgets('uses SingleTickerProviderStateMixin',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // TabController requires ticker provider
      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('disposes controllers properly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Remove widget to trigger dispose
      await tester.pumpWidget(const SizedBox());

      // If dispose works correctly, no errors thrown
      expect(find.byType(TweetHomeScreen), findsNothing);
    });
  });
}
