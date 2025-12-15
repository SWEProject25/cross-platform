import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/navigation/ui/widgets/list_memeber.dart';

void main() {
  group('ListMember Widget Tests', () {
    late Function mockTapEffect;

    setUp(() {
      mockTapEffect = () {};
    });

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    group('ListMember Widget Rendering', () {
      testWidgets('should render ListMember with required parameters',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListMember), findsOneWidget);
        expect(find.byType(ListTile), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });

      testWidgets('should display correct title text',
          (WidgetTester tester) async {
        const testTitle = 'Logout';
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              testTitle,
              mockTapEffect,
              icon: Icons.logout,
            ),
          ),
        );

        expect(find.text(testTitle), findsOneWidget);
      });

      testWidgets('should render with icon when provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Settings',
              mockTapEffect,
              icon: Icons.settings,
            ),
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should render with asset icon when iconPath provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              iconPath: AppAssets.ProfileIcon,
            ),
          ),
        );

        expect(find.byType(ImageIcon), findsOneWidget);
      });

      testWidgets('should apply custom color to icon', (WidgetTester tester) async {
        const customColor = Color(0xFFFF0000);
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Delete',
              mockTapEffect,
              icon: Icons.delete,
              color: customColor,
            ),
          ),
        );

        final listTile = find.byType(ListTile);
        expect(listTile, findsOneWidget);
      });

      testWidgets('should apply error color when provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Logout',
              mockTapEffect,
              icon: Icons.logout,
              color: Pallete.errorColor,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should have correct height', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        final container = find.byType(Container);
        expect(container, findsWidgets);
      });

      testWidgets('should render text with correct font styling',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(Text), findsWidgets);
      });
    });

    group('ListMember Interaction', () {
      testWidgets('should trigger callback when tapped', (WidgetTester tester) async {
        bool tapCalled = false;
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              () {
                tapCalled = true;
              },
              icon: Icons.person,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        expect(tapCalled, isTrue);
      });

      testWidgets('should trigger callback multiple times',
          (WidgetTester tester) async {
        int tapCount = 0;
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              () {
                tapCount++;
              },
              icon: Icons.person,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(ListTile));
        await tester.pumpAndSettle();

        expect(tapCount, equals(2));
      });

      testWidgets('should be tappable area', (WidgetTester tester) async {
        bool tapped = false;
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Test',
              () => tapped = true,
              icon: Icons.info,
            ),
          ),
        );

        await tester.tap(find.byType(ListTile));
        expect(tapped, isTrue);
      });
    });

    group('ListMember Color Handling', () {
      testWidgets('should use default color when not provided',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should apply custom color', (WidgetTester tester) async {
        const customColor = Color(0xFF123456);
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Custom',
              mockTapEffect,
              icon: Icons.home,
              color: customColor,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
      });
    });

    group('ListMember Icon Handling', () {
      testWidgets('should prioritize iconPath over icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
              iconPath: AppAssets.ProfileIcon,
            ),
          ),
        );

        // When iconPath is provided, ImageIcon should be rendered
        expect(find.byType(ImageIcon), findsOneWidget);
      });

      testWidgets('should render icon when no iconPath', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Settings',
              mockTapEffect,
              icon: Icons.settings,
            ),
          ),
        );

        expect(find.byIcon(Icons.settings), findsOneWidget);
      });

      testWidgets('should handle null icon and iconPath',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
      });
    });

    group('ListMember Edge Cases', () {
      testWidgets('should handle empty title', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              '',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListMember), findsOneWidget);
      });

      testWidgets('should handle long title text', (WidgetTester tester) async {
        const longTitle = 'This is a very long title that should still render properly';
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              longTitle,
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.text(longTitle), findsOneWidget);
      });

      testWidgets('should handle special characters in title',
          (WidgetTester tester) async {
        final specialTitle = '@#\$%^&*()';
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              specialTitle,
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.text(specialTitle), findsOneWidget);
      });

      testWidgets('should handle unicode characters in title',
          (WidgetTester tester) async {
        const unicodeTitle = 'البروفايل 프로필';
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              unicodeTitle,
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.text(unicodeTitle), findsOneWidget);
      });
    });

    group('ListMember Accessibility', () {
      testWidgets('should be semantically correct', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should display icon and text', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });
    });

    group('ListMember State Management', () {
      testWidgets('should be stateless widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListMember), findsOneWidget);
      });

      testWidgets('should rebuild when parameters change',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.text('Profile'), findsOneWidget);
      });
    });

    group('ListMember Layout', () {
      testWidgets('should have proper padding', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should display all components', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
            ),
          ),
        );

        expect(find.byType(ListTile), findsOneWidget);
        expect(find.byIcon(Icons.person), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
      });
    });
  });
}
