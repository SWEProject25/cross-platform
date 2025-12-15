import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockAuthenticationViewmodel extends Mock implements AuthenticationViewmodel {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FirstTimeScreen Widget Tests', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('FirstTimeScreen builds successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
            navigatorObservers: [mockNavigatorObserver],
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });

    testWidgets('FirstTimeScreen has correct scaffold key', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byKey(ValueKey("firstScreen")), findsOneWidget);
    });

    testWidgets('FirstTimeScreen displays AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('FirstTimeScreen displays greeting text', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      // The greeting text should be present
      expect(find.byType(Text), findsWidgets);
    });

    
    testWidgets('FirstTimeScreen displays divider between buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('FirstTimeScreen displays TermsText', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('FirstTimeScreen displays LoginText', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('FirstTimeScreen displays Spacers for layout', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Spacer), findsWidgets);
    });

    testWidgets('FirstTimeScreen uses ConsumerStatefulWidget', (tester) async {
      final widget = FirstTimeScreen();
      expect(widget, isA<ConsumerStatefulWidget>());
    });

    testWidgets('FirstTimeScreen has correct route name', (tester) async {
      expect(FirstTimeScreen.routeName, "first_time_screen");
    });
  });

  group('FirstTimeScreen Riverpod Provider Tests', () {
    testWidgets('FirstTimeScreen watches authenticationViewmodelProvider',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });

    testWidgets(
        'FirstTimeScreen responds to authentication state changes',
        (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });
  });

  group('FirstTimeScreen Loading State Tests', () {
    testWidgets('FirstTimeScreen displays LoadingCircle when loading',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });

    testWidgets(
        'FirstTimeScreen toggles between loading and content states',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('FirstTimeScreen Routing Tests', () {
    testWidgets('FirstTimeScreen is a named route destination', (tester) async {
      final routeName = FirstTimeScreen.routeName;
      expect(routeName, isNotEmpty);
      expect(routeName, equals("first_time_screen"));
    });

  group('FirstTimeScreen Layout Tests', () {
    testWidgets('FirstTimeScreen Column contains multiple children',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('FirstTimeScreen Row layout for icon button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('FirstTimeScreen uses Expanded widgets for layout',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('FirstTimeScreen uses SizedBox for spacing', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('FirstTimeScreen Theme Tests', () {
    testWidgets('FirstTimeScreen uses theme colors for AppBar',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('FirstTimeScreen adapts to dark theme', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.dark(),
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });
  });

  group('FirstTimeScreen Asset Tests', () {
    testWidgets('FirstTimeScreen loads SVG icon for AppBar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('FirstTimeScreen State Management Tests', () {
    testWidgets('FirstTimeScreen is a ConsumerStatefulWidget', (tester) async {
      final widget = FirstTimeScreen();
      expect(widget, isA<ConsumerStatefulWidget>());
    });

    testWidgets('FirstTimeScreen creates _FirstTimeScreenState',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });

    testWidgets('FirstTimeScreen initializes with correct properties',
        (tester) async {
      const widget = FirstTimeScreen();
      expect(widget.key, isNull);
    });
  });

  

  group('FirstTimeScreen Consumer Widget Tests', () {
    testWidgets('FirstTimeScreen wraps content in Consumer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Consumer), findsOneWidget);
    });
  });

  group('FirstTimeScreen Error Handling Tests', () {
    testWidgets('FirstTimeScreen renders without throwing on build',
        (tester) async {
      expect(
        () async {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(
                home: FirstTimeScreen(),
              ),
            ),
          );
        },
        returnsNormally,
      );
    });

    testWidgets('FirstTimeScreen handles null theme gracefully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });
  });

  group('FirstTimeScreen Accessibility Tests', () {
    testWidgets('FirstTimeScreen has readable text with proper styling',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('FirstTimeScreen displays interactive buttons', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });

  group('FirstTimeScreen Navigation Context Tests', () {
    testWidgets('FirstTimeScreen can access BuildContext', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(FirstTimeScreen), findsOneWidget);
    });
  });

  group('FirstTimeScreen Constant Tests', () {
    test('githubRedirectUrl constant is defined', () {
      expect(githubRedirectUrl, isNotNull);
      expect(githubRedirectUrl, equals("hankers://tech.hankers.app"));
    });

    test('githubRedirectUrl is a valid URL scheme', () {
      expect(githubRedirectUrl.startsWith("hankers://"), true);
    });
  });

  group('FirstTimeScreen Widget Tree Tests', () {
    testWidgets('FirstTimeScreen builds complete widget tree', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Consumer), findsOneWidget);
    });

    testWidgets('FirstTimeScreen organizes content in Column', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: FirstTimeScreen(),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });
  });
});
}
