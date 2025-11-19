import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mocktail/mocktail.dart';

/// ---- MOCK CLASSES ----
class MockTweetRepository extends Mock implements TweetRepository {}

class TestVSync implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class MockTweetsApiService extends Mock implements TweetsApiService {}

class MockPostInteractionsService extends Mock
    implements PostInteractionsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockTweetRepository mockRepo;
  late MockTweetsApiService mockTweetsApiService;
  late MockPostInteractionsService mockInteractionsService;
  const tweetId = 't1';

  final testTweet = TweetModel(
    id: tweetId,
    body: 'Hello world',
    mediaPic: null,
    mediaVideo: null,
    date: DateTime(2025, 1, 1),
    likes: 5,
    qoutes: 2,
    bookmarks: 1,
    repost: 3,
    comments: 4,
    views: 10,
    userId: 'u1',
  );

  setUpAll(() {
    registerFallbackValue(testTweet);
  });

  setUp(() {
    mockRepo = MockTweetRepository();
    mockTweetsApiService = MockTweetsApiService();
    mockInteractionsService = MockPostInteractionsService();
    container = ProviderContainer(
      overrides: [
        tweetRepositoryProvider.overrideWithValue(mockRepo),
        tweetsApiServiceProvider.overrideWith((ref) => mockTweetsApiService),
        postInteractionsServiceProvider
            .overrideWithValue(mockInteractionsService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TweetViewModel Tests', () {
    test('Initial state builds correctly', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      final state = await viewModel.build(tweetId);

      expect(state.isLiked, false);
      expect(state.isReposted, false);
      expect(state.isViewed, false);
      expect(state.tweet.value!.body, equals('Hello world'));
    });

    test('handleLike increments likes when not liked', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);
      when(() => mockInteractionsService.toggleLike(tweetId))
          .thenAnswer((_) async => true);
      when(() => mockInteractionsService.getLikesCount(tweetId))
          .thenAnswer((_) async => 6);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(milliseconds: 1),
      );

      await viewModel.handleLike(controller: controller);
      final updated = viewModel.state.value!;

      expect(updated.isLiked, true);
      expect(updated.tweet.value!.likes, 6);
    });

    test('handleLike decrements likes when already liked', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);
      var toggleCalls = 0;
      when(() => mockInteractionsService.toggleLike(tweetId))
          .thenAnswer((_) async {
        toggleCalls++;
        // true on first call (like), false on second call (unlike)
        return toggleCalls == 1;
      });
      var likesCountCalls = 0;
      when(() => mockInteractionsService.getLikesCount(tweetId))
          .thenAnswer((_) async {
        likesCountCalls++;
        // 6 likes after like, 5 likes after unlike
        return likesCountCalls == 1 ? 6 : 5;
      });

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(milliseconds: 1),
      );

      // Like first
      await viewModel.handleLike(controller: controller);
      // Then unlike
      await viewModel.handleLike(controller: controller);

      final updated = viewModel.state.value!;

      expect(updated.isLiked, false);
      expect(updated.tweet.value!.likes, 5);
    });

    test('handleRepost toggles repost count', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);
      var toggleRepostCalls = 0;
      when(() => mockInteractionsService.toggleRepost(tweetId))
          .thenAnswer((_) async {
        toggleRepostCalls++;
        // true on first call (repost), false on second (un-repost)
        return toggleRepostCalls == 1;
      });
      var repostCountCalls = 0;
      when(() => mockInteractionsService.getRepostsCount(tweetId))
          .thenAnswer((_) async {
        repostCountCalls++;
        // 4 after repost, 3 after un-repost
        return repostCountCalls == 1 ? 4 : 3;
      });

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = AnimationController(
        vsync: TestVSync(),
        duration: const Duration(milliseconds: 1),
      );

      await viewModel.handleRepost(controllerRepost: controller);
      expect(viewModel.state.value!.isReposted, true);
      expect(viewModel.state.value!.tweet.value!.repost, 4);

      await viewModel.handleRepost(controllerRepost: controller);
      expect(viewModel.state.value!.isReposted, false);
      expect(viewModel.state.value!.tweet.value!.repost, 3);
    });

    test('handleViews increases view count once only', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      await viewModel.handleViews();
      final once = viewModel.state.value!;
      expect(once.isViewed, true);
      expect(once.tweet.value!.views, 11);

      // Calling again should not increase views
      viewModel.handleViews();
      final twice = viewModel.state.value!;
      expect(twice.tweet.value!.views, 11);
    });

    test('build uses local views override when greater than backend value', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet.copyWith(views: 5));
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(10);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      final state = await viewModel.build(tweetId);

      expect(state.tweet.value!.views, 10);
    });

    test('handleViews stores local views override so they persist across reloads', () async {
      when(() => mockRepo.fetchTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});
      when(() => mockTweetsApiService.getInteractionFlags(tweetId))
          .thenAnswer((_) async => {'isLikedByMe': false, 'isRepostedByMe': false});
      when(() => mockTweetsApiService.getLocalViews(tweetId)).thenReturn(null);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      await viewModel.handleViews();

      verify(() => mockTweetsApiService.setLocalViews(tweetId, 11)).called(1);
    });
  });
}
