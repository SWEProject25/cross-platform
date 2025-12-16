import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';

class MockTweetRepository extends Mock implements TweetRepository {}

void main() {
  late ProviderContainer container;
  late MockTweetRepository mockRepository;

  setUp(() {
    mockRepository = MockTweetRepository();
    container = ProviderContainer(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TweetHomeViewModel - build and initial fetch', () {
    test('build fetches initial tweets for first time', () async {
      final tweetsForYou = List.generate(
        5,
        (i) => TweetModel(
          id: '$i',
          userId: '1',
          body: 'Tweet $i',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => tweetsForYou);

      final state = await container.read(tweetHomeViewModelProvider.future);

      expect(state['for-you'], tweetsForYou);
      expect(state['following'], isEmpty);

      verify(() => mockRepository.fetchTweetsForYou(5, 1)).called(1);
    });

    test('build returns cached tweets if already loaded', () async {
      final tweetsForYou = [
        TweetModel(
          id: '1',
          userId: '1',
          body: 'Tweet 1',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      ];

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => tweetsForYou);

      // First call - loads from API
      await container.read(tweetHomeViewModelProvider.future);

      // Second call - should return cached
      final state2 = await container.read(tweetHomeViewModelProvider.future);

      expect(state2['for-you'], tweetsForYou);
      // Should only call API once, not twice
      verify(() => mockRepository.fetchTweetsForYou(5, 1)).called(1);
    });

    test('_fetchInitialTweets sets hasMoreForYou to true when full page returned',
        () async {
      final tweetsForYou = List.generate(
        5,
        (i) => TweetModel(
          id: '$i',
          userId: '1',
          body: 'Tweet $i',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => tweetsForYou);

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.hasMoreForYou, isTrue);
    });

    test('_fetchInitialTweets sets hasMoreForYou to false when less than page size',
        () async {
      final tweetsForYou = [
        TweetModel(
          id: '1',
          userId: '1',
          body: 'Tweet 1',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      ];

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => tweetsForYou);

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.hasMoreForYou, isFalse);
    });
  });

  group('TweetHomeViewModel - isFollowingEmptyInState', () {
    test('returns true when following list is empty', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.isFollowingEmptyInState(), isTrue);
    });

    test('returns true when state value is null', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = const AsyncValue.loading();

      expect(notifier.isFollowingEmptyInState(), isTrue);
    });

    test('returns false when following list has tweets', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = AsyncValue.data({
        'for-you': <TweetModel>[],
        'following': [
          TweetModel(
            id: '1',
            userId: '1',
            body: 'Following tweet',
            date: DateTime.now(),
            likes: 0,
            repost: 0,
            comments: 0,
            views: 0,
            qoutes: 0,
            bookmarks: 0,
            mediaImages: [],
            mediaVideos: [],
          ),
        ],
      });

      expect(notifier.isFollowingEmptyInState(), isFalse);
    });
  });

  group('TweetHomeViewModel - loadMoreTweetsForYou', () {
    test('appends new tweets to for-you list', () async {
      final initialTweets = List.generate(
        5,
        (i) => TweetModel(
          id: '$i',
          userId: '1',
          body: 'Tweet $i',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => initialTweets);

      await container.read(tweetHomeViewModelProvider.future);

      final moreTweets = List.generate(
        3,
        (i) => TweetModel(
          id: '${i + 10}',
          userId: '1',
          body: 'Tweet ${i + 10}',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      );

      when(() => mockRepository.fetchTweetsForYou(5, 2))
          .thenAnswer((_) async => moreTweets);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.loadMoreTweetsForYou();

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 8);
      expect(state['for-you']![5].id, '10');
    });

    test('does not load more if already loading', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      await container.read(tweetHomeViewModelProvider.future);

      when(() => mockRepository.fetchTweetsForYou(5, 2))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      // Start first load (won't await)
      notifier.loadMoreTweetsForYou();

      // Try second load immediately - should be ignored
      await notifier.loadMoreTweetsForYou();

      // Only called once
      verify(() => mockRepository.fetchTweetsForYou(5, 2)).called(1);
    });

    test('does not load more if hasMoreForYou is false', () async {
      final tweets = [
        TweetModel(
          id: '1',
          userId: '1',
          body: 'Tweet 1',
          date: DateTime.now(),
          likes: 0,
          repost: 0,
          comments: 0,
          views: 0,
          qoutes: 0,
          bookmarks: 0,
          mediaImages: [],
          mediaVideos: [],
        ),
      ];

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => tweets);

      await container.read(tweetHomeViewModelProvider.future);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      expect(notifier.hasMoreForYou, isFalse);

      await notifier.loadMoreTweetsForYou();

      verifyNever(() => mockRepository.fetchTweetsForYou(5, 2));
    });

    test('sets hasMoreForYou to false when no more tweets returned', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      await container.read(tweetHomeViewModelProvider.future);

      when(() => mockRepository.fetchTweetsForYou(5, 2))
          .thenAnswer((_) async => []);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.loadMoreTweetsForYou();

      expect(notifier.hasMoreForYou, isFalse);
    });

    test('filters duplicate tweets when loading more', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      await container.read(tweetHomeViewModelProvider.future);

      // Return mix of new and duplicate tweets
      final moreTweets = [
        TweetModel(id: '2', userId: '1', body: 'Duplicate', date: DateTime.now(),
          likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
          bookmarks: 0, mediaImages: [], mediaVideos: []),
        TweetModel(id: '10', userId: '1', body: 'New', date: DateTime.now(),
          likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
          bookmarks: 0, mediaImages: [], mediaVideos: []),
      ];

      when(() => mockRepository.fetchTweetsForYou(5, 2))
          .thenAnswer((_) async => moreTweets);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.loadMoreTweetsForYou();

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 6); // 5 initial + 1 new (duplicate filtered)
    });

    test('sets hasMoreForYou to false on exception', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      await container.read(tweetHomeViewModelProvider.future);

      when(() => mockRepository.fetchTweetsForYou(5, 2))
          .thenThrow(Exception('Network error'));

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.loadMoreTweetsForYou();

      expect(notifier.hasMoreForYou, isFalse);
      expect(notifier.isLoadingMore, isFalse);
    });
  });

  group('TweetHomeViewModel - loadMoreTweetsFollowing', () {
    test('appends new tweets to following list', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      // First load following tweets to set _hasMoreFollowing = true
      when(() => mockRepository.fetchTweetsFollowing(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.refreshFollowingTweets();

      when(() => mockRepository.fetchTweetsFollowing(5, 2))
          .thenAnswer((_) async => [TweetModel(
            id: '10', userId: '1', body: 'Following 10', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])]);

      await notifier.loadMoreTweetsFollowing();

      final state = notifier.state.value!;
      expect(state['following']!.length, 6);
    });

    test('does not load more if already loading', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      
      // _hasMoreFollowing defaults to true, _currentPageFollowing = 1
      // loadMoreTweetsFollowing will try to fetch page 2
      when(() => mockRepository.fetchTweetsFollowing(5, 2))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return [];
      });

      // Start first load (won't await)
      notifier.loadMoreTweetsFollowing();

      // Try second load immediately - should be ignored because _isLoadingMore is true
      await notifier.loadMoreTweetsFollowing();

      // Should only call once despite two calls
      verify(() => mockRepository.fetchTweetsFollowing(5, 2)).called(1);
    });

    test('sets hasMoreFollowing to false when empty response', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = AsyncValue.data({
        'for-you': <TweetModel>[],
        'following': List.generate(5, (i) => TweetModel(
          id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
          likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
          bookmarks: 0, mediaImages: [], mediaVideos: [])),
      });

      when(() => mockRepository.fetchTweetsFollowing(5, 2))
          .thenAnswer((_) async => []);

      await notifier.loadMoreTweetsFollowing();

      expect(notifier.hasMoreFollowing, isFalse);
    });
  });

  group('TweetHomeViewModel - refreshTweetsForYou', () {
    test('resets to page 1 and refetches for-you tweets', () async {
      final initialTweets = List.generate(5, (i) => TweetModel(
        id: '$i', userId: '1', body: 'Initial $i', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: []));

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => initialTweets);

      await container.read(tweetHomeViewModelProvider.future);

      final refreshedTweets = List.generate(3, (i) => TweetModel(
        id: 'new$i', userId: '1', body: 'Refreshed $i', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: []));

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => refreshedTweets);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.refreshTweetsForYou();

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 3);
      expect(state['for-you']![0].id, 'new0');
    });

    test('sets state to loading during refresh', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return [];
      });

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      final refreshFuture = notifier.refreshTweetsForYou();

      // Check loading state
      expect(notifier.state.isLoading, isTrue);

      await refreshFuture;
    });
  });

  group('TweetHomeViewModel - refreshFollowingTweets', () {
    test('refreshes following and preserves for-you', () async {
      final forYouTweets = [TweetModel(
        id: '1', userId: '1', body: 'For you', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: [])];

      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => forYouTweets);

      await container.read(tweetHomeViewModelProvider.future);

      final followingTweets = [TweetModel(
        id: '2', userId: '2', body: 'Following', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: [])];

      when(() => mockRepository.fetchTweetsFollowing(5, 1))
          .thenAnswer((_) async => followingTweets);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.refreshFollowingTweets();

      final state = notifier.state.value!;
      expect(state['for-you'], forYouTweets);
      expect(state['following'], followingTweets);
    });

    test('updates hasMoreFollowing based on response', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      when(() => mockRepository.fetchTweetsFollowing(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      await notifier.refreshFollowingTweets();

      expect(notifier.hasMoreFollowing, isTrue);
    });
  });

  group('TweetHomeViewModel - upsertTweetLocally', () {
    test('creates for-you list when null and inserts tweet', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = AsyncValue.data({'following': <TweetModel>[]});

      final newTweet = TweetModel(
        id: '10', userId: '1', body: 'New', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: []);

      notifier.upsertTweetLocally(newTweet);

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 1);
      expect(state['for-you']![0].id, '10');
    });

    test('prepends new tweet to existing for-you list', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = AsyncValue.data({
        'for-you': [TweetModel(
          id: '1', userId: '1', body: 'Existing', date: DateTime.now(),
          likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
          bookmarks: 0, mediaImages: [], mediaVideos: [])],
        'following': <TweetModel>[],
      });

      final newTweet = TweetModel(
        id: '2', userId: '1', body: 'New', date: DateTime.now(),
        likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
        bookmarks: 0, mediaImages: [], mediaVideos: []);

      notifier.upsertTweetLocally(newTweet);

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 2);
      expect(state['for-you']![0].id, '2');
      expect(state['for-you']![1].id, '1');
    });

    test('updates existing tweet and moves to front', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      notifier.state = AsyncValue.data({
        'for-you': [
          TweetModel(id: '1', userId: '1', body: 'First', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: []),
          TweetModel(id: '2', userId: '1', body: 'Second', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: []),
        ],
        'following': <TweetModel>[],
      });

      final updated = TweetModel(
        id: '2', userId: '1', body: 'Updated Second', date: DateTime.now(),
        likes: 10, repost: 5, comments: 2, views: 100, qoutes: 1,
        bookmarks: 3, mediaImages: [], mediaVideos: []);

      notifier.upsertTweetLocally(updated);

      final state = notifier.state.value!;
      expect(state['for-you']!.length, 2);
      expect(state['for-you']![0].id, '2');
      expect(state['for-you']![0].body, 'Updated Second');
      expect(state['for-you']![0].likes, 10);
      expect(state['for-you']![1].id, '1');
    });
  });

  group('TweetHomeViewModel - getters', () {
    test('hasMoreForYou returns correct value', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.hasMoreForYou, isTrue);
    });

    test('hasMoreFollowing defaults to true and changes after empty response', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      // Initially true (default value)
      expect(notifier.hasMoreFollowing, isTrue);
      
      // After refreshing with empty response, should be false
      when(() => mockRepository.fetchTweetsFollowing(5, 1))
          .thenAnswer((_) async => []);
      
      await notifier.refreshFollowingTweets();
      expect(notifier.hasMoreFollowing, isFalse);
      
      // After refreshing with full page, should be true again
      when(() => mockRepository.fetchTweetsFollowing(5, 1))
          .thenAnswer((_) async => List.generate(5, (i) => TweetModel(
            id: '$i', userId: '1', body: 'Tweet $i', date: DateTime.now(),
            likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0,
            bookmarks: 0, mediaImages: [], mediaVideos: [])));
      
      await notifier.refreshFollowingTweets();
      expect(notifier.hasMoreFollowing, isTrue);
    });

    test('isLoadingMore returns false initially', () async {
      when(() => mockRepository.fetchTweetsForYou(5, 1))
          .thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.isLoadingMore, isFalse);
    });
  });
}
