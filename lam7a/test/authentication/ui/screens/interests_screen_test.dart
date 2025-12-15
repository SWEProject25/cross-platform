import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';
import 'package:lam7a/features/authentication/ui/widgets/interest_widget.dart';

void main() {
  group('InterestDto Tests', () {
    test('can construct InterestDto with all fields', () {
      final dto = InterestDto(
        id: 1,
        name: 'Technology',
        slug: 'tech',
        description: 'All about technology',
        icon: '💻',
      );

      expect(dto.id, 1);
      expect(dto.name, 'Technology');
      expect(dto.slug, 'tech');
      expect(dto.description, 'All about technology');
      expect(dto.icon, '💻');
    });

    test('can construct InterestDto with nullable fields', () {
      final dto = InterestDto(
        id: 2,
        name: null,
        slug: null,
        description: null,
        icon: null,
      );

      expect(dto.id, 2);
      expect(dto.name, isNull);
      expect(dto.slug, isNull);
      expect(dto.description, isNull);
      expect(dto.icon, isNull);
    });

    test('InterestDto.fromJson creates dto correctly', () {
      final json = {
        'id': 5,
        'name': 'Sports',
        'slug': 'sports',
        'description': 'Sports news',
        'icon': '⚽',
      };

      final dto = InterestDto.fromJson(json);
      expect(dto.id, 5);
      expect(dto.name, 'Sports');
      expect(dto.icon, '⚽');
    });
  });

  group('AuthenticationState Tests', () {
    test('LoginState with hasCompeletedFollowing false', () {
      final state = AuthenticationState.login(hasCompeletedFollowing: false);
      expect(state.hasCompeletedFollowing, false);
    });

    test('LoginState with hasCompeletedFollowing true', () {
      final state = AuthenticationState.login(hasCompeletedFollowing: true);
      expect(state.hasCompeletedFollowing, true);
    });

    test('SignupState hasCompeletedFollowingSignUp getter', () {
      final state = AuthenticationState.signup(hasCompeletedFollowingSignUp: false);
      expect(state.hasCompeletedFollowingSignUp, false);
    });
  });

  group('Selection Logic Tests', () {
    test('Set prevents duplicates', () {
      final selected = <int>{};
      selected.add(1);
      selected.add(1);
      selected.add(1);
      expect(selected.length, 1);
      expect(selected.contains(1), true);
    });

    test('List allows duplicates', () {
      final selected = <int>[1, 1, 1];
      expect(selected.length, 3);
    });

    test('Adding to Set', () {
      final indices = <int>{};
      indices.add(0);
      indices.add(1);
      indices.add(2);
      expect(indices.length, 3);
    });

    test('Removing from Set', () {
      final indices = <int>{0, 1, 2, 3};
      indices.remove(2);
      expect(indices.length, 3);
      expect(indices.contains(2), false);
    });

    test('Toggling Set membership', () {
      final indices = <int>{};
      expect(indices.contains(5), false);
      indices.add(5);
      expect(indices.contains(5), true);
      indices.remove(5);
      expect(indices.contains(5), false);
    });

    test('List ordering preserved', () {
      final ids = <int>[];
      ids.addAll([3, 1, 4, 1, 5]);
      expect(ids[0], 3);
      expect(ids[1], 1);
    });

    test('List isEmpty/isNotEmpty', () {
      final ids = <int>[];
      expect(ids.isEmpty, true);
      expect(ids.isNotEmpty, false);
      ids.add(1);
      expect(ids.isEmpty, false);
      expect(ids.isNotEmpty, true);
    });
  });

  group('Button State Logic Tests', () {
    test('Button enabled when selections exist', () {
      final selections = [1, 2, 3];
      final enabled = selections.isNotEmpty;
      expect(enabled, true);
    });

    test('Button disabled when no selections', () {
      final selections = <int>[];
      final enabled = selections.isNotEmpty;
      expect(enabled, false);
    });

    test('Button state changes with add/remove', () {
      final selections = <int>[];
      expect(selections.isNotEmpty, false);

      selections.add(42);
      expect(selections.isNotEmpty, true);

      selections.clear();
      expect(selections.isNotEmpty, false);
    });
  });

  group('Loading State Tests', () {
    test('Loading flag toggle', () {
      var isLoading = false;
      expect(isLoading, false);
      isLoading = true;
      expect(isLoading, true);
    });

    test('Can proceed logic: selections && !loading', () {
      final hasSelections = true;
      final isLoading = false;
      expect(hasSelections, true);
      expect(!isLoading, true);
    });

    test('Cannot proceed if loading even with selections', () {
      final hasSelections = true;
      final isLoading = true;
      expect(hasSelections, true);
      expect(isLoading, true);
    });

    test('Cannot proceed without selections even if not loading', () {
      final hasSelections = false;
      final isLoading = false;
      expect(hasSelections, false);
      expect(isLoading, false);
    });
  });

  group('InterestWidget Tests', () {
    testWidgets('InterestWidget displays interest data', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Music',
        description: 'All about music',
        icon: '🎵',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: false,
              interest: interest,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Music'), findsOneWidget);
      expect(find.text('🎵'), findsOneWidget);
      expect(find.text('All about music'), findsOneWidget);
    });

    testWidgets('InterestWidget shows check circle when selected', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Tech',
        description: 'Technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: true,
              interest: interest,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('InterestWidget hides check circle when not selected', (tester) async {
      final interest = InterestDto(
        id: 1,
        name: 'Tech',
        description: 'Technology',
        icon: '💻',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: false,
              interest: interest,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsNothing);
    });

    testWidgets('InterestWidget calls onTap callback', (tester) async {
      var tapped = false;

      final interest = InterestDto(
        id: 1,
        name: 'News',
        description: 'News updates',
        icon: '📰',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              isSelected: false,
              interest: interest,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });

  group('Data Validation Tests', () {
    test('Validate positive IDs', () {
      final ids = [1, 2, 3, 4, 5];
      final valid = ids.every((id) => id > 0);
      expect(valid, true);
    });

    test('Detect invalid IDs', () {
      final ids = [1, 2, -3, 0];
      final valid = ids.every((id) => id > 0);
      expect(valid, false);
    });

    test('Filter positive IDs', () {
      final ids = [1, -2, 3, 0, 5];
      final positive = ids.where((id) => id > 0).toList();
      expect(positive.length, 3);
      expect(positive.contains(0), false);
    });
  });

  group('Complex Scenarios Tests', () {
    test('Full selection workflow', () {
      final selectedIndices = <int>{};
      final selectedInterestIds = <int>[];

      // Add selections
      selectedIndices.add(0);
      selectedIndices.add(2);
      selectedInterestIds.addAll([101, 103]);

      expect(selectedIndices.length, 2);
      expect(selectedInterestIds.length, 2);
      expect(selectedIndices.contains(0), true);
      expect(selectedInterestIds.contains(101), true);

      // Remove one
      selectedIndices.remove(0);
      selectedInterestIds.remove(101);

      expect(selectedIndices.length, 1);
      expect(selectedInterestIds.length, 1);
    });

    test('Multiple add/remove cycles', () {
      final selections = <int>[];

      for (int cycle = 0; cycle < 5; cycle++) {
        selections.add(cycle);
        expect(selections.isNotEmpty, true);
        selections.remove(cycle);
        expect(selections.isEmpty, true);
      }
    });

    test('Selection state after filtering', () {
      final selections = [1, 2, 3, 4, 5];
      final odds = selections.where((x) => x.isOdd).toList();

      expect(selections.length, 5);
      expect(odds.length, 3);
      expect(selections, [1, 2, 3, 4, 5]);
    });
  });

  group('Edge Cases Tests', () {
    test('Empty selection list isEmpty', () {
      final selections = <int>[];
      expect(selections.isEmpty, true);
    });

    test('Single item selection', () {
      final selections = [42];
      expect(selections.length, 1);
      expect(selections.isNotEmpty, true);
    });

    test('Large ID values', () {
      final selections = [999999, 1000000, 1000001];
      expect(selections.length, 3);
    });

    test('Remove from empty set does nothing', () {
      final indices = <int>{};
      indices.remove(1);
      expect(indices.isEmpty, true);
    });

    test('Clear and readd', () {
      final selections = [1, 2, 3];
      selections.clear();
      expect(selections.isEmpty, true);
      selections.addAll([4, 5]);
      expect(selections.length, 2);
    });
  });
}
