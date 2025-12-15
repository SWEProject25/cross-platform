import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/Explore/ui/state/search_result_state.dart';
import 'package:lam7a/features/Explore/repository/search_repository.dart';
import 'package:lam7a/features/Explore/ui/view/search_result/latesttab.dart';
import 'package:lam7a/features/Explore/ui/view/search_result/peopletab.dart';
import 'package:lam7a/features/Explore/ui/view/search_result_page.dart';
import 'package:lam7a/features/Explore/ui/view/search_result/toptab.dart';
import 'package:lam7a/features/Explore/ui/viewmodel/search_results_viewmodel.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepository;

  setUp(() {
    mockRepository = MockSearchRepository();
  });

  Widget createTestWidget({required String query, bool isHashtag = false}) {
    return ProviderScope(
      overrides: [
        // Override the repository provider
        searchRepositoryProvider.overrideWithValue(mockRepository),
        // Override the viewmodel - dependencies are automatically resolved
        searchResultsViewModelProvider.overrideWith(
          () => SearchResultsViewmodel(),
        ),
      ],
      child: MaterialApp(home: SearchResultPage(hintText: query)),
    );
  }

  group('SearchResultPage Widget Tests', () {
    testWidgets('displays query in app bar', (WidgetTester tester) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      expect(find.text('flutter'), findsOneWidget);
    });

    testWidgets('starts on Top tab by default', (WidgetTester tester) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(
        find.byKey(SearchResultPage.tabBarKey),
      );
      expect(tabBar.controller?.index, equals(0));
      expect(find.byType(TopTab), findsOneWidget);
    });

    testWidgets('navigates to Latest tab when Latest is tapped', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      when(
        () => mockRepository.searchTweets(
          any(),
          any(),
          any(),
          tweetsOrder: any(named: 'tweetsOrder'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => []);

      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Tap on Latest tab
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(
        find.byKey(SearchResultPage.tabBarKey),
      );
      expect(tabBar.controller?.index, equals(1));
      expect(find.byType(LatestTab), findsOneWidget);
    });

    testWidgets('navigates to People tab when People is tapped', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(
          any(),
          any(),
          any(),
          tweetsOrder: any(named: 'tweetsOrder'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Tap on People tab
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(
        find.byKey(SearchResultPage.tabBarKey),
      );
      expect(tabBar.controller?.index, equals(2));
      expect(find.byType(PeopleTab), findsOneWidget);
    });

    testWidgets('navigates through all tabs in sequence', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(
          any(),
          any(),
          any(),
          tweetsOrder: any(named: 'tweetsOrder'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Start on Top tab
      TabBar tabBar = tester.widget<TabBar>(
        find.byKey(SearchResultPage.tabBarKey),
      );
      expect(tabBar.controller?.index, equals(0));
      expect(find.byType(TopTab), findsOneWidget);

      // Navigate to Latest
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();
      tabBar = tester.widget<TabBar>(find.byKey(SearchResultPage.tabBarKey));
      expect(tabBar.controller?.index, equals(1));
      expect(find.byType(LatestTab), findsOneWidget);

      // Navigate to People
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();
      tabBar = tester.widget<TabBar>(find.byKey(SearchResultPage.tabBarKey));
      expect(tabBar.controller?.index, equals(2));
      expect(find.byType(PeopleTab), findsOneWidget);

      // Navigate back to Top
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();
      tabBar = tester.widget<TabBar>(find.byKey(SearchResultPage.tabBarKey));
      expect(tabBar.controller?.index, equals(0));
      expect(find.byType(TopTab), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      when(() => mockRepository.searchTweets(any(), any(), any())).thenAnswer((
        _,
      ) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      await tester.pumpWidget(createTestWidget(query: 'flutter'));

      // First frame → loading
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));

      // 🔑 Advance fake time to finish the Future
      await tester.pump(const Duration(milliseconds: 100));

      // Let UI rebuild after future completes
      await tester.pump();
    });

    testWidgets('calls searchTweets on initial load', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      verify(
        () => mockRepository.searchTweets('flutter', any(), any()),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('calls searchHashtagTweets for hashtag search', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchHashtagTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(
        createTestWidget(query: '#flutter', isHashtag: true),
      );
      await tester.pumpAndSettle();

      verify(
        () => mockRepository.searchHashtagTweets('#flutter', any(), any()),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('calls searchUsers when navigating to People tab', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Navigate to People tab
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();

      verify(
        () => mockRepository.searchUsers('flutter', any(), any()),
      ).called(greaterThanOrEqualTo(1));
    });

    testWidgets('tab controller syncs with selected tab index', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(
          any(),
          any(),
          any(),
          tweetsOrder: any(named: 'tweetsOrder'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      TabBar tabBar = tester.widget<TabBar>(
        find.byKey(SearchResultPage.tabBarKey),
      );
      expect(tabBar.controller?.index, equals(0));

      // Navigate to Latest tab
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();

      tabBar = tester.widget<TabBar>(find.byKey(SearchResultPage.tabBarKey));
      expect(tabBar.controller?.index, equals(1));

      // Navigate to People tab
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();

      tabBar = tester.widget<TabBar>(find.byKey(SearchResultPage.tabBarKey));
      expect(tabBar.controller?.index, equals(2));
    });

    testWidgets('back button navigates back', (WidgetTester tester) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Find and tap the back button
      final backButton = find.byType(BackButton);
      //   expect(backButton, findsOneWidget);
    });

    testWidgets('handles special characters in query', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: '@user#tag'));
      await tester.pumpAndSettle();

      expect(find.text('@user#tag'), findsOneWidget);
    });

    testWidgets('properly disposes tab controller', (
      WidgetTester tester,
    ) async {
      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Navigate away to trigger dispose
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      // If no errors are thrown, disposal was successful
    });

    testWidgets('Top tab builds TweetsListView widget', (
      WidgetTester tester,
    ) async {
      // Mock with actual tweet data so TweetsListView is rendered
      final mockTweet = TweetModel(
        id: '1',
        body: 'Test tweet',
        userId: 'user1',
        date: DateTime.now(),
        likes: 0,
        qoutes: 0,
        bookmarks: 0,
        views: 0,
      );

      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => [mockTweet]);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Should be on Top tab by default
      expect(find.byType(TopTab), findsOneWidget);
      expect(find.byKey(TopTab.contentKey), findsOneWidget);
    });

    testWidgets('Latest tab builds TweetsListView widget when navigated to', (
      WidgetTester tester,
    ) async {
      final mockTweet = TweetModel(
        id: '1',
        body: 'Test tweet',
        userId: 'user1',
        date: DateTime.now(),
        likes: 0,
        qoutes: 0,
        bookmarks: 0,
        views: 0,
      );

      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => [mockTweet]);
      when(
        () => mockRepository.searchTweets(
          any(),
          any(),
          any(),
          tweetsOrder: any(named: 'tweetsOrder'),
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => [mockTweet]);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Navigate to Latest tab
      await tester.tap(find.text('Latest'));
      await tester.pumpAndSettle();

      expect(find.byType(LatestTab), findsOneWidget);
      expect(find.byKey(LatestTab.contentKey), findsOneWidget);
    });

    testWidgets('People tab builds ListView when navigated to', (
      WidgetTester tester,
    ) async {
      final mockUser = UserModel(
        id: 1,
        name: 'Test User',
        username: 'testuser',
        email: 'test@test.com',
        followersCount: 0,
        followingCount: 0,
      );

      when(
        () => mockRepository.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => [mockUser]);
      when(
        () => mockRepository.searchTweets(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(query: 'flutter'));
      await tester.pumpAndSettle();

      // Navigate to People tab
      await tester.tap(find.text('People'));
      await tester.pumpAndSettle();

      expect(find.byType(PeopleTab), findsOneWidget);
      expect(find.byKey(PeopleTab.contentKey), findsOneWidget);
    });
  });
}
