import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/Explore/ui/view/explore_page.dart';
import 'package:lam7a/features/Explore/ui/viewmodel/explore_viewmodel.dart';
import 'package:lam7a/features/Explore/ui/state/explore_state.dart';
import 'package:lam7a/features/Explore/repository/explore_repository.dart';
import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';

class MockExploreRepository extends Mock implements ExploreRepository {}

void main() {
  late MockExploreRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(<TrendingHashtag>[]);
    registerFallbackValue(<UserModel>[]);
    registerFallbackValue(<String, List<TweetModel>>{});
    registerFallbackValue(<TweetModel>[]);
  });

  setUp(() {
    mockRepo = MockExploreRepository();
  });

  Widget createTestWidget(WidgetRef? ref) {
    return ProviderScope(
      overrides: [exploreRepositoryProvider.overrideWithValue(mockRepo)],
      child: const MaterialApp(home: ExplorePage()),
    );
  }

  Future<List<TrendingHashtag>> createMockHashtags(int count) async {
    if (count == 0) {
      await Future.delayed(const Duration(seconds: 1));
    }

    return List.generate(
      count,
      (i) => TrendingHashtag(
        order: i,
        hashtag: 'Hashtag$i',
        tweetsCount: 100 + i,
        trendCategory: 'general',
      ),
    );
  }

  List<UserModel> createMockUsers(int count) {
    return List.generate(
      count,
      (i) => UserModel(
        id: i,
        profileId: i,
        username: 'user$i',
        email: 'user$i@test.com',
        role: 'user',
        name: 'User $i',
        birthDate: '2000-01-01',
        profileImageUrl: null,
        bannerImageUrl: null,
        bio: 'Bio $i',
        location: null,
        website: null,
        createdAt: DateTime.now().toIso8601String(),
        followersCount: 100 + i,
        followingCount: 50 + i,
      ),
    );
  }

  Map<String, List<TweetModel>> createMockForYouTweets() {
    return {
      'sports': [
        TweetModel(
          id: 'tweet_1',
          body: 'Sports tweet',
          userId: 'user_1',
          date: DateTime.now(),
          likes: 10,
          qoutes: 2,
          bookmarks: 5,
          repost: 3,
          comments: 7,
          views: 100,
          username: 'user1',
          authorName: 'User 1',
          authorProfileImage: null,
          mediaImages: [],
          mediaVideos: [],
        ),
      ],
    };
  }

  group('ExplorePage - Widget Structure', () {
    testWidgets('should render scaffold with tab bar and tab bar view', (
      tester,
    ) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      expect(find.byKey(ExplorePage.scaffoldKey), findsOneWidget);
      expect(find.byKey(ExplorePage.tabBarKey), findsOneWidget);
      expect(find.byKey(ExplorePage.tabBarViewKey), findsOneWidget);
    });

    testWidgets('should render all 5 tabs', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('for_you_tab')), findsOneWidget);
      expect(find.byKey(const Key('trending_tab')), findsOneWidget);
      expect(find.byKey(const Key('news_tab')), findsOneWidget);
      expect(find.byKey(const Key('sports_tab')), findsOneWidget);
      expect(find.byKey(const Key('entertainment_tab')), findsOneWidget);

      expect(find.text('For You'), findsOneWidget);
      expect(find.text('Trending'), findsOneWidget);
      expect(find.text('News'), findsOneWidget);
      expect(find.text('Sports'), findsOneWidget);
      expect(find.text('Entertainment'), findsOneWidget);
    });

    testWidgets('should show loading indicator initially', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));

      // Before data loads
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // After data loads, no more loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('ExplorePage - Tab Navigation', () {
    testWidgets('should switch to Trending tab when tapped', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Initially on For You tab
      expect(find.byKey(const Key('for_you_content')), findsOneWidget);

      // Tap on Trending tab
      await tester.tap(find.byKey(const Key('trending_tab')));
      await tester.pumpAndSettle();

      // Should show trending content
      expect(find.byKey(const Key('trending_content')), findsOneWidget);
    });

    testWidgets('should switch to News tab when tapped', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('news'),
      ).thenAnswer((_) async => mockNewsHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on News tab
      await tester.tap(find.byKey(const Key('news_tab')));
      await tester.pumpAndSettle();

      // Should show news list
      expect(find.byKey(const Key('news_list')), findsOneWidget);
    });

    testWidgets('should switch to Sports tab when tapped', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockSportsHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('sports'),
      ).thenAnswer((_) async => mockSportsHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Sports tab
      await tester.tap(find.byKey(const Key('sports_tab')));
      await tester.pumpAndSettle();

      // Should show sports list
      expect(find.byKey(const Key('sports_list')), findsOneWidget);
    });

    testWidgets('should switch to Entertainment tab when tapped', (
      tester,
    ) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockEntertainmentHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('entertainment'),
      ).thenAnswer((_) async => mockEntertainmentHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Entertainment tab
      await tester.tap(find.byKey(const Key('entertainment_tab')));
      await tester.pumpAndSettle();

      // Should show entertainment list
      expect(find.byKey(const Key('entertainment_list')), findsOneWidget);
    });

    testWidgets('should navigate through all tabs in sequence', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(3);
      final mockSportsHashtags = createMockHashtags(3);
      final mockEntertainmentHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('news'),
      ).thenAnswer((_) async => mockNewsHashtags);
      when(
        () => mockRepo.getInterestHashtags('sports'),
      ).thenAnswer((_) async => mockSportsHashtags);
      when(
        () => mockRepo.getInterestHashtags('entertainment'),
      ).thenAnswer((_) async => mockEntertainmentHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // For You -> Trending
      await tester.tap(find.byKey(const Key('trending_tab')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('trending_content')), findsOneWidget);

      // Trending -> News
      await tester.tap(find.byKey(const Key('news_tab')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('news_list')), findsOneWidget);

      // News -> Sports
      await tester.tap(find.byKey(const Key('sports_tab')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('sports_list')), findsOneWidget);

      // Sports -> Entertainment
      await tester.tap(find.byKey(const Key('entertainment_tab')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('entertainment_list')), findsOneWidget);

      // Entertainment -> For You
      await tester.tap(find.byKey(const Key('for_you_tab')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('for_you_content')), findsOneWidget);
    });
  });

  group('ExplorePage - For You Tab', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      when(() => mockRepo.getTrendingHashtags()).thenAnswer(
        (_) async => await Future.delayed(
          const Duration(seconds: 1),
          () => createMockHashtags(5),
        ),
      );
      when(() => mockRepo.getSuggestedUsers(limit: 7)).thenAnswer(
        (_) async => await Future.delayed(
          const Duration(seconds: 1),
          () => createMockUsers(5),
        ),
      );
      when(() => mockRepo.getForYouTweets(any())).thenAnswer(
        (_) async => await Future.delayed(
          const Duration(seconds: 1),
          () => createMockForYouTweets(),
        ),
      );

      await tester.pumpWidget(createTestWidget(null));
      await tester.pump();

      expect(find.byKey(const Key('explore_loading')), findsOneWidget);

      //expect(find.byKey(const Key('for_you_content')), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('should display For You content after loading', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('for_you_content')), findsOneWidget);
      expect(find.byKey(const Key('for_you_loading')), findsNothing);
    });
  });

  group('ExplorePage - Trending Tab', () {
    // testWidgets('should show empty state when no trending hashtags', (
    //   tester,
    // ) async {
    //   final mockHashtags = createMockHashtags(0);
    //   final mockUsers = createMockUsers(5);
    //   final mockForYouTweets = createMockForYouTweets();

    //   when(
    //     () => mockRepo.getTrendingHashtags(),
    //   ).thenAnswer((_) async => await mockHashtags);

    //   when(
    //     () => mockRepo.getSuggestedUsers(limit: 7),
    //   ).thenAnswer((_) async => mockUsers);
    //   when(
    //     () => mockRepo.getForYouTweets(any()),
    //   ).thenAnswer((_) async => mockForYouTweets);

    //   await tester.pumpWidget(createTestWidget(null));
    //   await tester.pumpAndSettle();

    //   expect(find.byKey(const Key('for_you_content')), findsOneWidget);

    //   // Tap on Trending tab
    //   // await tester.tap(find.byKey(const Key('trending_tab')));
    //   // await tester.pumpAndSettle();

    //   // expect(find.byKey(const Key('trending_empty_text')), findsOneWidget);
    //   // expect(find.text('No trending hashtags found'), findsOneWidget);
    // });

    testWidgets('should display trending content', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Trending tab
      await tester.tap(find.byKey(const Key('trending_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('trending_content')), findsOneWidget);
    });
  });

  group('ExplorePage - News Tab', () {
    testWidgets('should show empty state when no news hashtags', (
      tester,
    ) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('news'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on News tab
      await tester.tap(find.byKey(const Key('news_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('news_empty_text')), findsOneWidget);
      expect(find.text('No News Trending hashtags found'), findsOneWidget);
    });

    testWidgets('should display news hashtags list', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('news'),
      ).thenAnswer((_) async => mockNewsHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on News tab
      await tester.tap(find.byKey(const Key('news_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('news_list')), findsOneWidget);
    });
  });

  group('ExplorePage - Sports Tab', () {
    testWidgets('should show empty state when no sports hashtags', (
      tester,
    ) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('sports'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Sports tab
      await tester.tap(find.byKey(const Key('sports_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sports_empty_text')), findsOneWidget);
      expect(find.text('No Sports Trending hashtags found'), findsOneWidget);
    });

    testWidgets('should display sports hashtags list', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockSportsHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('sports'),
      ).thenAnswer((_) async => mockSportsHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Sports tab
      await tester.tap(find.byKey(const Key('sports_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('sports_list')), findsOneWidget);
    });
  });

  group('ExplorePage - Entertainment Tab', () {
    testWidgets('should show empty state when no entertainment hashtags', (
      tester,
    ) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('entertainment'),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Entertainment tab
      await tester.tap(find.byKey(const Key('entertainment_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('entertainment_empty_text')), findsOneWidget);
      expect(
        find.text('No Entertainment Trending hashtags found'),
        findsOneWidget,
      );
    });

    testWidgets('should display entertainment hashtags list', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockEntertainmentHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('entertainment'),
      ).thenAnswer((_) async => mockEntertainmentHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Tap on Entertainment tab
      await tester.tap(find.byKey(const Key('entertainment_tab')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('entertainment_list')), findsOneWidget);
    });
  });

  group('ExplorePage - Error Handling', () {
    testWidgets('should display error when repository throws error', (
      tester,
    ) async {
      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenThrow(Exception('Network error'));

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });
  });

  group('ExplorePage - TabController Synchronization', () {
    testWidgets('should sync tab controller with state', (tester) async {
      final mockHashtags = createMockHashtags(5);
      final mockUsers = createMockUsers(5);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(3);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);
      when(
        () => mockRepo.getInterestHashtags('news'),
      ).thenAnswer((_) async => mockNewsHashtags);

      await tester.pumpWidget(createTestWidget(null));
      await tester.pumpAndSettle();

      // Get the TabBar widget
      final tabBar = tester.widget<TabBar>(find.byKey(ExplorePage.tabBarKey));
      final controller = tabBar.controller!;

      // Initial index should be 0 (For You)
      expect(controller.index, 0);

      // Tap News tab
      await tester.tap(find.byKey(const Key('news_tab')));
      await tester.pumpAndSettle();

      // Controller index should update to 2 (News)
      expect(controller.index, 2);
    });
  });
}
