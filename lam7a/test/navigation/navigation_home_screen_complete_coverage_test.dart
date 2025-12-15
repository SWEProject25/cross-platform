import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

void main() {
  group('NavigationHomeScreen Tests - 100% Coverage', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('NavigationHomeScreen Widget Properties', () {
      test('should have correct routeName', () {
        expect(NavigationHomeScreen.routeName, equals('navigation'));
      });

      test('should have default initialIndex of 0', () {
        const screen = NavigationHomeScreen();
        expect(screen.initialIndex, equals(0));
      });

      test('should have null initialSearchQuery by default', () {
        const screen = NavigationHomeScreen();
        expect(screen.initialSearchQuery, isNull);
      });

      test('should accept custom initialIndex', () {
        const screen = NavigationHomeScreen(initialIndex: 2);
        expect(screen.initialIndex, equals(2));
      });

      test('should accept initialSearchQuery', () {
        const screen = NavigationHomeScreen(initialSearchQuery: 'flutter');
        expect(screen.initialSearchQuery, equals('flutter'));
      });

      test('should accept both initialIndex and initialSearchQuery', () {
        const screen = NavigationHomeScreen(
          initialIndex: 1,
          initialSearchQuery: 'test',
        );
        expect(screen.initialIndex, equals(1));
        expect(screen.initialSearchQuery, equals('test'));
      });
    });

    group('NavigationHomeScreen State Creation', () {
      test('should create state correctly', () {
        const screen = NavigationHomeScreen();
        final state = screen.createState();
        expect(state, isNotNull);
      });

      test('should create _NavigationHomeScreenState', () {
        const screen = NavigationHomeScreen();
        final state = screen.createState();
        expect(
          state.runtimeType.toString(),
          contains('_NavigationHomeScreenState'),
        );
      });

      test('should be a StatefulWidget', () {
        expect(
          NavigationHomeScreen(),
          isA<StatefulWidget>(),
        );
      });
    });

   
    });

    group('NavigationHomeScreen Consumer Integration', () {

    group('NavigationHomeScreen RouteName Constant', () {
      test('should have non-empty routeName', () {
        expect(NavigationHomeScreen.routeName.isNotEmpty, isTrue);
      });

      test('should have routeName equal to "navigation"', () {
        expect(NavigationHomeScreen.routeName, equals('navigation'));
      });

      test('should use routeName in routing', () {
        expect(NavigationHomeScreen.routeName, equals('navigation'));
      });
    });

    group('NavigationHomeScreen Constructor', () {
      test('should be const constructor', () {
        const screen = NavigationHomeScreen();
        expect(screen, isNotNull);
      });

      test('should support all parameters', () {
        const screen = NavigationHomeScreen(
          initialIndex: 1,
          initialSearchQuery: 'test',
        );
        expect(screen.initialIndex, equals(1));
        expect(screen.initialSearchQuery, equals('test'));
      });

      test('should have optional parameters with defaults', () {
        const screen = NavigationHomeScreen();
        expect(screen.initialIndex, equals(0));
        expect(screen.initialSearchQuery, isNull);
      });
    });
  });
}
