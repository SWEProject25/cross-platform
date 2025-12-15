import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

void main() {
  group('NavigationHomeScreen Tests', () {
    setUp(() {
      // Setup code if needed
    });

    group('NavigationHomeScreen Properties', () {
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

      test('should be a StatefulWidget', () {
        const screen = NavigationHomeScreen();
        expect(screen, isA<StatefulWidget>());
      });
    });

    group('NavigationHomeScreen Constructor', () {
      test('should create instance with const', () {
        const screen = NavigationHomeScreen();
        expect(screen, isNotNull);
      });

      test('should create instance with key', () {
        const screen = NavigationHomeScreen(key: ValueKey('test'));
        expect(screen, isNotNull);
      });

      test('should handle multiple instances', () {
        const screen1 = NavigationHomeScreen(initialIndex: 0);
        const screen2 = NavigationHomeScreen(initialIndex: 1);
        
        expect(screen1.initialIndex, equals(0));
        expect(screen2.initialIndex, equals(1));
      });

      test('should handle edge case initialIndex values', () {
        const screen1 = NavigationHomeScreen(initialIndex: 0);
        const screen2 = NavigationHomeScreen(initialIndex: 3);
        const screen3 = NavigationHomeScreen(initialIndex: -1);
        
        expect(screen1.initialIndex, equals(0));
        expect(screen2.initialIndex, equals(3));
        expect(screen3.initialIndex, equals(-1));
      });

      test('should handle empty search query', () {
        const screen = NavigationHomeScreen(initialSearchQuery: '');
        expect(screen.initialSearchQuery, isEmpty);
      });

      test('should handle search query with special characters', () {
        const screen = NavigationHomeScreen(initialSearchQuery: '@#\$%');
        expect(screen.initialSearchQuery, equals('@#\$%'));
      });
    });


  });
}
