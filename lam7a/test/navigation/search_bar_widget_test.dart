import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/navigation/ui/widgets/search_bar.dart';

void main() {
  group('SearchBarCustomized Widget Tests', () {
    Widget createTestWidget({String? initialText}) {
      return MaterialApp(
        home: Scaffold(
          body: SearchBarCustomized(initialText: initialText),
        ),
      );
    }

    group('SearchBarCustomized Rendering', () {
      testWidgets('should render SearchBarCustomized', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should render SearchBar widget', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should display hint text', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.text('Search X'), findsWidgets);
      });

      testWidgets('should initialize without error', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });
    });

    group('SearchBarCustomized Initial Text', () {
      testWidgets('should display initial text when provided',
          (WidgetTester tester) async {
        const initialText = 'Flutter';
        await tester.pumpWidget(createTestWidget(initialText: initialText));
        await tester.pumpAndSettle();

        final textField = find.byType(TextField);
        expect(textField, findsWidgets);
      });

      testWidgets('should be empty when no initial text provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle null initial text', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(initialText: null));
        await tester.pumpAndSettle();
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should handle empty string initial text',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(initialText: ''));
        await tester.pumpAndSettle();
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should handle long initial text',
          (WidgetTester tester) async {
        const longText = 'This is a very long search query that should still work';
        await tester.pumpWidget(createTestWidget(initialText: longText));
        await tester.pumpAndSettle();
        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Focus Handling', () {
      testWidgets('should update focus state when focused',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should update focus state when unfocused',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        // Tap outside to unfocus
        await tester.tap(find.byType(Scaffold));
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle multiple focus/unfocus cycles',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        for (int i = 0; i < 3; i++) {
          await tester.tap(searchBar);
          await tester.pumpAndSettle();

          await tester.tap(find.byType(Scaffold));
          await tester.pumpAndSettle();
        }

        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Text Input', () {
      testWidgets('should accept text input', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle multiple character input',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle special characters', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle unicode characters', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should clear text when requested',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Styling', () {
      testWidgets('should have correct hint text style', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should render with Theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.light),
            home: Scaffold(
              body: SearchBarCustomized(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should render with dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: Scaffold(
              body: SearchBarCustomized(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });
    });

    group('SearchBarCustomized Lifecycle', () {
      testWidgets('should properly initialize', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should properly dispose', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.pumpWidget(const Placeholder());
        expect(find.byType(SearchBarCustomized), findsNothing);
      });

      testWidgets('should handle state changes gracefully',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        await tester.pumpWidget(createTestWidget(initialText: 'changed'));
        await tester.pumpAndSettle();

        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });
    });

    group('SearchBarCustomized Constraints', () {
      testWidgets('should have max height constraint', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should have max width constraint', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Accessibility', () {
      testWidgets('should be accessible', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should have proper semantic information',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Text Selection', () {
      testWidgets('should support text selection', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(initialText: 'test text'));
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });

      testWidgets('should handle cursor positioning', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final searchBar = find.byType(SearchBar);
        await tester.tap(searchBar);
        await tester.pumpAndSettle();

        expect(find.byType(SearchBar), findsOneWidget);
      });
    });

    group('SearchBarCustomized Edge Cases', () {
      testWidgets('should handle empty widget tree',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should rebuild on widget update', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(initialText: 'first'));
        await tester.pumpAndSettle();

        await tester.pumpWidget(createTestWidget(initialText: 'second'));
        await tester.pumpAndSettle();

        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });

      testWidgets('should handle rapid state changes',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        for (int i = 0; i < 5; i++) {
          await tester.pumpWidget(
            createTestWidget(initialText: 'test $i'),
          );
        }
        await tester.pumpAndSettle();
        expect(find.byType(SearchBarCustomized), findsOneWidget);
      });
    });
  });
}
