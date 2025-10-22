import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/models/tweet.dart';
import 'package:lam7a/features/tweet_summary/ui/view_model/tweet_viewmodel.dart';

void main() {
  group('TweetViewModel logic tests', () {
    late TweetViewModel viewModel;
    const tweetId = 't1';

    setUp(() {
      viewModel = TweetViewModel();
      viewModel.state = AsyncData(
        TweetModel(
          id: tweetId,
          userId: 'u1',
          body: 'Hello world',
          likes: 5,
          repost: 2,
          comments: 0,
          views: 10,
          qoutes: 1,
          bookmarks: 1,
          date: DateTime.now(),
        ),
      );
    });

    test('initial state is correct', () {
      expect(viewModel.getIsLiked(), false);
      expect(viewModel.getisReposted(), false);
      expect(viewModel.isViewed, false);
      expect(viewModel.state.value!.likes, 5);
    });

    test('handleLike increments and toggles correctly', () async {
      final controller = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );

      // Like it
      viewModel.handleLike(controller: controller);
      expect(viewModel.getIsLiked(), true);
      expect(viewModel.state.value!.likes, 6);

      // Unlike it
      viewModel.handleLike(controller: controller);
      expect(viewModel.getIsLiked(), false);
      expect(viewModel.state.value!.likes, 5);
    });

    test('handleRepost increments and toggles correctly', () async {
      final controllerRepost = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );

      viewModel.handleRepost(controllerRepost: controllerRepost);
      expect(viewModel.getisReposted(), true);
      expect(viewModel.state.value!.repost, 3);

      viewModel.handleRepost(controllerRepost: controllerRepost);
      expect(viewModel.getisReposted(), false);
      expect(viewModel.state.value!.repost, 2);
    });

    test('handleViews increments only once', () {
      viewModel.handleViews();
      expect(viewModel.isViewed, true);
      expect(viewModel.state.value!.views, 11);

      viewModel.handleViews();
      expect(viewModel.state.value!.views, 11); // should not increment again
    });

    test('formatting helper howLong() works correctly', () {
      expect(viewModel.howLong(1000), '1K');
      expect(viewModel.howLong(1_500_000), '1.5M');
      expect(viewModel.howLong(2_000_000_000), '2B');
    });

    test('dummy handlers don’t throw', () {
      expect(() => viewModel.handleComment(), returnsNormally);
      expect(() => viewModel.handleShare(), returnsNormally);
      expect(() => viewModel.handleBookmark(), returnsNormally);
    });
  });
}
