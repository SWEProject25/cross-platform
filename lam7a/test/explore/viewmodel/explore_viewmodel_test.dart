import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/Explore/ui/viewmodel/explore_viewmodel.dart';
import 'package:lam7a/features/Explore/ui/state/explore_state.dart';
import 'package:lam7a/features/Explore/repository/explore_repository.dart';
import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';

class MockExploreRepository extends Mock implements ExploreRepository {}

void main() {
  late MockExploreRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<TrendingHashtag>[]);
    registerFallbackValue(<UserModel>[]);
    registerFallbackValue(<String, List<TweetModel>>{});
    registerFallbackValue(<TweetModel>[]);
  });

  setUp(() {
    mockRepo = MockExploreRepository();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [exploreRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  List<TrendingHashtag> createMockHashtags(int count) {
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
      'news': [
        TweetModel(
          id: 'tweet_2',
          body: 'News tweet',
          userId: 'user_2',
          date: DateTime.now(),
          likes: 15,
          qoutes: 1,
          bookmarks: 3,
          repost: 5,
          comments: 10,
          views: 200,
          username: 'user2',
          authorName: 'User 2',
          authorProfileImage: null,
          mediaImages: [],
          mediaVideos: [],
        ),
      ],
    };
  }

  group('ExploreViewModel - Initialization', () {
    test('should initialize with correct data', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      await container.read(exploreViewModelProvider.future);

      final state = container.read(exploreViewModelProvider).value!;

      expect(state.forYouHashtags.length, 5);
      expect(state.suggestedUsers.length, 5);
      expect(state.interestBasedTweets, isNotEmpty);
      expect(state.isForYouHashtagsLoading, false);
      expect(state.isSuggestedUsersLoading, false);
      expect(state.isInterestMapLoading, false);

      verify(() => mockRepo.getTrendingHashtags()).called(1);
      verify(() => mockRepo.getSuggestedUsers(limit: 7)).called(1);
      verify(() => mockRepo.getForYouTweets(10)).called(1);
    });

    test('should keep alive and not reinitialize', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      await container.read(exploreViewModelProvider.future);
      await container.read(exploreViewModelProvider.future);

      verify(() => mockRepo.getTrendingHashtags()).called(1);
      verify(() => mockRepo.getSuggestedUsers(limit: 7)).called(1);
      verify(() => mockRepo.getForYouTweets(10)).called(1);
    });
  });

  group('ExploreViewModel - Tab Selection', () {
    test('should select For You tab and load data if empty', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.forYou);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.selectedPage, ExplorePageView.forYou);
    });

    test('should select Trending tab and load data if empty', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.trending);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.selectedPage, ExplorePageView.trending);
      expect(state.trendingHashtags.isNotEmpty, true);
    });

    test('should select News tab and load data if empty', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreNews);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.selectedPage, ExplorePageView.exploreNews);
      expect(state.newsHashtags.length, 5);
    });

    test('should select Sports tab and load data if empty', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockSportsHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreSports);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.selectedPage, ExplorePageView.exploreSports);
      expect(state.sportsHashtags.length, 5);
    });

    test('should select Entertainment tab and load data if empty', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockEntertainmentHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreEntertainment);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.selectedPage, ExplorePageView.exploreEntertainment);
      expect(state.entertainmentHashtags.length, 5);
    });
  });

  group('ExploreViewModel - Load Methods', () {
    test('loadForYou should load and randomize data', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadForYou(reset: true);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.forYouHashtags.length, 5);
      expect(state.suggestedUsers.length, 5);
      expect(state.isForYouHashtagsLoading, false);
      expect(state.isSuggestedUsersLoading, false);
    });

    test('loadTrending should load trending hashtags', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadTrending(reset: true);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.trendingHashtags.length, 10);
      expect(state.isHashtagsLoading, false);
    });

    test('loadNews should load news hashtags', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(8);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadNews(reset: true);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.newsHashtags.length, 8);
      expect(state.isNewsHashtagsLoading, false);
    });

    test('loadSports should load sports hashtags', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockSportsHashtags = createMockHashtags(6);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadSports(reset: true);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.sportsHashtags.length, 6);
      expect(state.isSportsHashtagsLoading, false);
    });

    test('loadEntertainment should load entertainment hashtags', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockEntertainmentHashtags = createMockHashtags(7);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadEntertainment(reset: true);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.entertainmentHashtags.length, 7);
      expect(state.isEntertainmentHashtagsLoading, false);
    });

    test('loadForYou without reset should append data', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadForYou(reset: false);

      verify(() => mockRepo.getTrendingHashtags()).called(2);
    });
  });

  group('ExploreViewModel - Refresh Current Tab', () {
    test('should refresh For You tab', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.getTrendingHashtags()).called(2);
    });

    test('should refresh Trending tab', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.trending);
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.getTrendingHashtags()).called(3);
    });

    test('should refresh News tab', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockNewsHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreNews);
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.getInterestHashtags('news')).called(2);
    });

    test('should refresh Sports tab', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockSportsHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreSports);
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.getInterestHashtags('sports')).called(2);
    });

    test('should refresh Entertainment tab', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockEntertainmentHashtags = createMockHashtags(5);

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

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.selectTab(ExplorePageView.exploreEntertainment);
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.getInterestHashtags('entertainment')).called(2);
    });
  });

  group('ExploreViewModel - Interest Tweets', () {
    test('loadIntresesTweets should load tweets for interest', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockInterestTweets = List.generate(
        10,
        (i) => TweetModel(
          id: 'tweet_$i',
          body: 'Interest tweet $i',
          userId: 'user_$i',
          date: DateTime.now(),
          likes: 10 + i,
          qoutes: i,
          bookmarks: 5 + i,
          repost: 3 + i,
          comments: 7 + i,
          views: 100 + i,
          username: 'user$i',
          authorName: 'User $i',
          authorProfileImage: null,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

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
        () => mockRepo.getExploreTweetsWithFilter(any(), any(), 'sports'),
      ).thenAnswer((_) async => mockInterestTweets);

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadIntresesTweets('sports');

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.intrestTweets.length, 10);
      expect(state.isIntrestTweetsLoading, false);
      expect(state.hasMoreIntrestTweets, true);
    });

    test('loadMoreInterestedTweets should load more tweets', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockInterestTweets = List.generate(
        10,
        (i) => TweetModel(
          id: 'tweet_$i',
          body: 'Interest tweet $i',
          userId: 'user_$i',
          date: DateTime.now(),
          likes: 10 + i,
          qoutes: i,
          bookmarks: 5 + i,
          repost: 3 + i,
          comments: 7 + i,
          views: 100 + i,
          username: 'user$i',
          authorName: 'User $i',
          authorProfileImage: null,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

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
        () => mockRepo.getExploreTweetsWithFilter(any(), any(), 'sports'),
      ).thenAnswer((_) async => mockInterestTweets);

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadIntresesTweets('sports');
      await viewModel.loadMoreInterestedTweets('sports');

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.intrestTweets.length, 20);
    });

    test('loadMoreInterestedTweets should not load if no more data', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockInterestTweets = List.generate(
        5,
        (i) => TweetModel(
          id: 'tweet_$i',
          body: 'Interest tweet $i',
          userId: 'user_$i',
          date: DateTime.now(),
          likes: 10 + i,
          qoutes: i,
          bookmarks: 5 + i,
          repost: 3 + i,
          comments: 7 + i,
          views: 100 + i,
          username: 'user$i',
          authorName: 'User $i',
          authorProfileImage: null,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

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
        () => mockRepo.getExploreTweetsWithFilter(any(), any(), 'sports'),
      ).thenAnswer((_) async => mockInterestTweets);

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadIntresesTweets('sports');
      await viewModel.loadMoreInterestedTweets('sports');

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.intrestTweets.length, 5);
      expect(state.hasMoreIntrestTweets, false);
    });
  });

  group('ExploreViewModel - Suggested Users', () {
    test('loadSuggestedUsers should load full list of users', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();
      final mockSuggestedUsersFull = createMockUsers(30);

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenAnswer((_) async => mockHashtags);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getSuggestedUsers(limit: 30),
      ).thenAnswer((_) async => mockSuggestedUsersFull);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      final viewModel = container.read(exploreViewModelProvider.notifier);
      await container.read(exploreViewModelProvider.future);

      await viewModel.loadSuggestedUsers();

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.suggestedUsersFull.length, 30);
      expect(state.isSuggestedUsersLoading, false);
    });
  });

  group('ExploreViewModel - Edge Cases', () {
    test('should handle fewer than 7 suggested users', () async {
      container = createContainer();

      final mockHashtags = createMockHashtags(10);
      final mockUsers = createMockUsers(3);
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

      await container.read(exploreViewModelProvider.future);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.suggestedUsers.length, lessThanOrEqualTo(3));
    });

    test('should handle empty hashtags list', () async {
      container = createContainer();

      final mockUsers = createMockUsers(7);
      final mockForYouTweets = createMockForYouTweets();

      when(() => mockRepo.getTrendingHashtags()).thenAnswer((_) async => []);
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenAnswer((_) async => mockUsers);
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenAnswer((_) async => mockForYouTweets);

      await container.read(exploreViewModelProvider.future);

      final state = container.read(exploreViewModelProvider).value!;
      expect(state.forYouHashtags, isEmpty);
    });

    test('should handle repository errors', () async {
      container = createContainer();

      when(
        () => mockRepo.getTrendingHashtags(),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockRepo.getSuggestedUsers(limit: 7),
      ).thenThrow(Exception('Network error'));
      when(
        () => mockRepo.getForYouTweets(any()),
      ).thenThrow(Exception('Network error'));

      expect(container.read(exploreViewModelProvider.future), throwsException);
    });
  });
}
