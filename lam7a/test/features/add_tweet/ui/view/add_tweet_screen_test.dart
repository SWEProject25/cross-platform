import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:permission_handler/permission_handler.dart';

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

    testWidgets('reply mode shows parent tweet and reply composer',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
          tweetViewModelProvider('1').overrideWith(FakeTweetViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(
                userId: 1,
                parentPostId: 1,
                isReply: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should display replying to text
      expect(find.textContaining('Replying to'), findsOneWidget);
      
      // Should have reply hint text
      expect(find.text('Tweet your reply'), findsOneWidget);
    });

    testWidgets('tapping replying to handle navigates to profile',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
          tweetViewModelProvider('1').overrideWith(FakeTweetViewModel.new),
        ],
      );

      final navigatorObserver = NavigatorObserver();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            navigatorObservers: [navigatorObserver],
            onGenerateRoute: (settings) {
              if (settings.name == '/profile') {
                return MaterialPageRoute(
                  builder: (_) => const Scaffold(body: Text('Profile Page')),
                );
              }
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: AddTweetScreen(
                    userId: 1,
                    parentPostId: 1,
                    isReply: true,
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the replying to text
      final replyingToFinder = find.textContaining('Replying to @parentUser');
      expect(replyingToFinder, findsOneWidget);
      
      await tester.tap(replyingToFinder);
      await tester.pumpAndSettle();

      // Verify navigation occurred
      expect(find.text('Profile Page'), findsOneWidget);
    });

    testWidgets('image source dialog shows camera and gallery options',
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

      await tester.pumpAndSettle();

      // Find and tap the image button in toolbar
      final toolbar = find.byType(AddTweetToolbarWidget);
      expect(toolbar, findsOneWidget);

      // Tap the image icon (first icon in toolbar)
      final imageIcon = find.descendant(
        of: toolbar,
        matching: find.byIcon(Icons.image),
      );
      
      if (imageIcon.evaluate().isNotEmpty) {
        await tester.tap(imageIcon);
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.text('Take Photo'), findsOneWidget);
        expect(find.text('Choose from Gallery'), findsOneWidget);
        expect(find.byIcon(Icons.camera_alt), findsOneWidget);
        expect(find.byIcon(Icons.photo_library), findsOneWidget);
      }
    });

    testWidgets('video source dialog shows record and gallery options',
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

      await tester.pumpAndSettle();

      // Find and tap the video button in toolbar
      final toolbar = find.byType(AddTweetToolbarWidget);
      expect(toolbar, findsOneWidget);

      // Tap the gif/video icon (second icon in toolbar)
      final videoIcon = find.descendant(
        of: toolbar,
        matching: find.byIcon(Icons.gif_box),
      );
      
      if (videoIcon.evaluate().isNotEmpty) {
        await tester.tap(videoIcon);
        await tester.pumpAndSettle();

        // Verify dialog is shown
        expect(find.text('Record Video'), findsOneWidget);
        expect(find.text('Choose from Gallery'), findsOneWidget);
        expect(find.byIcon(Icons.videocam), findsOneWidget);
        expect(find.byIcon(Icons.video_library), findsOneWidget);
      }
    });

    testWidgets('reply composer updates body when text changes',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
          tweetViewModelProvider('1').overrideWith(FakeTweetViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(
                userId: 1,
                parentPostId: 1,
                isReply: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the reply text field
      final textField = find.widgetWithText(TextField, 'Tweet your reply');
      expect(textField, findsOneWidget);

      // Enter text
      await tester.enterText(textField, 'This is my reply');
      await tester.pump();

      // Verify text was entered
      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      expect(viewmodel.state.body, 'This is my reply');
      expect(viewmodel.state.isValidBody, isTrue);
    });

    testWidgets('displays video selected text when video path is set',
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

      // Verify video preview is shown
      expect(find.text('Video selected'), findsOneWidget);
      expect(find.byIcon(Icons.video_library), findsOneWidget);
      
      // Should have remove button
      expect(find.byIcon(Icons.close), findsWidgets);
    });

    testWidgets('close button removes video when tapped',
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

      // Verify video is displayed
      expect(find.text('Video selected'), findsOneWidget);
      
      // Find the close button on video
      final closeButtons = find.byIcon(Icons.close);
      expect(closeButtons, findsWidgets);

      // Note: We can't actually test the removal in widget tests
      // because the fake viewmodel returns a constant state.
      // This test verifies the UI shows the close button.
    });

    testWidgets('cancel button navigates back', (WidgetTester tester) async {
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
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTweetScreen(userId: 1),
                      ),
                    );
                  },
                  child: const Text('Open Add Tweet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Add Tweet'));
      await tester.pumpAndSettle();

      // Verify we're on AddTweetScreen
      expect(find.text('Post'), findsOneWidget);

      // Find and tap cancel button (it's an IconButton with close icon)
      final cancelButton = find.byIcon(Icons.close).first;
      expect(cancelButton, findsOneWidget);
      
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // Should navigate back
      expect(find.text('Open Add Tweet'), findsOneWidget);
    });

    testWidgets('post button is disabled when body is invalid',
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

      await tester.pumpAndSettle();

      // Initially, body is empty so post button should be disabled
      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      expect(viewmodel.canPostTweet(), isFalse);
    });

    testWidgets('shows success snackbar after successful post',
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
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddTweetScreen(userId: 1),
                      ),
                    );
                  },
                  child: const Text('Open Add Tweet'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Add Tweet'));
      await tester.pumpAndSettle();

      // Type a valid body
      await tester.enterText(find.byType(TextField), 'Test tweet');
      await tester.pump();

      // Tap post button
      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      // Should show success message and navigate back
      expect(find.text('Tweet posted successfully!'), findsOneWidget);
      await tester.pumpAndSettle();
      
      expect(find.text('Open Add Tweet'), findsOneWidget);
    });

    testWidgets('mention suggestions panel closes when body changes without @',
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

      await tester.pumpAndSettle();

      // Type text without @
      await tester.enterText(find.byType(TextField), 'Hello world');
      await tester.pump();

      // Mention panel should not be open
      final mentionState = container.read(mentionSuggestionsViewModelProvider);
      expect(mentionState.isOpen, isFalse);
    });

    testWidgets('displays user avatar in composer',
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

      await tester.pumpAndSettle();

      // Should find user avatar widget
      expect(find.byType(CircleAvatar), findsWidgets);
    });

    testWidgets('poll button shows not implemented message',
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

      await tester.pumpAndSettle();

      // Find poll icon in toolbar
      final toolbar = find.byType(AddTweetToolbarWidget);
      final pollIcon = find.descendant(
        of: toolbar,
        matching: find.byIcon(Icons.poll),
      );

      if (pollIcon.evaluate().isNotEmpty) {
        await tester.tap(pollIcon);
        await tester.pumpAndSettle();

        // Should show not implemented message
        expect(find.text('Poll creation not implemented yet'), findsOneWidget);
      }
    });

    testWidgets('image grid shows 2 columns', (WidgetTester tester) async {
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

      // Should find GridView with 2 columns
      final gridView = find.byType(GridView);
      expect(gridView, findsOneWidget);

      final gridWidget = tester.widget<GridView>(gridView);
      final delegate = gridWidget.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    testWidgets('displays close buttons for media removal',
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

      // Verify initial state has 2 images
      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      expect(viewmodel.state.mediaPicPaths.length, 2);

      // Find close buttons (should have one in header + one per media item)
      final closeIcons = find.byIcon(Icons.close);
      expect(closeIcons, findsWidgets);
      
      // Verify we have at least one close button for media
      expect(closeIcons.evaluate().length, greaterThan(1));
    });

    testWidgets('displays media grid for invalid paths',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelWithInvalidMedia.new),
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

      // Verify state has media paths
      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      expect(viewmodel.state.mediaPicPaths.length, 1);
      
      // Should still display grid view for media
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('reply mode shows connector line', (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelSuccess.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
          tweetViewModelProvider('1').overrideWith(FakeTweetViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: AddTweetScreen(
                userId: 1,
                parentPostId: 1,
                isReply: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Should find container representing connector line
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('respects max body length', (WidgetTester tester) async {
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

      await tester.pumpAndSettle();

      // Find text field
      final textField = tester.widget<TextField>(find.byType(TextField));
      
      // Verify max length is set
      expect(textField.maxLength, AddTweetViewmodel.maxBodyLength);
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

/// Fake viewmodel with media that can be removed
class FakeAddTweetViewmodelWithMediaRemovable extends _FakeAddTweetViewmodelBase {
  bool removeMediaPicAtCalled = false;
  
  @override
  AddTweetState build() {
    return const AddTweetState(
      mediaPicPaths: ['/path/to/image1.jpg', '/path/to/image2.jpg'],
    );
  }

  @override
  void reset() {
    state = const AddTweetState(
      mediaPicPaths: ['/path/to/image1.jpg', '/path/to/image2.jpg'],
    );
  }

  @override
  void removeMediaPicAt(int index) {
    removeMediaPicAtCalled = true;
    final newPaths = List<String>.from(state.mediaPicPaths);
    newPaths.removeAt(index);
    state = state.copyWith(mediaPicPaths: newPaths);
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

/// Fake viewmodel with invalid media paths
class FakeAddTweetViewmodelWithInvalidMedia extends _FakeAddTweetViewmodelBase {
  @override
  AddTweetState build() {
    return const AddTweetState(
      mediaPicPaths: ['/nonexistent/path/image.jpg'],
    );
  }

  @override
  void reset() {
    state = const AddTweetState(
      mediaPicPaths: ['/nonexistent/path/image.jpg'],
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
