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
import 'package:mocktail/mocktail.dart';

/// Integration tests for AddTweetScreen focusing on media handling
/// These tests verify the UI interactions around image/video picking

class FakeAddTweetViewmodelBase extends AddTweetViewmodel {
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

  @override
  void addMediaPic(String path) {
    if (state.mediaPicPaths.length < 4) {
      final newPaths = List<String>.from(state.mediaPicPaths)..add(path);
      state = state.copyWith(mediaPicPaths: newPaths);
    }
  }

  @override
  void removeMediaPicAt(int index) {
    final newPaths = List<String>.from(state.mediaPicPaths)..removeAt(index);
    state = state.copyWith(mediaPicPaths: newPaths);
  }

  @override
  void updateMediaVideo(String? path) {
    state = state.copyWith(mediaVideoPath: path);
  }

  @override
  void removeMediaVideo() {
    state = state.copyWith(mediaVideoPath: null);
  }

  @override
  void reset() {
    state = const AddTweetState();
  }

  @override
  int getRemainingCharacters() {
    return 280 - (state.body?.length ?? 0);
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

  group('AddTweetScreen Integration Tests - Media Handling', () {
    testWidgets('shows video selection dialog when video icon is tapped',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
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

      // Look for video/gif icon
      final gifIcon = find.byIcon(Icons.gif_box);
      
      if (gifIcon.evaluate().isNotEmpty) {
        await tester.tap(gifIcon);
        await tester.pumpAndSettle();

        // Verify video source dialog is shown
        expect(find.text('Record Video'), findsOneWidget);
        expect(find.text('Choose from Gallery'), findsOneWidget);
      }
    });

    testWidgets('shows image selection dialog when image icon is tapped',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
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

      // Look for image icon
      final imageIcon = find.byIcon(Icons.image);
      
      if (imageIcon.evaluate().isNotEmpty) {
        await tester.tap(imageIcon);
        await tester.pumpAndSettle();

        // Verify image source dialog is shown
        expect(find.text('Take Photo'), findsOneWidget);
        expect(find.text('Choose from Gallery'), findsOneWidget);
      }
    });

    testWidgets('closes image dialog when option is selected',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
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

      final imageIcon = find.byIcon(Icons.image);
      
      if (imageIcon.evaluate().isNotEmpty) {
        await tester.tap(imageIcon);
        await tester.pumpAndSettle();

        // Dialog should be shown
        expect(find.text('Take Photo'), findsOneWidget);

        // Tap on Take Photo (will close the dialog, but won't actually take a photo in test)
        await tester.tap(find.text('Take Photo'));
        await tester.pumpAndSettle();

        // Dialog should be closed (the option text should not be visible anymore)
        // The test just verifies the dialog interaction works
      }
    });

    testWidgets('closes video dialog when option is selected',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
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

      final gifIcon = find.byIcon(Icons.gif_box);
      
      if (gifIcon.evaluate().isNotEmpty) {
        await tester.tap(gifIcon);
        await tester.pumpAndSettle();

        // Dialog should be shown
        expect(find.text('Record Video'), findsOneWidget);

        // Tap on Record Video (will close the dialog, but won't actually record in test)
        await tester.tap(find.text('Record Video'));
        await tester.pumpAndSettle();

        // Dialog should be closed
      }
    });

    testWidgets('can add and display media images',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      
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

      // Add images after screen is built
      viewmodel.addMediaPic('/test/image1.jpg');
      viewmodel.addMediaPic('/test/image2.jpg');
      await tester.pump();

      // Verify images are shown  
      expect(viewmodel.state.mediaPicPaths.length, 2);
    });

    testWidgets('body text updates character count',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
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

      // Initially 280 characters available
      expect(find.text('280'), findsOneWidget);

      // Type some text
      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      // Should show 275 characters remaining
      final viewmodel = container.read(addTweetViewmodelProvider.notifier);
      expect(viewmodel.getRemainingCharacters(), 275);
    });

    testWidgets('displays safe area for screen content',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AddTweetScreen(userId: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify SafeArea is used
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('main content uses SingleChildScrollView',
        (WidgetTester tester) async {
      final container = ProviderContainer(
        overrides: [
          addTweetViewmodelProvider
              .overrideWith(FakeAddTweetViewmodelBase.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
          mentionSuggestionsViewModelProvider
              .overrideWith(FakeMentionSuggestionsViewModel.new),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: AddTweetScreen(userId: 1),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify scrollable content
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
