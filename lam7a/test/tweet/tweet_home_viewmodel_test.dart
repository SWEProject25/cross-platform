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

  group('TweetHomeViewModel Tests', () {
    test('build fetches initial tweets', () async {
      final tweetsForYou = [TweetModel(id: '1', userId: '1', body: 'Tweet 1', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: [])];
      final tweetsFollowing = [TweetModel(id: '2', userId: '2', body: 'Tweet 2', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: [])];

      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => tweetsForYou);
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => tweetsFollowing);

      final state = await container.read(tweetHomeViewModelProvider.future);

      expect(state['for-you'], tweetsForYou);
      expect(state['following'], tweetsFollowing);
      
      verify(() => mockRepository.fetchTweets(5, 1, 'for-you')).called(1);
      verify(() => mockRepository.fetchTweets(5, 1, 'following')).called(1);
    });

    test('loadMoreTweets appends tweets', () async {
      // 1. Initial Load - provide full page to keep _hasMoreForYou = true
      final initialTweets = List.generate(5, (i) => TweetModel(
        id: '${i+1}', 
        userId: '1', 
        body: 'Tweet ${i+1}', 
        date: DateTime.now(), 
        likes: 0, 
        repost: 0, 
        comments: 0, 
        views: 0, 
        qoutes: 0, 
        bookmarks: 0, 
        mediaImages: [], 
        mediaVideos: []
      ));
      
      when(() => mockRepository.fetchTweets(any(), 1, 'for-you')).thenAnswer((_) async => initialTweets);
      when(() => mockRepository.fetchTweets(any(), 1, 'following')).thenAnswer((_) async => []);

      await container.read(tweetHomeViewModelProvider.future);

      // 2. Load More
      final moreTweets = [TweetModel(id: '10', userId: '1', body: 'Tweet 10', date: DateTime.now(), likes: 0, repost: 0, comments: 0, views: 0, qoutes: 0, bookmarks: 0, mediaImages: [], mediaVideos: [])];
      when(() => mockRepository.fetchTweets(any(), 2, 'for-you')).thenAnswer((_) async => moreTweets);

      await container.read(tweetHomeViewModelProvider.notifier).loadMoreTweets('for-you');

      final state = await container.read(tweetHomeViewModelProvider.future);
      expect(state['for-you']!.length, 6); // 5 initial + 1 more
      expect(state['for-you']!.last.id, '10');
    });

    test('refreshTweets reloads data', () async {
       when(() => mockRepository.fetchTweets(any(), 1, 'for-you')).thenAnswer((_) async => []);
       when(() => mockRepository.fetchTweets(any(), 1, 'following')).thenAnswer((_) async => []);

       // Trigger build
       await container.read(tweetHomeViewModelProvider.future);

       await container.read(tweetHomeViewModelProvider.notifier).refreshTweets();

       verify(() => mockRepository.fetchTweets(5, 1, 'for-you')).called(2); // Once for build, once for refresh
    });

    test('refreshFollowingTweets refreshes following and preserves for-you',
          () async {
      final tweetsForYou = [
        TweetModel(
          id: '1',
          userId: '1',
          body: 'For you 1',
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

      final tweetsFollowing = [
        TweetModel(
          id: '2',
          userId: '2',
          body: 'Following 1',
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

      when(() => mockRepository.fetchTweets(any(), any(), 'for-you'))
          .thenAnswer((_) async => tweetsForYou);
      when(() => mockRepository.fetchTweets(any(), any(), 'following'))
          .thenAnswer((_) async => tweetsFollowing);

      await container.read(tweetHomeViewModelProvider.future);

      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      expect(notifier.hasMoreFollowing, isFalse);

      await notifier.refreshFollowingTweets();

      final state = notifier.state.value!;
      expect(state['for-you'], tweetsForYou);
      expect(state['following'], tweetsFollowing);

      expect(notifier.hasMoreFollowing, isTrue);
      expect(notifier.isLoadingMore, isFalse);
      expect(notifier.hasMoreForYou, isFalse);
    });

    test('upsertTweetLocally inserts when no for-you list present', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);
      final newTweet = TweetModel(
        id: '10',
        userId: '1',
        body: 'New tweet',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      );

      notifier.state = AsyncValue.data({
        'following': <TweetModel>[],
      });

      notifier.upsertTweetLocally(newTweet);

      final state = notifier.state.value!;
      expect(state['for-you'], isNotNull);
      expect(state['for-you']!.length, 1);
      expect(state['for-you']!.first.id, '10');
      expect(state['following'], isEmpty);
    });

    test('upsertTweetLocally prepends tweet and removes duplicates', () {
      final notifier = container.read(tweetHomeViewModelProvider.notifier);

      final existingTweet = TweetModel(
        id: '1',
        userId: '1',
        body: 'Existing',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      );

      final otherTweet = TweetModel(
        id: '2',
        userId: '1',
        body: 'Other',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      );

      notifier.state = AsyncValue.data({
        'for-you': [existingTweet, otherTweet],
        'following': <TweetModel>[],
      });

      final updatedExisting = TweetModel(
        id: '1',
        userId: '1',
        body: 'Updated',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      );

      notifier.upsertTweetLocally(updatedExisting);

      final state = notifier.state.value!;
      final forYou = state['for-you']!;

      expect(forYou.length, 2);
      expect(forYou.first.id, '1');
      expect(forYou.first.body, 'Updated');
      expect(forYou[1].id, '2');
      expect(state['following'], isEmpty);
    });
  });
}
