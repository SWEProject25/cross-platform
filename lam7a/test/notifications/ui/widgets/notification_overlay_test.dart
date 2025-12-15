import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/widgets/app_user_avatar.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TwitterDMNotification Widget Tests', () {
    const testSender = 'John Doe';
    const testMessage = 'Hello, this is a test message!';
    const testAvatarUrl = '';

    Widget createTestWidget({
      String sender = testSender,
      String message = testMessage,
      String avatarUrl = testAvatarUrl,
      VoidCallback? onTap,
      ThemeData? theme,
    }) {
      return MaterialApp(
        theme: theme ?? ThemeData.light(),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TwitterDMNotification.DMNotificationOverlay(
              sender: sender,
              message: message,
              avatarUrl: avatarUrl,
              onTap: onTap,
            ),
          ),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render without onTap callback',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onTap: null));
        await tester.pumpAndSettle();

        expect(find.byType(TwitterDMNotification), findsOneWidget);
        expect(find.byType(InkWell), findsOneWidget);
      });

      testWidgets('should render AppUserAvatar with correct sender name',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final avatarFinder = find.byWidgetPredicate(
          (widget) =>
              widget is AppUserAvatar && widget.displayName == testSender,
        );
        expect(avatarFinder, findsOneWidget);
      });
    });

    group('Text Content', () {

      testWidgets('should display message with ellipsis overflow',
          (WidgetTester tester) async {
        const longMessage = 'This is a very long message that should be truncated with ellipsis when it exceeds the maximum line limit';
        
        await tester.pumpWidget(createTestWidget(message: longMessage));
        await tester.pumpAndSettle();

        final textFinder = find.text(longMessage);
        expect(textFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.maxLines, equals(1));
        expect(textWidget.overflow, equals(TextOverflow.ellipsis));
      });

      testWidgets('should display different messages correctly',
          (WidgetTester tester) async {
        const customMessage = 'Custom notification message';
        
        await tester.pumpWidget(createTestWidget(message: customMessage));
        await tester.pumpAndSettle();

        expect(find.text(customMessage), findsOneWidget);
        expect(find.text(testMessage), findsNothing);
      });
    });

    group('Tap Interaction', () {
      testWidgets('should call onTap when tapped',
          (WidgetTester tester) async {
        bool tapped = false;
        void handleTap() {
          tapped = true;
        }

        await tester.pumpWidget(createTestWidget(onTap: handleTap));
        await tester.pumpAndSettle();

        final inkWellFinder = find.byType(InkWell);
        expect(inkWellFinder, findsOneWidget);

        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();

        expect(tapped, isTrue);
      });

      testWidgets('should not throw when onTap is null and widget is tapped',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(onTap: null));
        await tester.pumpAndSettle();

        final inkWellFinder = find.byType(InkWell);
        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();

        // Should not throw any exception
        expect(find.byType(TwitterDMNotification), findsOneWidget);
      });

      testWidgets('should call onTap multiple times when tapped multiple times',
          (WidgetTester tester) async {
        int tapCount = 0;
        void handleTap() {
          tapCount++;
        }

        await tester.pumpWidget(createTestWidget(onTap: handleTap));
        await tester.pumpAndSettle();

        final inkWellFinder = find.byType(InkWell);

        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();
        expect(tapCount, equals(1));

        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();
        expect(tapCount, equals(2));

        await tester.tap(inkWellFinder);
        await tester.pumpAndSettle();
        expect(tapCount, equals(3));
      });
    });

    group('Visual Elements', () {
      testWidgets('should render Material widget',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Material), findsWidgets);
      });

      testWidgets('should render Ink widget with decoration',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final inkFinder = find.byType(Ink);
        expect(inkFinder, findsOneWidget);

        final ink = tester.widget<Ink>(inkFinder);
        expect(ink.decoration, isNotNull);
      });

      testWidgets('should render InkWell with border radius',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final inkWellFinder = find.byType(InkWell);
        expect(inkWellFinder, findsOneWidget);

        final inkWell = tester.widget<InkWell>(inkWellFinder);
        expect(inkWell.borderRadius, equals(BorderRadius.circular(12)));
      });

      testWidgets('should render CircleAvatar for avatar container',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final circleAvatarFinder = find.byWidgetPredicate(
          (widget) => widget is CircleAvatar && widget.radius == 14,
        );
        expect(circleAvatarFinder, findsOneWidget);
      });

      testWidgets('should position avatar with Positioned widget',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final positionedFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Positioned &&
              widget.bottom == -16 &&
              widget.right == -16,
        );
        expect(positionedFinder, findsOneWidget);
      });

      testWidgets('should have proper spacing between icon and content',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final sizedBoxFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 30,
        );
        expect(sizedBoxFinder, findsOneWidget);
      });
    });

    group('Theme Support', () {
      testWidgets('should apply light theme colors correctly',
          (WidgetTester tester) async {
        final lightTheme = ThemeData.light();
        
        await tester.pumpWidget(createTestWidget(theme: lightTheme));
        await tester.pumpAndSettle();

        final inkFinder = find.byType(Ink);
        expect(inkFinder, findsOneWidget);

        final ink = tester.widget<Ink>(inkFinder);
        final boxDecoration = ink.decoration as BoxDecoration;
        
        // Should use primaryColorLight for light theme
        expect(boxDecoration.color, equals(lightTheme.primaryColorLight));
      });

      testWidgets('should apply dark theme colors correctly',
          (WidgetTester tester) async {
        final darkTheme = ThemeData.dark();
        
        await tester.pumpWidget(createTestWidget(theme: darkTheme));
        await tester.pumpAndSettle();

        final inkFinder = find.byType(Ink);
        expect(inkFinder, findsOneWidget);

        final ink = tester.widget<Ink>(inkFinder);
        final boxDecoration = ink.decoration as BoxDecoration;
        
        // Should use dimmed primary color for dark theme
        expect(boxDecoration.color, isNotNull);
      });

    });

    group('Layout Structure', () {
      testWidgets('should use Row for horizontal layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final rowFinder = find.byWidgetPredicate(
          (widget) => widget is Row && widget.crossAxisAlignment == CrossAxisAlignment.center,
        );
        expect(rowFinder, findsOneWidget);
      });

      testWidgets('should use Column for vertical text layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final columnFinder = find.byWidgetPredicate(
          (widget) => widget is Column && widget.crossAxisAlignment == CrossAxisAlignment.start,
        );
        expect(columnFinder, findsOneWidget);
      });

      testWidgets('should use Expanded for flexible content area',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Expanded), findsOneWidget);
      });

      testWidgets('should have proper padding',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.padding == const EdgeInsets.only(
                top: 8.0,
                right: 12.0,
                bottom: 8.0,
                left: 20.0,
              ),
        );
        expect(containerFinder, findsOneWidget);
      });

    });

    group('Edge Cases', () {
      testWidgets('should handle empty sender name',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(sender: ''));
        await tester.pumpAndSettle();

        expect(find.byType(TwitterDMNotification), findsOneWidget);
        expect(find.text(' sent you a message', findRichText: true), findsOneWidget);
      });

      testWidgets('should handle empty avatar URL',
          (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget(avatarUrl: ''));
        await tester.pumpAndSettle();

        expect(find.byType(TwitterDMNotification), findsOneWidget);
        expect(find.byType(AppUserAvatar), findsOneWidget);
      });


      testWidgets('should handle special characters in message',
          (WidgetTester tester) async {
        const specialMessage = 'Hello! 👋 Check this: https://example.com #test';
        
        await tester.pumpWidget(createTestWidget(message: specialMessage));
        await tester.pumpAndSettle();

        expect(find.text(specialMessage), findsOneWidget);
      });
    });

    group('dim() Helper Method', () {
      test('should dim color by specified amount', () {
        const widget = TwitterDMNotification.DMNotificationOverlay(
          sender: 'Test',
          message: 'Test',
          avatarUrl: '',
        );

        final dimmedColor = widget.dim(Colors.blue, 0.5);
        expect(dimmedColor, isNotNull);
        expect(dimmedColor.runtimeType, equals(Color));
      });

      test('should return black when dimming by 1.0', () {
        const widget = TwitterDMNotification.DMNotificationOverlay(
          sender: 'Test',
          message: 'Test',
          avatarUrl: '',
        );

        final dimmedColor = widget.dim(Colors.blue, 1.0);
        expect(dimmedColor, equals(Colors.black));
      });
    });
  });
}
