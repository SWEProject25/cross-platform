import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/explore/ui/viewmodel/search_results_viewmodel.dart';
import 'package:lam7a/features/explore/ui/state/search_result_state.dart';
import 'package:lam7a/features/explore/repository/search_repository.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<TweetModel>[]);
    registerFallbackValue(<UserModel>[]);
  });

  setUp(() {
    mockRepo = MockSearchRepository();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
    );
  }

  List<TweetModel> createMockTweets(int count, {String prefix = 'tweet'}) {
    return List.generate(
      count,
      (i) => TweetModel(
        id: '${prefix}_$i',
        body: 'Tweet body $i',
        userId: 'user_$i',
        date: DateTime.now().subtract(Duration(hours: i)),
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

  group('SearchResultsViewModel - Initialization', () {
    test('should initialize with empty state', () async {
      container = createContainer();

      final state = await container.read(searchResultsViewModelProvider.future);

      expect(state.currentResultType, CurrentResultType.top);
      expect(state.topTweets, isEmpty);
      expect(state.latestTweets, isEmpty);
      expect(state.searchedPeople, isEmpty);
      expect(state.isTopLoading, true);
      expect(state.isLatestLoading, true);
      expect(state.isPeopleLoading, true);
    });

    test('should keep alive', () async {
      container = createContainer();

      await container.read(searchResultsViewModelProvider.future);
      await container.read(searchResultsViewModelProvider.future);

      // Provider should remain alive and not rebuild
      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state, isNotNull);
    });
  });

  group('SearchResultsViewModel - Search Function', () {
    test('should perform search with regular query', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');

      final state = container.read(searchResultsViewModelProvider).value!;

      expect(state.topTweets.length, 10);
      expect(state.hasMoreTop, true);
      expect(state.isTopLoading, false);
      expect(state.currentResultType, CurrentResultType.top);

      verify(() => mockRepo.searchTweets('flutter', 10, 1)).called(1);
    });

    test('should perform search with hashtag query', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');

      final state = container.read(searchResultsViewModelProvider).value!;

      expect(state.topTweets.length, 10);
      expect(state.hasMoreTop, true);

      verify(() => mockRepo.searchHashtagTweets('#flutter', 10, 1)).called(1);
    });

    test(
      'should set hasMoreTop to false when results less than limit',
      () async {
        container = createContainer();
        final mockTweets = createMockTweets(5);

        when(
          () => mockRepo.searchTweets('flutter', 10, 1),
        ).thenAnswer((_) async => mockTweets);

        final viewModel = container.read(
          searchResultsViewModelProvider.notifier,
        );
        await viewModel.search('flutter');

        final state = container.read(searchResultsViewModelProvider).value!;

        expect(state.topTweets.length, 5);
        expect(state.hasMoreTop, false);
      },
    );

    test('should not search again with same query', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.search('flutter'); // Same query

      verify(() => mockRepo.searchTweets('flutter', 10, 1)).called(1);
    });

    test('should search again with different query', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'flutter');
      final mockTweets2 = createMockTweets(10, prefix: 'dart');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchTweets('dart', 10, 1),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.search('dart'); // Different query

      verify(() => mockRepo.searchTweets('flutter', 10, 1)).called(1);
      verify(() => mockRepo.searchTweets('dart', 10, 1)).called(1);
    });

    test('should reset state on new search', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10);
      final mockTweets2 = createMockTweets(8);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchTweets('dart', 10, 1),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');

      var state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 10);

      await viewModel.search('dart');

      state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 8);
    });
  });

  group('SearchResultsViewModel - Tab Selection', () {
    test('should select top tab', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.top);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.currentResultType, CurrentResultType.top);
    });

    test('should select latest tab and load data if empty', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets = createMockTweets(10, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.latest);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.currentResultType, CurrentResultType.latest);
      expect(state.latestTweets.length, 10);
    });

    test('should select people tab and load data if empty', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.people);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.currentResultType, CurrentResultType.people);
      expect(state.searchedPeople.length, 10);
    });

    test('should not reload data if tab already has data', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.people);
      await viewModel.selectTab(CurrentResultType.people); // Select again

      verify(() => mockRepo.searchUsers('flutter', 10, 1)).called(1);
    });
  });

  group('SearchResultsViewModel - Load Top Tweets', () {
    test('should load top tweets with reset', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadTop(reset: true);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 10);
      expect(state.isTopLoading, false);
      expect(state.hasMoreTop, true);
    });

    test('should load more top tweets', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'batch1');
      final mockTweets2 = createMockTweets(10, prefix: 'batch2');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchTweets('flutter', 10, 2),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadMoreTop();

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 20);
    });

    test('should not load more top tweets if no more available', () async {
      container = createContainer();
      final mockTweets = createMockTweets(5);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');

      var state = container.read(searchResultsViewModelProvider).value!;
      expect(state.hasMoreTop, false);

      await viewModel.loadMoreTop();

      state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 5);
    });

    test('should handle hashtag search in loadTop', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadTop(reset: true);

      verify(() => mockRepo.searchHashtagTweets('#flutter', 10, 1)).called(2);
    });

    test('should handle hashtag search in loadMoreTop', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'batch1');
      final mockTweets2 = createMockTweets(10, prefix: 'batch2');

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 2),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadMoreTop();

      verify(() => mockRepo.searchHashtagTweets('#flutter', 10, 2)).called(1);
    });
  });

  group('SearchResultsViewModel - Load Latest Tweets', () {
    test('should load latest tweets with reset', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets = createMockTweets(10, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadLatest(reset: true);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.latestTweets.length, 10);
      expect(state.isLatestLoading, false);
      expect(state.hasMoreLatest, true);
    });

    test('should load more latest tweets', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets1 = createMockTweets(10, prefix: 'latest1');
      final mockLatestTweets2 = createMockTweets(10, prefix: 'latest2');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets1);

      when(
        () => mockRepo.searchTweets('flutter', 10, 2),
      ).thenAnswer((_) async => mockLatestTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadLatest(reset: true);
      await viewModel.loadMoreLatest();

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.latestTweets.length, 20);
    });

    test('should not load more latest tweets if no more available', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets = createMockTweets(5, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadLatest(reset: true);

      var state = container.read(searchResultsViewModelProvider).value!;
      expect(state.hasMoreLatest, false);

      await viewModel.loadMoreLatest();

      state = container.read(searchResultsViewModelProvider).value!;
      expect(state.latestTweets.length, 5);
    });

    test('should handle hashtag search in loadLatest', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchHashtagTweets(
          '#flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadLatest(reset: true);

      verify(
        () => mockRepo.searchHashtagTweets(
          '#flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).called(1);
    });

    test('should handle hashtag search in loadMoreLatest', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'batch1');
      final mockTweets2 = createMockTweets(10, prefix: 'batch2');

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchHashtagTweets(
          '#flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 2),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadLatest(reset: true);
      await viewModel.loadMoreLatest();

      verify(() => mockRepo.searchHashtagTweets('#flutter', 10, 2)).called(1);
    });
  });

  group('SearchResultsViewModel - Load People', () {
    test('should load people with reset', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadPeople(reset: true);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.searchedPeople.length, 10);
      expect(state.isPeopleLoading, false);
      expect(state.hasMorePeople, true);
    });

    test('should load more people', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers1 = createMockUsers(10);
      final mockUsers2 = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers1);

      when(
        () => mockRepo.searchUsers('flutter', 10, 2),
      ).thenAnswer((_) async => mockUsers2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadPeople(reset: true);
      await viewModel.loadMorePeople();

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.searchedPeople.length, 20);
    });

    test('should not load more people if no more available', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(5);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadPeople(reset: true);

      var state = container.read(searchResultsViewModelProvider).value!;
      expect(state.hasMorePeople, false);

      await viewModel.loadMorePeople();

      state = container.read(searchResultsViewModelProvider).value!;
      expect(state.searchedPeople.length, 5);
    });

    test('should handle hashtag in people search by removing #', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(10);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadPeople(reset: true);

      verify(() => mockRepo.searchUsers('flutter', 10, 1)).called(1);
    });

    test('should handle hashtag in loadMorePeople by removing #', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers1 = createMockUsers(10);
      final mockUsers2 = createMockUsers(10);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers1);

      when(
        () => mockRepo.searchUsers('flutter', 10, 2),
      ).thenAnswer((_) async => mockUsers2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('#flutter');
      await viewModel.loadPeople(reset: true);
      await viewModel.loadMorePeople();

      verify(() => mockRepo.searchUsers('flutter', 10, 2)).called(1);
    });
  });

  group('SearchResultsViewModel - Refresh Current Tab', () {
    test('should refresh top tab', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.searchTweets('flutter', 10, 1)).called(2);
    });

    test('should refresh latest tab', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets = createMockTweets(10, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.latest);
      await viewModel.refreshCurrentTab();

      verify(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).called(2);
    });

    test('should refresh people tab', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);
      final mockUsers = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.people);
      await viewModel.refreshCurrentTab();

      verify(() => mockRepo.searchUsers('flutter', 10, 1)).called(2);
    });
  });

  group('SearchResultsViewModel - Edge Cases', () {
    test('should handle empty search results', () async {
      container = createContainer();

      when(
        () => mockRepo.searchTweets('nonexistent', 10, 1),
      ).thenAnswer((_) async => []);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('nonexistent');

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets, isEmpty);
      expect(state.hasMoreTop, false);
    });

    test('should handle concurrent loadMore requests', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'batch1');
      final mockTweets2 = createMockTweets(10, prefix: 'batch2');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchTweets('flutter', 10, 2),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');

      // Try to load more twice concurrently
      await Future.wait([viewModel.loadMoreTop(), viewModel.loadMoreTop()]);

      // Should only load once due to _isLoadingMore flag
      verify(() => mockRepo.searchTweets('flutter', 10, 2)).called(1);
    });

    test(
      'should handle page counter correctly across multiple loads',
      () async {
        container = createContainer();
        final mockTweets1 = createMockTweets(10, prefix: 'page1');
        final mockTweets2 = createMockTweets(10, prefix: 'page2');
        final mockTweets3 = createMockTweets(10, prefix: 'page3');

        when(
          () => mockRepo.searchTweets('flutter', 10, 1),
        ).thenAnswer((_) async => mockTweets1);

        when(
          () => mockRepo.searchTweets('flutter', 10, 2),
        ).thenAnswer((_) async => mockTweets2);

        when(
          () => mockRepo.searchTweets('flutter', 10, 3),
        ).thenAnswer((_) async => mockTweets3);

        final viewModel = container.read(
          searchResultsViewModelProvider.notifier,
        );
        await viewModel.search('flutter');
        await viewModel.loadMoreTop();
        await viewModel.loadMoreTop();

        final state = container.read(searchResultsViewModelProvider).value!;
        expect(state.topTweets.length, 30);

        verify(() => mockRepo.searchTweets('flutter', 10, 1)).called(1);
        verify(() => mockRepo.searchTweets('flutter', 10, 2)).called(1);
        verify(() => mockRepo.searchTweets('flutter', 10, 3)).called(1);
      },
    );

    test('should handle mixed regular and hashtag queries', () async {
      container = createContainer();
      final mockRegularTweets = createMockTweets(10, prefix: 'regular');
      final mockHashtagTweets = createMockTweets(10, prefix: 'hashtag');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockRegularTweets);

      when(
        () => mockRepo.searchHashtagTweets('#flutter', 10, 1),
      ).thenAnswer((_) async => mockHashtagTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);

      await viewModel.search('flutter');
      var state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.first.id, 'regular_0');

      await viewModel.search('#flutter');
      state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.first.id, 'hashtag_0');
    });

    test('should maintain separate page counters for different tabs', () async {
      container = createContainer();
      final mockTopTweets1 = createMockTweets(10, prefix: 'top1');
      final mockTopTweets2 = createMockTweets(10, prefix: 'top2');
      final mockLatestTweets1 = createMockTweets(10, prefix: 'latest1');
      final mockPeople1 = createMockUsers(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets1);

      when(
        () => mockRepo.searchTweets('flutter', 10, 2),
      ).thenAnswer((_) async => mockTopTweets2);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets1);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockPeople1);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadMoreTop();

      await viewModel.selectTab(CurrentResultType.latest);
      await viewModel.selectTab(CurrentResultType.people);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 20);
      expect(state.latestTweets.length, 10);
      expect(state.searchedPeople.length, 10);
    });

    test('should reset page counters on new search', () async {
      container = createContainer();
      final mockTweets1 = createMockTweets(10, prefix: 'first');
      final mockTweets2 = createMockTweets(10, prefix: 'second');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets1);

      when(
        () => mockRepo.searchTweets('dart', 10, 1),
      ).thenAnswer((_) async => mockTweets2);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.search('dart');

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.first.id, 'second_0');
      expect(state.topTweets.length, 10);
    });

    test('should handle loading states correctly', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(() => mockRepo.searchTweets('flutter', 10, 1)).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 100));
        return mockTweets;
      });

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      final searchFuture = viewModel.search('flutter');

      // Check loading state
      final loadingState = container.read(searchResultsViewModelProvider);
      expect(loadingState.isLoading, true);

      await searchFuture;

      final finalState = container.read(searchResultsViewModelProvider).value!;
      expect(finalState.isTopLoading, false);
      expect(finalState.topTweets.length, 10);
    });

    test('should handle empty users list', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => []);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.loadPeople(reset: true);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.searchedPeople, isEmpty);
      expect(state.hasMorePeople, false);
    });

    test('should handle query with special characters', () async {
      container = createContainer();
      final mockTweets = createMockTweets(10);

      when(
        () => mockRepo.searchTweets('flutter & dart', 10, 1),
      ).thenAnswer((_) async => mockTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter & dart');

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 10);

      verify(() => mockRepo.searchTweets('flutter & dart', 10, 1)).called(1);
    });
  });

  group('SearchResultsViewModel - State Persistence', () {
    test('should maintain state after tab switches', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockLatestTweets = createMockTweets(10, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.latest);
      await viewModel.selectTab(CurrentResultType.top);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 10);
      expect(state.latestTweets.length, 10);
      expect(state.currentResultType, CurrentResultType.top);
    });

    test('should preserve data across multiple operations', () async {
      container = createContainer();
      final mockTopTweets = createMockTweets(10, prefix: 'top');
      final mockUsers = createMockUsers(10);
      final mockLatestTweets = createMockTweets(10, prefix: 'latest');

      when(
        () => mockRepo.searchTweets('flutter', 10, 1),
      ).thenAnswer((_) async => mockTopTweets);

      when(
        () => mockRepo.searchUsers('flutter', 10, 1),
      ).thenAnswer((_) async => mockUsers);

      when(
        () => mockRepo.searchTweets(
          'flutter',
          10,
          1,
          tweetsOrder: 'latest',
          time: any(named: 'time'),
        ),
      ).thenAnswer((_) async => mockLatestTweets);

      final viewModel = container.read(searchResultsViewModelProvider.notifier);
      await viewModel.search('flutter');
      await viewModel.selectTab(CurrentResultType.people);
      await viewModel.selectTab(CurrentResultType.latest);
      await viewModel.selectTab(CurrentResultType.top);

      final state = container.read(searchResultsViewModelProvider).value!;
      expect(state.topTweets.length, 10);
      expect(state.searchedPeople.length, 10);
      expect(state.latestTweets.length, 10);
    });
  });
}
