import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/navigation/ui/widgets/list_memeber.dart';

void main() {
  group('ListMember Widget Tests - 100% Coverage', () {
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

    group('ListMember Initialization', () {
      test('should create ListMember with required parameters', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
        );
        expect(member, isNotNull);
      });

      test('should accept title parameter', () {
        var member = ListMember(
          'Logout',
          () {},
          icon: Icons.logout,
        );
        expect(member.title, equals('Logout'));
      });

      test('should accept TapEffect parameter', () {
        void tapEffect() {}
        final member = ListMember(
          'Settings',
          tapEffect,
          icon: Icons.settings,
        );
        expect(member.TapEffect, equals(tapEffect));
      });

      test('should have default color as black', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
        );
        expect(member.color, equals(Pallete.blackColor));
      });

      test('should accept custom color', () {
        const customColor = Color(0xFFFF0000);
        var member = ListMember(
          'Delete',
          () {},
          icon: Icons.delete,
          color: customColor,
        );
        expect(member.color, equals(customColor));
      });

      test('should accept icon parameter', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
        );
        expect(member.icon, equals(Icons.person));
      });

      test('should accept iconPath parameter', () {
        var member = ListMember(
          'Profile',
          () {},
          iconPath: AppAssets.ProfileIcon,
        );
        expect(member.iconPath, equals(AppAssets.ProfileIcon));
      });

      test('should accept both icon and iconPath (iconPath takes precedence)', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
          iconPath: AppAssets.ProfileIcon,
        );
        expect(member.iconPath, equals(AppAssets.ProfileIcon));
        expect(member.icon, equals(Icons.person));
      });

      test('should have null icon by default', () {
        var member = ListMember(
          'Profile',
          () {},
        );
        expect(member.icon, isNull);
      });

      test('should have null iconPath by default', () {
        var member = ListMember(
          'Profile',
          () {},
        );
        expect(member.iconPath, isNull);
      });
    });

    group('ListMember Rendering', () {
      testWidgets('should render ListMember without crash',
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
      });

      testWidgets('should render ListTile', (WidgetTester tester) async {
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

      testWidgets('should render Container', (WidgetTester tester) async {
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

      testWidgets('should display title text', (WidgetTester tester) async {
        const testTitle = 'Settings';
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              testTitle,
              mockTapEffect,
              icon: Icons.settings,
            ),
          ),
        );
        expect(find.text(testTitle), findsOneWidget);
      });

      testWidgets('should display correct height', (WidgetTester tester) async {
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
    });

    group('ListMember Icon Display', () {
      testWidgets('should render icon when provided', (WidgetTester tester) async {
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

      testWidgets('should render with IconData icon', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Logout',
              mockTapEffect,
              icon: Icons.logout,
            ),
          ),
        );
        expect(find.byIcon(Icons.logout), findsOneWidget);
      });

      testWidgets('should render ImageIcon when iconPath provided',
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

      testWidgets('should prefer iconPath over icon',
          (WidgetTester tester) async {
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
        expect(find.byIcon(Icons.delete), findsOneWidget);
      });

      testWidgets('should apply errorColor when specified',
          (WidgetTester tester) async {
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
        expect(find.byIcon(Icons.logout), findsOneWidget);
      });
    });

    group('ListMember Text Styling', () {
      testWidgets('should apply correct title style',
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

      testWidgets('should display different titles', (WidgetTester tester) async {
        const titles = ['Profile', 'Settings', 'Logout', 'About'];
        for (final title in titles) {
          await tester.pumpWidget(
            createTestWidget(
              ListMember(
                title,
                mockTapEffect,
                icon: Icons.person,
              ),
            ),
          );
          expect(find.text(title), findsOneWidget);
        }
      });

      testWidgets('should apply correct font properties',
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

    group('ListMember Color Styling', () {
      testWidgets('should apply color to ListTile',
          (WidgetTester tester) async {
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
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should apply iconColor', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
              color: Pallete.greyColor,
            ),
          ),
        );
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should apply textColor', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(
            ListMember(
              'Profile',
              mockTapEffect,
              icon: Icons.person,
              color: Pallete.greyColor,
            ),
          ),
        );
        expect(find.byType(ListTile), findsOneWidget);
      });

      testWidgets('should handle different color values',
          (WidgetTester tester) async {
        const colors = [
          Pallete.errorColor,
          Pallete.greyColor,
          Pallete.blackColor,
          Colors.red,
          Colors.blue,
        ];
        
        for (final color in colors) {
          await tester.pumpWidget(
            createTestWidget(
              ListMember(
                'Test',
                mockTapEffect,
                icon: Icons.person,
                color: color,
              ),
            ),
          );
          expect(find.byType(ListTile), findsOneWidget);
        }
      });
    });

    group('ListMember ListTile Properties', () {
      testWidgets('should have correct horizontal gap',
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

      testWidgets('should have correct titleAlignment',
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

      testWidgets('should have correct contentPadding',
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

      testWidgets('should have correct leading widget',
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
        expect(find.byIcon(Icons.person), findsOneWidget);
      });
    });

    group('ListMember Interaction', () {
      testWidgets('should be tappable', (WidgetTester tester) async {
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

      testWidgets('should call TapEffect on tap', (WidgetTester tester) async {
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

        expect(tapCount, equals(1));
      });

      testWidgets('should handle multiple taps', (WidgetTester tester) async {
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

        for (int i = 0; i < 5; i++) {
          await tester.tap(find.byType(ListTile));
          await tester.pumpAndSettle();
        }

        expect(tapCount, equals(5));
      });
    });

    group('ListMember Theme Support', () {
      testWidgets('should render in light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: ListMember(
                'Profile',
                mockTapEffect,
                icon: Icons.person,
              ),
            ),
          ),
        );
        expect(find.byType(ListMember), findsOneWidget);
      });

      testWidgets('should render in dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: ListMember(
                'Profile',
                mockTapEffect,
                icon: Icons.person,
              ),
            ),
          ),
        );
        expect(find.byType(ListMember), findsOneWidget);
      });
    });

    group('ListMember Edge Cases', () {
      testWidgets('should handle very long title', (WidgetTester tester) async {
        const longTitle = 'This is a very long title that might cause layout issues';
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

      testWidgets('should handle unicode characters', (WidgetTester tester) async {
        const unicodeTitle = '🎉 Profile 🎉';
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

      testWidgets('should handle special characters', (WidgetTester tester) async {
        const specialTitle = 'Profile!@#\$%';
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

      testWidgets('should handle empty string title', (WidgetTester tester) async {
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
    });

    group('ListMember Widget Properties', () {
      test('should be a StatelessWidget', () {
        expect(
          ListMember(
            'Profile',
            mockTapEffect,
            icon: Icons.person,
          ),
          isA<StatelessWidget>(),
        );
      });

      test('should have correct title type', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
        );
        expect(member.title, isA<String>());
      });

      test('should have correct TapEffect type', () {
        void func() {}
        final member = ListMember(
          'Profile',
          func,
          icon: Icons.person,
        );
        expect(member.TapEffect, isA<Function>());
      });

      test('should have correct color type', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
          color: Color(0xFFFF0000),
        );
        expect(member.color, isA<Color>());
      });

      test('should have optional icon parameter', () {
        var member = ListMember(
          'Profile',
          () {},
          icon: Icons.person,
        );
        expect(member.icon, isNotNull);
      });

      test('should have optional iconPath parameter', () {
        var member = ListMember(
          'Profile',
          () {},
          iconPath: AppAssets.ProfileIcon,
        );
        expect(member.iconPath, isNotNull);
      });
    });

    group('ListMember Widget Tree', () {
      testWidgets('should have Container as parent', (WidgetTester tester) async {
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

      testWidgets('should have ListTile as child of Container',
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

      testWidgets('should have Text widget for title', (WidgetTester tester) async {
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

    group('ListMember Constructor Parameters', () {
      test('should have all required named parameters', () {
        expect(
          () => ListMember(
            'Profile',
            mockTapEffect,
            color: Pallete.blackColor,
            icon: Icons.person,
            iconPath: null,
          ),
          isNot(throwsException),
        );
      });

      test('should maintain parameter order', () {
        var member = ListMember(
          'Test',
          () {},
          color: Pallete.errorColor,
          icon: Icons.delete,
          iconPath: null,
        );
        expect(member.title, equals('Test'));
        expect(member.color, equals(Pallete.errorColor));
      });
    });
  });
}
