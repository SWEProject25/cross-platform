import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/Explore/ui/view/search_and_auto_complete/search_page.dart';
import 'package:lam7a/features/Explore/ui/viewmodel/search_viewmodel.dart';
import 'package:lam7a/features/Explore/ui/state/search_state.dart';
import 'package:lam7a/features/Explore/repository/search_repository.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/Explore/ui/view/search_result_page.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(<UserModel>[]);
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    mockRepo = MockSearchRepository();
  });

  Widget createTestWidget({String? initialQuery}) {
    return ProviderScope(
      overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
      child: MaterialApp(home: SearchMainPage(initialQuery: initialQuery)),
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

  group('SearchMainPage - Widget Structure', () {
    testWidgets('should render scaffold with appBar', (tester) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(SearchMainPage.scaffoldKey), findsOneWidget);
      expect(find.byKey(SearchMainPage.appBarKey), findsOneWidget);
      expect(find.byKey(SearchMainPage.backButtonKey), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byKey(SearchMainPage.textFieldKey), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byKey(SearchMainPage.animatedSwitcherKey), findsOneWidget);
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
      expect(find.text('Search X'), findsOneWidget);
    });
  });

  group('SearchMainPage - Back Button', () {
    testWidgets('should pop when back button is pressed', (tester) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProviderScope(
                        overrides: [
                          searchRepositoryProvider.overrideWithValue(mockRepo),
                        ],
                        child: const SearchMainPage(),
                      ),
                    ),
                  );
                },
                child: const Text('Open Search'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to search page
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Verify we're on search page
      expect(find.byKey(SearchMainPage.scaffoldKey), findsOneWidget);

      // Tap back button
      await tester.tap(find.byKey(SearchMainPage.backButtonKey));
      await tester.pumpAndSettle();

      // Verify we're back to home
      expect(find.byKey(SearchMainPage.scaffoldKey), findsNothing);
      expect(find.text('Open Search'), findsOneWidget);
    });
  });

  group('SearchMainPage - View Switching', () {
    testWidgets('should show RecentView when text field is empty', (
      tester,
    ) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('recent_view')), findsOneWidget);
      expect(find.byKey(const ValueKey('autocomplete_view')), findsNothing);
    });

    testWidgets('should switch to SearchAutocompleteView when typing', (
      tester,
    ) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Initially shows RecentView
      expect(find.byKey(const ValueKey('recent_view')), findsOneWidget);

      // Type in search field
      await tester.enterText(
        find.byKey(SearchMainPage.textFieldKey),
        'flutter',
      );
      await tester.pumpAndSettle();

      // Should now show SearchAutocompleteView
      expect(find.byKey(const ValueKey('autocomplete_view')), findsOneWidget);
      expect(find.byKey(const ValueKey('recent_view')), findsNothing);
    });
  });

  group('SearchMainPage - Clear Button', () {
    testWidgets('should not show clear button when text is empty', (
      tester,
    ) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byKey(SearchMainPage.clearButtonKey), findsNothing);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('should show clear button when text is entered', (
      tester,
    ) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Type in search field
      await tester.enterText(
        find.byKey(SearchMainPage.textFieldKey),
        'flutter',
      );
      await tester.pumpAndSettle();

      expect(find.byKey(SearchMainPage.clearButtonKey), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('should clear text when clear button is pressed', (
      tester,
    ) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Type in search field
      await tester.enterText(
        find.byKey(SearchMainPage.textFieldKey),
        'flutter',
      );
      await tester.pumpAndSettle();

      // Verify text is entered
      final textField = tester.widget<TextField>(
        find.byKey(SearchMainPage.textFieldKey),
      );
      expect(textField.controller?.text, 'flutter');

      // Tap clear button
      await tester.tap(find.byKey(SearchMainPage.clearButtonKey));
      await tester.pumpAndSettle();

      // Verify text is cleared
      final clearedTextField = tester.widget<TextField>(
        find.byKey(SearchMainPage.textFieldKey),
      );
      expect(clearedTextField.controller?.text, '');

      // Should show RecentView again
      expect(find.byKey(const ValueKey('recent_view')), findsOneWidget);
    });
  });

  group('SearchMainPage - Text Input', () {
    testWidgets('should update text field when typing', (tester) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), any(), any()),
      ).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      const searchText = 'flutter development';
      await tester.enterText(
        find.byKey(SearchMainPage.textFieldKey),
        searchText,
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(
        find.byKey(SearchMainPage.textFieldKey),
      );
      expect(textField.controller?.text, searchText);
    });
  });

  group('SearchMainPage - Search Submission', () {
    testWidgets('should not submit empty search', (tester) async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Try to submit empty text
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Should still be on search page (no navigation happened)
      expect(find.byKey(SearchMainPage.scaffoldKey), findsOneWidget);
      // pushAutocomplete should NOT be called for empty search
      verifyNever(() => mockRepo.pushAutocomplete(any()));
    });

    testWidgets(
      'should navigate to SearchResultPage when search is submitted',
      (tester) async {
        when(
          () => mockRepo.getCachedAutocompletes(),
        ).thenAnswer((_) async => []);
        when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
        when(() => mockRepo.pushAutocomplete(any())).thenAnswer((_) async {});
        when(
          () => mockRepo.searchTweets(any(), any(), any()),
        ).thenAnswer((_) async => []);
        when(
          () => mockRepo.searchUsers(any(), any(), any()),
        ).thenAnswer((_) async => []);

        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify we're on SearchMainPage
        expect(find.byKey(SearchMainPage.scaffoldKey), findsOneWidget);

        // Enter valid search text (>= 3 chars)
        await tester.enterText(
          find.byKey(SearchMainPage.textFieldKey),
          'flutter test',
        );
        await tester.pumpAndSettle();

        // Submit search via keyboard action
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();

        verify(() => mockRepo.pushAutocomplete('flutter test')).called(1);

        // 🔴 OLD CHECK (implicit)
        expect(find.byKey(SearchMainPage.scaffoldKey), findsNothing);

        // ✅ NEW CHECKS (explicit)
        expect(find.byType(SearchResultPage), findsOneWidget);

        final page = tester.widget<SearchResultPage>(
          find.byType(SearchResultPage),
        );

        expect(page.hintText, 'flutter test');
      },
    );
  });
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(
  //         ProviderScope(
  //           overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
  //           child: MaterialApp(
  //             theme: ThemeData.light(),
  //             home: const SearchMainPage(),
  //           ),
  //         ),
  //       );
  //       await tester.pumpAndSettle();

  //       // Verify back button icon color
  //       final backButton = tester.widget<IconButton>(
  //         find.byKey(SearchMainPage.backButtonKey),
  //       );
  //       final icon = backButton.icon as Icon;
  //       expect(icon.color, Colors.black);
  //     });

  //     testWidgets('should display correct colors in dark mode', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(
  //         ProviderScope(
  //           overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
  //           child: MaterialApp(
  //             theme: ThemeData.dark(),
  //             home: const SearchMainPage(),
  //           ),
  //         ),
  //       );
  //       await tester.pumpAndSettle();

  //       // Verify back button icon color
  //       final backButton = tester.widget<IconButton>(
  //         find.byKey(SearchMainPage.backButtonKey),
  //       );
  //       final icon = backButton.icon as Icon;
  //       expect(icon.color, Colors.white);
  //     });
  //   });

  //   group('SearchMainPage - TextField Configuration', () {
  //     testWidgets('should have correct textInputAction', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(createTestWidget());
  //       await tester.pumpAndSettle();

  //       final textField = tester.widget<TextField>(
  //         find.byKey(SearchMainPage.textFieldKey),
  //       );
  //       expect(textField.textInputAction, TextInputAction.search);
  //     });

  //     testWidgets('should have correct cursor color', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(createTestWidget());
  //       await tester.pumpAndSettle();

  //       final textField = tester.widget<TextField>(
  //         find.byKey(SearchMainPage.textFieldKey),
  //       );
  //       expect(textField.cursorColor, const Color(0xFF1DA1F2));
  //     });

  //     testWidgets('should have correct text style', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(createTestWidget());
  //       await tester.pumpAndSettle();

  //       final textField = tester.widget<TextField>(
  //         find.byKey(SearchMainPage.textFieldKey),
  //       );
  //       expect(textField.style?.color, const Color(0xFF1DA1F2));
  //       expect(textField.style?.fontSize, 16);
  //     });
  //   });

  //   group('SearchMainPage - AnimatedSwitcher', () {
  //     testWidgets('should animate when switching views', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
  //       when(
  //         () => mockRepo.searchUsers(any(), any(), any()),
  //       ).thenAnswer((_) async => []);

  //       await tester.pumpWidget(createTestWidget());
  //       await tester.pumpAndSettle();

  //       // Initially shows RecentView
  //       expect(find.byKey(const ValueKey('recent_view')), findsOneWidget);

  //       // Type to trigger view switch
  //       await tester.enterText(find.byKey(SearchMainPage.textFieldKey), 'test');

  //       // Pump to start animation
  //       await tester.pump();

  //       // The AnimatedSwitcher should exist during transition
  //       expect(find.byKey(SearchMainPage.animatedSwitcherKey), findsOneWidget);

  //       // Complete animation
  //       await tester.pumpAndSettle();

  //       // Should now show autocomplete view
  //       expect(find.byKey(const ValueKey('autocomplete_view')), findsOneWidget);
  //     });

  //     testWidgets('should have correct animation duration', (tester) async {
  //       when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
  //       when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

  //       await tester.pumpWidget(createTestWidget());
  //       await tester.pumpAndSettle();

  //       final animatedSwitcher = tester.widget<AnimatedSwitcher>(
  //         find.byKey(SearchMainPage.animatedSwitcherKey),
  //       );
  //       expect(animatedSwitcher.duration, const Duration(milliseconds: 250));
  //     });
  //   });
}
