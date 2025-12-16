import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/widgets/clickable_text.dart';

void main() {
  group('ClickableText', () {
    testWidgets('should render with basic text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText('Hello World'),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('should render with custom style', (WidgetTester tester) async {
      const customStyle = TextStyle(fontSize: 20, color: Colors.red);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText(
              'Test text',
              style: customStyle,
            ),
          ),
        ),
      );

      expect(find.text('Test text'), findsOneWidget);
    });

    testWidgets('should render with maxLines', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText(
              'Line 1\nLine 2\nLine 3',
              maxLines: 2,
            ),
          ),
        ),
      );

      expect(find.byType(ClickableText), findsOneWidget);
    });

    testWidgets('should render with overflow', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText(
              'Very long text that should overflow',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      );

      expect(find.byType(ClickableText), findsOneWidget);
    });

    testWidgets('should render with all parameters', (WidgetTester tester) async {
      const customStyle = TextStyle(fontSize: 18, color: Colors.blue);
      
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText(
              'Complete test with URL https://example.com',
              style: customStyle,
              maxLines: 3,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      );

      expect(find.byType(ClickableText), findsOneWidget);
    });

    testWidgets('should render text with URLs', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText('Check out https://flutter.dev'),
          ),
        ),
      );

      expect(find.textContaining('flutter.dev'), findsOneWidget);
    });

    testWidgets('should render text with domains', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText('Visit google.com for search'),
          ),
        ),
      );

      expect(find.textContaining('google.com'), findsOneWidget);
    });

    testWidgets('should use default style when style is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClickableText('Default style text'),
          ),
        ),
      );

      expect(find.text('Default style text'), findsOneWidget);
    });
  });
}
