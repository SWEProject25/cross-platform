import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/services/mock_tweet_api_service.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mocktail/mocktail.dart';

/// ---- MOCK CLASSES ----
class MockTweetRepo extends Mock implements MockTweetRepository {}

class FakeAnimationController extends Fake implements AnimationController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockTweetRepo mockRepo;
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
    registerFallbackValue(FakeAnimationController());
  });

  setUp(() {
    mockRepo = MockTweetRepo();
    container = ProviderContainer(
      overrides: [
        mockTweetRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TweetViewModel Tests', () {
    test('Initial state builds correctly', () async {
      when(() => mockRepo.getTweetById(tweetId))
          .thenAnswer((_) async => testTweet);

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      final state = await viewModel.build(tweetId);

      expect(state.isLiked, false);
      expect(state.isReposted, false);
      expect(state.isViewed, false);
      expect(state.tweet.value!.body, equals('Hello world'));
    });

    test('handleLike increments likes when not liked', () async {
      when(() => mockRepo.getTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = FakeAnimationController();

      viewModel.handleLike(controller: controller);
      final updated = viewModel.state.value!;

      expect(updated.isLiked, true);
      expect(updated.tweet.value!.likes, 6);
      verify(() => mockRepo.updateTweet(any())).called(1);
    });

    test('handleLike decrements likes when already liked', () async {
      when(() => mockRepo.getTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = FakeAnimationController();

      // Like first
      viewModel.handleLike(controller: controller);
      // Then unlike
      viewModel.handleLike(controller: controller);

      final updated = viewModel.state.value!;

      expect(updated.isLiked, false);
      expect(updated.tweet.value!.likes, 5);
      verify(() => mockRepo.updateTweet(any())).called(2);
    });

    test('handleRepost toggles repost count', () async {
      when(() => mockRepo.getTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      final controller = FakeAnimationController();

      viewModel.handleRepost(controllerRepost: controller);
      expect(viewModel.state.value!.isReposted, true);
      expect(viewModel.state.value!.tweet.value!.repost, 4);

      viewModel.handleRepost(controllerRepost: controller);
      expect(viewModel.state.value!.isReposted, false);
      expect(viewModel.state.value!.tweet.value!.repost, 3);
    });

    test('handleViews increases view count once only', () async {
      when(() => mockRepo.getTweetById(tweetId))
          .thenAnswer((_) async => testTweet);
      when(() => mockRepo.updateTweet(any())).thenAnswer((_) async {});

      final viewModel = container.read(tweetViewModelProvider(tweetId).notifier);
      await viewModel.build(tweetId);

      viewModel.handleViews();
      final once = viewModel.state.value!;
      expect(once.isViewed, true);
      expect(once.tweet.value!.views, 11);

      // Calling again should not increase views
      viewModel.handleViews();
      final twice = viewModel.state.value!;
      expect(twice.tweet.value!.views, 11);
    });
  });
}
