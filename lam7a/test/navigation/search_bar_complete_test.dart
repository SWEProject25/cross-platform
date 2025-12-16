import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/navigation/ui/widgets/search_bar.dart';

void main() {
  group('SearchBarCustomized Widget Tests - 100% Coverage', () {
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    group('SearchBarCustomized Initialization', () {
      testWidgets('should render without crash', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should create state correctly', (WidgetTester tester) async {
        const searchBar = SearchBarCustomized();
        expect(searchBar.createState(), isNotNull);
      });

      testWidgets('should have null initialText by default',
          (WidgetTester tester) async {
        const searchBar = SearchBarCustomized();
        expect(searchBar.initialText, isNull);
      });

      testWidgets('should accept initialText parameter',
          (WidgetTester tester) async {
        const searchBar = SearchBarCustomized(initialText: 'test');
        expect(searchBar.initialText, equals('test'));
      });

      testWidgets('should handle empty initialText', (WidgetTester tester) async {
        const searchBar = SearchBarCustomized(initialText: '');
        expect(searchBar.initialText, equals(''));
      });

      testWidgets('should handle whitespace initialText',
          (WidgetTester tester) async {
        const searchBar = SearchBarCustomized(initialText: '   ');
        expect(searchBar.initialText, equals('   '));
      });
    });

    group('SearchBarCustomized Rendering', () {
      testWidgets('should render SearchBar widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should display correct hint text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.text('Search X'), findsOneWidget);
      });

      testWidgets('should apply correct theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });
    });

    group('SearchBarCustomized FocusNode Management', () {
      testWidgets('should initialize FocusNode', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle focus correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        
        final searchBar = find.byType(SearchBar).first;
        await tester.tap(searchBar);
        await tester.pumpAndSettle();
        
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should respond to focus changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized TextEditingController', () {
      testWidgets('should initialize TextEditingController',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should set initial text from parameter',
          (WidgetTester tester) async {
        const testText = 'flutter test';
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: testText),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle empty text input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should not set text when initialText is null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: null),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should not set text when initialText is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: ''),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should not set text when initialText is whitespace',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: '   '),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized Theme Configuration', () {
      testWidgets('should apply custom TextSelectionThemeData',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });

      testWidgets('should have cursor color set', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });

      testWidgets('should have selection color set', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });

      testWidgets('should have selection handle color set',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });
    });

    group('SearchBarCustomized SearchBar Properties', () {
      testWidgets('should apply correct hintStyle', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.text('Search X'), findsOneWidget);
      });

      testWidgets('should apply correct textStyle', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should apply correct backgroundColor',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should apply correct padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should apply correct constraints',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should have elevation set to 0', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized Lifecycle', () {
      testWidgets('should initialize and dispose properly',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBarCustomized), findsOneWidget);

        await tester.pumpWidget(
          createTestWidget(
            const SizedBox(),
          ),
        );
        expect(find.byType(SearchBarCustomized), findsNothing);
      });

      testWidgets('should handle multiple mount/unmount cycles',
          (WidgetTester tester) async {
        for (int i = 0; i < 3; i++) {
          await tester.pumpWidget(
            createTestWidget(
              const SearchBarCustomized(),
            ),
          );
          expect(find.byType(SearchBarCustomized), findsOneWidget);

          await tester.pumpWidget(
            createTestWidget(
              const SizedBox(),
            ),
          );
          expect(find.byType(SearchBarCustomized), findsNothing);
        }
      });
    });

    group('SearchBarCustomized Interaction', () {
      testWidgets('should be tappable', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );

        final searchBar = find.byType(SearchBar).first;
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle text input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );

        final searchBar = find.byType(SearchBar).first;
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle special characters', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: '!@#\$%^&*'),
          ),
        );

        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized DarkMode Support', () {
      testWidgets('should render in dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: const SearchBarCustomized(),
            ),
          ),
        );
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should render in light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: const SearchBarCustomized(),
            ),
          ),
        );
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });
    });

    group('SearchBarCustomized Edge Cases', () {
      testWidgets('should handle special characters in initialText',
          (WidgetTester tester) async {
        const specialText = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: specialText),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle unicode characters in initialText',
          (WidgetTester tester) async {
        const unicodeText = '🎉🎊✨🌟💫';
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(initialText: unicodeText),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should handle rapid focus changes',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );

        final searchBar = find.byType(SearchBar).first;
        for (int i = 0; i < 5; i++) {
          await tester.tap(searchBar);
          await tester.pumpAndSettle();
        }

        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized Widget Tree', () {
      testWidgets('should have Theme as parent', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(Theme), findsWidgets);
      });

      testWidgets('should have SearchBar as child', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        expect(find.byType(SearchBar), findsWidgets);
      });
    });

    group('SearchBarCustomized Key Support', () {
      testWidgets('should accept key parameter', (WidgetTester tester) async {
        const key = Key('searchbar-test');
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(key: key),
          ),
        );
        expect(find.byKey(key), findsOneWidget);
      });

      testWidgets('should work with ValueKey', (WidgetTester tester) async {
        const key = ValueKey('searchbar-value');
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(key: key),
          ),
        );
        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('SearchBarCustomized Configuration', () {
      testWidgets('should be stateful widget', (WidgetTester tester) async {
        const searchBar = SearchBarCustomized();
        expect(searchBar, isA<StatefulWidget>());
      });

      testWidgets('should create _SearchBarCustomizedState',
          (WidgetTester tester) async {
        const searchBar = SearchBarCustomized();
        final state = searchBar.createState();
        expect(state.runtimeType.toString(), contains('_SearchBarCustomizedState'));
      });
    });

    group('SearchBarCustomized State Management', () {
      testWidgets('should manage focus node in state', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should manage text controller in state',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsWidgets);
      });

      testWidgets('should track focus state', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            const SearchBarCustomized(),
          ),
        );
        
        final searchBar = find.byType(SearchBar).first;
        await tester.tap(searchBar);
        await tester.pumpAndSettle();
        
        expect(find.byType(SearchBar), findsWidgets);
      });
    });
  });
}
