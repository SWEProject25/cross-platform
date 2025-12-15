import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/mention_suggestions_viewmodel.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_feed.dart';

class FakeTweetFeedViewModel extends TweetViewModel {
  bool handleRepostCalled = false;

  @override
  FutureOr<TweetState> build(String tweetId) {
    final isAlreadyReposted = tweetId == 'already-reposted';

    final tweet = TweetModel(
      id: tweetId,
      userId: 'user-$tweetId',
      body: 'Body for $tweetId',
      date: DateTime(2025, 1, 1),
      likes: 0,
      comments: 0,
      repost: 0,
      views: 0,
      qoutes: 0,
      bookmarks: 0,
      mediaImages: const [],
      mediaVideos: const [],
      username: 'user_$tweetId',
      authorName: 'User $tweetId',
    );

    return TweetState(
      isLiked: false,
      isReposted: isAlreadyReposted,
      isViewed: false,
      tweet: AsyncValue.data(tweet),
    );
  }

  @override
  Future<void> handleRepost({
    required AnimationController controllerRepost,
  }) async {
    handleRepostCalled = true;

    if (!state.hasValue || state.value == null) {
      return;
    }

    final currentState = state.value!;
    if (!currentState.tweet.hasValue || currentState.tweet.value == null) {
      return;
    }

    final currentTweet = currentState.tweet.value!;

    state = AsyncData(
      currentState.copyWith(
        isReposted: !currentState.isReposted,
        tweet: AsyncValue.data(
          currentTweet.copyWith(
            repost: currentState.isReposted
                ? currentTweet.repost > 0
                    ? currentTweet.repost - 1
                    : 0
                : currentTweet.repost + 1,
          ),
        ),
      ),
    );
  }
}

/// Simple authenticated user for quote tests.
class FakeAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState(
      user: const UserModel(
        id: 1,
        username: 'tester',
        email: 'tester@example.com',
        name: 'Tester',
      ),
      isAuthenticated: true,
    );
  }
}

/// Lightweight AddTweetViewmodel that avoids real networking.
class FakeAddTweetViewmodel extends AddTweetViewmodel {
  @override
  AddTweetState build() {
    return const AddTweetState();
  }

  @override
  void updateBody(String body) {
    state = state.copyWith(
      body: body,
      isValidBody: body.trim().isNotEmpty,
    );
  }

  @override
  bool canPostTweet() {
    return state.isValidBody && !state.isLoading;
  }
}

/// Minimal MentionSuggestionsViewModel implementation.
class FakeMentionSuggestionsViewModel extends MentionSuggestionsViewModel {
  @override
  MentionSuggestionsState build() {
    return const MentionSuggestionsState();
  }

  @override
  void clear() {
    state = const MentionSuggestionsState();
  }

  @override
  Future<void> updateQuery(String query) async {
    state = state.copyWith(query: query, isOpen: false, isLoading: false);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TweetFeed repost & quote interactions', () {
    testWidgets(
        'opens repost/quote bottom sheet and shows success snackbar on repost',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          tweetViewModelProvider.overrideWith(FakeTweetFeedViewModel.new),
        ],
      );

      addTearDown(container.dispose);

      final tweet = TweetModel(
        id: '1',
        userId: '1',
        body: 'Test tweet',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      final tweetState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(tweet),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: TweetFeed(tweetState: tweetState),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Repost button is the second IconButton inside TweetFeed's action row.
      final repostButton = find.descendant(
        of: find.byType(TweetFeed),
        matching: find.byType(IconButton),
      ).at(1);

      await tester.tap(repostButton);
      await tester.pumpAndSettle();

      expect(find.text('Repost'), findsOneWidget);
      expect(find.text('Quote'), findsOneWidget);

      await tester.tap(find.text('Repost'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Snack bar from top_snackbar_flutter should appear with this text.
      expect(find.text('Reposted Successfully'), findsOneWidget);

      final vm = container
          .read(tweetViewModelProvider('1').notifier) as FakeTweetFeedViewModel;
      expect(vm.handleRepostCalled, isTrue);
      expect(vm.getisReposted(), isTrue);
    });

    testWidgets('tapping repost when already reposted skips bottom sheet and '
        'calls _handlerepost()', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          tweetViewModelProvider.overrideWith(FakeTweetFeedViewModel.new),
        ],
      );

      addTearDown(container.dispose);

      final tweet = TweetModel(
        id: 'already-reposted',
        userId: '1',
        body: 'Already reposted tweet',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 1,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      final tweetState = TweetState(
        isLiked: false,
        isReposted: true,
        isViewed: false,
        tweet: AsyncValue.data(tweet),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: TweetFeed(tweetState: tweetState),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final repostButton = find.descendant(
        of: find.byType(TweetFeed),
        matching: find.byType(IconButton),
      ).at(1);

      await tester.tap(repostButton);
      await tester.pumpAndSettle();

      // Bottom sheet should not appear when tweet is already reposted.
      expect(find.text('Repost'), findsNothing);
      expect(find.text('Quote'), findsNothing);

      final vm = container.read(
        tweetViewModelProvider('already-reposted').notifier,
      ) as FakeTweetFeedViewModel;
      expect(vm.handleRepostCalled, isTrue);
    });

    testWidgets('quote option shows login snackbar when user is not '
        'authenticated', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          tweetViewModelProvider.overrideWith(FakeTweetFeedViewModel.new),
          // Use real Authentication provider default (unauthenticated) or
          // optionally override with an explicit unauthenticated state.
        ],
      );

      addTearDown(container.dispose);

      final tweet = TweetModel(
        id: 'quote-unauth',
        userId: '1',
        body: 'Quote test tweet',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      final tweetState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(tweet),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: TweetFeed(tweetState: tweetState),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final repostButton = find.descendant(
        of: find.byType(TweetFeed),
        matching: find.byType(IconButton),
      ).at(1);

      await tester.tap(repostButton);
      await tester.pumpAndSettle();

      expect(find.text('Quote'), findsOneWidget);

      await tester.tap(find.text('Quote'));
      await tester.pump();

      expect(find.text('Please log in to quote'), findsOneWidget);
    });

    testWidgets('quote option navigates to AddTweetScreen when user is '
        'authenticated and parent id parses correctly',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          tweetViewModelProvider.overrideWith(FakeTweetFeedViewModel.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          addTweetViewmodelProvider.overrideWith(FakeAddTweetViewmodel.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      addTearDown(container.dispose);

      final tweet = TweetModel(
        id: '42',
        userId: '1',
        body: 'Quote navigation tweet',
        date: DateTime.now(),
        likes: 0,
        comments: 0,
        repost: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: const [],
        mediaVideos: const [],
      );

      final tweetState = TweetState(
        isLiked: false,
        isReposted: false,
        isViewed: false,
        tweet: AsyncValue.data(tweet),
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: TweetFeed(tweetState: tweetState),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final repostButton = find.descendant(
        of: find.byType(TweetFeed),
        matching: find.byType(IconButton),
      ).at(1);

      await tester.tap(repostButton);
      await tester.pumpAndSettle();

      expect(find.text('Quote'), findsOneWidget);

      await tester.tap(find.text('Quote'));
      await tester.pumpAndSettle();

      // After tapping Quote, AddTweetScreen should be pushed.
      expect(find.byType(AddTweetScreen), findsOneWidget);
    });
  });
}
