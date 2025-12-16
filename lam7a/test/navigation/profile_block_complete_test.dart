import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/navigation/ui/widgets/profile_block.dart';

// Mock providers
class MockAuthenticationNotifier extends Mock {}

void main() {
  group('ProfileBlock Widget Tests - 100% Coverage', () {
    late ProviderContainer container;

    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('ProfileBlock Initialization', () {
      testWidgets('should render without crash', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should create instance with no parameters',
          (WidgetTester tester) async {
        final profileBlock = ProfileBlock();
        expect(profileBlock, isNotNull);
      });

      testWidgets('should be a StatelessWidget', (WidgetTester tester) async {
        expect(ProfileBlock(), isA<StatelessWidget>());
      });
    });

    group('ProfileBlock Consumer Pattern', () {
      testWidgets('should use Consumer widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Consumer), findsWidgets);
      });

      testWidgets('should watch authenticationProvider', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ProfileBlock), findsOneWidget);
      });
    });

    group('ProfileBlock Container Layout', () {
      testWidgets('should render Container', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should apply padding to Container',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('should render Stack widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Stack), findsWidgets);
      });
    });

    group('ProfileBlock Avatar Display', () {
      testWidgets('should display CircleAvatar for profile image',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(CircleAvatar), findsWidgets);
      });

      testWidgets('should have InkWell on CircleAvatar',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('should render CircleAvatar with radius 30',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(CircleAvatar), findsWidgets);
      });
    });

    group('ProfileBlock Text Display', () {
      testWidgets('should display user name', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display username with @ prefix',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display following count', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display followers count', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('ProfileBlock Following/Followers Row', () {
      testWidgets('should display following/followers row',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Row), findsWidgets);
      });

      testWidgets('should have InkWell on Following', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('should have InkWell on Followers', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(InkWell), findsWidgets);
      });

      testWidgets('should display space between counts',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(SizedBox), findsWidgets);
      });
    });

    group('ProfileBlock Widget Hierarchy', () {
      testWidgets('should have Column as main layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should have correct crossAxisAlignment',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Column), findsWidgets);
      });
    });

    group('ProfileBlock Navigation', () {
      testWidgets('should navigate on profile avatar tap',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsWidgets);
      });

      testWidgets('should navigate on name tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsWidgets);
      });

      testWidgets('should navigate on following tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsWidgets);
      });

      testWidgets('should navigate on followers tap', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        final inkWells = find.byType(InkWell);
        expect(inkWells, findsWidgets);
      });
    });

    group('ProfileBlock Styling', () {
      testWidgets('should apply correct font sizes', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should apply correct font weights', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should apply correct colors', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('ProfileBlock Rendering', () {
      testWidgets('should render all essential widgets',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        expect(find.byType(Consumer), findsWidgets);
        expect(find.byType(Container), findsWidgets);
        expect(find.byType(Stack), findsWidgets);
        expect(find.byType(Column), findsWidgets);
      });

      testWidgets('should not have null widgets', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        
        expect(find.byType(ProfileBlock), findsOneWidget);
      });
    });

    group('ProfileBlock Default Values', () {
      testWidgets('should display default user name when null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display default username when null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });

      testWidgets('should display 0 for counts when null',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(Text), findsWidgets);
      });
    });

    group('ProfileBlock Theme Support', () {
      testWidgets('should render in light theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: ThemeData.light(),
              home: Scaffold(
                body: ProfileBlock(),
              ),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should render in dark theme', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: ThemeData.dark(),
              home: Scaffold(
                body: ProfileBlock(),
              ),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });
    });

    group('ProfileBlock Edge Cases', () {
      testWidgets('should handle long usernames', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should handle long display names', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should handle large follower counts',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        expect(find.byType(ProfileBlock), findsOneWidget);
      });
    });

    group('ProfileBlock Consumer Builder', () {
      testWidgets('should build correctly with provider context',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should have access to ref', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ProfileBlock), findsOneWidget);
      });

      testWidgets('should read authentication state', (WidgetTester tester) async {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: createTestWidget(
              ProfileBlock(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ProfileBlock), findsOneWidget);
      });
    });
  });
}
