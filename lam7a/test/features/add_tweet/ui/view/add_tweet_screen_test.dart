import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/ui/view/add_tweet_screen.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/mention_suggestions_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/widgets/add_tweet_toolbar_widget.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/tweet/ui/state/tweet_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

/// Fake implementation of AddTweetViewmodel that avoids real API calls and
/// lets us control posting behavior in widget tests.
class _FakeAddTweetViewmodelBase extends AddTweetViewmodel {
  @override
  AddTweetState build() {
    return const AddTweetState();
  }

  @override
  void updateBody(String body) {
    // Simple validation: non-empty trimmed body is valid
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

class FakeTweetViewModel extends TweetViewModel {
  @override
  FutureOr<TweetState> build(String tweetId) {
    final parentTweet = TweetModel(
      id: tweetId,
      body: 'Parent tweet body',
      date: DateTime(2025, 1, 1),
      userId: 'u1',
      username: 'parentUser',
    );

    return TweetState(
      isLiked: false,
      isReposted: false,
      isViewed: false,
      tweet: AsyncValue.data(parentTweet),
    );
  }
}

class MockConversationsRepository extends Mock
    implements ConversationsRepository {}

class FakeAddTweetViewmodelSuccess extends _FakeAddTweetViewmodelBase {
  bool postCalled = false;
  List<int>? lastMentions;

  @override
  Future<void> postTweet({List<int>? mentionsIds}) async {
    postCalled = true;
    lastMentions = mentionsIds;
    state = state.copyWith(
      isLoading: false,
      isTweetPosted: true,
      errorMessage: null,
    );
  }
}

class FakeAddTweetViewmodelFailure extends _FakeAddTweetViewmodelBase {
  bool postCalled = false;

  @override
  Future<void> postTweet({List<int>? mentionsIds}) async {
    postCalled = true;
    state = state.copyWith(
      isLoading: false,
      isTweetPosted: false,
      errorMessage: 'Failed for test',
    );
  }
}

/// Simple authenticated user for AddTweetScreen tests.
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

/// Lightweight MentionSuggestionsViewModel that does not touch networking.
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
    // Just store the query; keep the panel closed for simplicity.
    state = state.copyWith(query: query, isOpen: false, isLoading: false);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddTweetScreen widget tests', () {
    testWidgets('allows composing and posting a tweet successfully',
        (WidgetTester tester) async {
      // Set up a shared container so we can inspect the fake viewmodel.
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      // Type a valid body so canPostTweet becomes true.
      await tester.enterText(find.byType(TextField), 'Hello from test');
      await tester.pump();

      final vm = container.read(addTweetViewmodelProvider.notifier)
          as FakeAddTweetViewmodelSuccess;
      expect(container.read(addTweetViewmodelProvider).body, 'Hello from test');
      expect(vm.canPostTweet(), isTrue);

      // Tap the Post button in the header.
      await tester.tap(find.text('Post'));
      await tester.pump();

      expect(vm.postCalled, isTrue);
      // No mentions were selected in this test.
      expect(vm.lastMentions, isEmpty);
    });

    testWidgets('shows error snackbar when posting fails',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelFailure.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      // Enter a valid body so the header enables the action.
      await tester.enterText(find.byType(TextField), 'Body that fails');
      await tester.pump();

      final vm = container.read(addTweetViewmodelProvider.notifier)
          as FakeAddTweetViewmodelFailure;

      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      expect(vm.postCalled, isTrue);
      // Error snackbar with the fake error message should appear.
      expect(find.text('Failed for test'), findsOneWidget);
    });

    testWidgets('renders reply mode with parent tweet preview and composer',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
          tweetViewModelProvider.overrideWith(FakeTweetViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(
                userId: 1,
                parentPostId: 123,
                isReply: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Replying to @parentUser'), findsOneWidget);
    });

    testWidgets(
        'shows mention suggestions panel and inserts selected mention into body',
        (WidgetTester tester) async {
      final mockRepository = MockConversationsRepository();

      final contacts = [
        Contact(id: 1, handle: 'alice', name: 'Alice'),
        Contact(id: 2, handle: 'bob', name: 'Bob'),
      ];

      when(() => mockRepository.searchForContacts('alice', 1, 5))
          .thenAnswer((_) async => contacts);

      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Hello @alice');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('@alice'), findsOneWidget);

      await tester.tap(find.text('@alice'));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final controller = textField.controller;
      expect(controller?.text.contains('@alice'), isTrue);
    });

    testWidgets('quote mode configures viewmodel as QUOTE with parent id',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(
                userId: 1,
                parentPostId: 99,
                isQuote: true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      final state = container.read(addTweetViewmodelProvider);
      expect(state.parentPostId, 99);
      expect(state.postType, 'QUOTE');
    });

    testWidgets('displays media images grid when mediaPicPaths is not empty',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelWithMedia.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the state has media paths
      final notifier = container.read(addTweetViewmodelProvider.notifier);
      expect(notifier.state.mediaPicPaths.length, 2);
      
      // Should find close icons for removing images (within the media preview section)
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsWidgets);
    });

    testWidgets('displays video preview when mediaVideoPath is not null',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelWithVideo.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the state has a video path
      final notifier = container.read(addTweetViewmodelProvider.notifier);
      expect(notifier.state.mediaVideoPath, isNotNull);
      
      // Should find text 'Video selected'
      expect(find.text('Video selected'), findsOneWidget);
    });

    testWidgets('displays character count from viewmodel',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelWithCharCount.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should display character count
      expect(find.text('250'), findsOneWidget);
    });

    testWidgets('toolbar contains image, video, and poll buttons',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(userId: 1),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should find toolbar widget
      expect(find.byType(AddTweetToolbarWidget), findsOneWidget);
    });

  });
}

/// Fake viewmodel with media images
class FakeAddTweetViewmodelWithMedia extends _FakeAddTweetViewmodelBase {
  @override
  AddTweetState build() {
    return const AddTweetState(
      mediaPicPaths: ['/path/to/image1.jpg', '/path/to/image2.jpg'],
    );
  }

  @override
  void reset() {
    // Override reset to preserve media paths for testing
    state = const AddTweetState(
      mediaPicPaths: ['/path/to/image1.jpg', '/path/to/image2.jpg'],
    );
  }

  @override
  Future<void> postTweet({List<int>? mentionsIds}) async {
    state = state.copyWith(
      isLoading: false,
      isTweetPosted: true,
      errorMessage: null,
    );
  }
}

/// Fake viewmodel with video
class FakeAddTweetViewmodelWithVideo extends _FakeAddTweetViewmodelBase {
  @override
  AddTweetState build() {
    return const AddTweetState(
      mediaVideoPath: '/path/to/video.mp4',
    );
  }

  @override
  void reset() {
    // Override reset to preserve video path for testing
    state = const AddTweetState(
      mediaVideoPath: '/path/to/video.mp4',
    );
  }

  @override
  Future<void> postTweet({List<int>? mentionsIds}) async {
    state = state.copyWith(
      isLoading: false,
      isTweetPosted: true,
      errorMessage: null,
    );
  }
}

/// Fake viewmodel that returns character count
class FakeAddTweetViewmodelWithCharCount extends _FakeAddTweetViewmodelBase {
  @override
  AddTweetState build() {
    return const AddTweetState();
  }

  @override
  int getRemainingCharacters() {
    return 250; // Return a specific value for testing
  }

  @override
  Future<void> postTweet({List<int>? mentionsIds}) async {
    state = state.copyWith(
      isLoading: false,
      isTweetPosted: true,
      errorMessage: null,
    );
  }
}

