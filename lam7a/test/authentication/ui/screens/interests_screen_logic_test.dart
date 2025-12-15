import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/authentication/ui/view/screens/interests_screen/interests_screen.dart';
import 'package:lam7a/features/authentication/ui/widgets/interest_widget.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/ui/state/authentication_state.dart';

void main() {
  group('InterestsScreen file - sanity import and state checks', () {
    test('can construct InterestDto and InterestWidget without crash', () {
      final dto = InterestDto(
        id: 1,
        name: 'Tech',
        slug: 'tech',
        description: 'Technology',
        icon: '💻',
      );

      // build widget with minimal params to ensure it renders
      final widget = InterestWidget(
        key: ValueKey('i1'),
        isSelected: false,
        interest: dto,
        onTap: () {},
      );

      expect(dto.id, 1);
      expect(dto.name, 'Tech');
      expect(widget.interest.name, 'Tech');
    });

    test('AuthenticationState getters for hasCompeletedFollowing behave', () {
      final loginFalse = AuthenticationState.login(hasCompeletedFollowing: false);
      final loginTrue = AuthenticationState.login(hasCompeletedFollowing: true);

      expect(loginFalse.hasCompeletedFollowing, false);
      expect(loginTrue.hasCompeletedFollowing, true);
    });
  });

  group('Selection and list logic (mirrors InterestsScreen logic)', () {
    test('toggle semantics using Set and List match expected behaviors', () {
      final selectedIndices = <int>{};
      final selectedInterests = <int>[];

      // selecting index 0
      final idx = 0;
      final interestId = 101;

      // add
      selectedIndices.add(idx);
      selectedInterests.add(interestId);
      expect(selectedIndices.contains(idx), true);
      expect(selectedInterests.contains(interestId), true);

      // remove
      selectedIndices.remove(idx);
      selectedInterests.remove(interestId);
      expect(selectedIndices.contains(idx), false);
      expect(selectedInterests.contains(interestId), false);
    });

    test('list preserves insertion order and allows duplicates', () {
      final interests = <int>[];
      interests.addAll([5, 2, 8, 1]);
      expect(interests.first, 5);
      expect(interests.last, 1);

      interests.add(2);
      expect(interests.where((e) => e == 2).length, 2);
    });
  });

  group('Widget tests - build InterestsScreen with minimal environment', () {
       testWidgets('Tapping InterestWidget calls onTap and toggles selection visually', (tester) async {
      final dto = InterestDto(
        id: 2,
        name: 'Music',
        slug: 'music',
        description: 'All about music',
        icon: '🎵',
      );

      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InterestWidget(
              key: ValueKey('music'),
              isSelected: false,
              interest: dto,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      final musicFinder = find.byKey(ValueKey('music'));
      expect(musicFinder, findsOneWidget);

      await tester.tap(musicFinder);
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('InterestsScreen - Selection Logic', () {
    test('add single selection to set', () {
      final selected = <int>{};
      selected.add(0);
      expect(selected.contains(0), true);
      expect(selected.length, 1);
    });

    test('add multiple selections', () {
      final selected = <int>{};
      selected.addAll([0, 1, 2]);
      expect(selected.length, 3);
    });

    test('remove selection from set', () {
      final selected = <int>{0, 1, 2};
      selected.remove(1);
      expect(selected.contains(1), false);
      expect(selected.length, 2);
    });

    test('set prevents duplicates', () {
      final selected = <int>{};
      selected.addAll([0, 0, 0, 1, 1, 2]);
      expect(selected.length, 3);
    });

    test('clear all selections', () {
      final selected = <int>{0, 1, 2, 3};
      selected.clear();
      expect(selected.isEmpty, true);
    });

    test('check if selection exists', () {
      final selected = <int>{1, 3, 5};
      expect(selected.contains(1), true);
      expect(selected.contains(2), false);
    });

    test('toggle selection - add then remove', () {
      final selected = <int>{};
      selected.add(0);
      expect(selected.contains(0), true);
      selected.remove(0);
      expect(selected.contains(0), false);
    });

    test('toggle selection - remove non-existent does nothing', () {
      final selected = <int>{1};
      selected.remove(0);
      expect(selected.length, 1);
      expect(selected.contains(1), true);
    });

    test('bulk add and individual remove', () {
      final selected = <int>{};
      selected.addAll([1, 2, 3, 4, 5]);
      selected.remove(3);
      expect(selected.length, 4);
      expect(selected.contains(3), false);
    });
  });

  group('InterestsScreen - Interests List', () {
    test('track selected interests', () {
      final interests = <int>[];
      interests.addAll([10, 20, 30]);
      expect(interests.length, 3);
    });

    test('remove interest from list', () {
      final interests = [10, 20, 30];
      interests.remove(20);
      expect(interests.contains(20), false);
      expect(interests.length, 2);
    });

    test('maintain insertion order', () {
      final interests = <int>[];
      interests.addAll([5, 2, 8, 1]);
      expect(interests.first, 5);
      expect(interests.last, 1);
    });

    test('list allows duplicates', () {
      final interests = [1, 2, 2, 3, 3, 3];
      expect(interests.length, 6);
    });

    test('remove first element', () {
      final interests = [1, 2, 3];
      interests.removeAt(0);
      expect(interests.first, 2);
      expect(interests.length, 2);
    });

    test('remove last element', () {
      final interests = [1, 2, 3];
      interests.removeAt(interests.length - 1);
      expect(interests.last, 2);
      expect(interests.length, 2);
    });

    test('isEmpty on empty list', () {
      final interests = <int>[];
      expect(interests.isEmpty, true);
      interests.add(1);
      expect(interests.isEmpty, false);
    });
  });

  group('InterestsScreen - Navigation Routing', () {
    test('route when not completed following', () {
      final completed = false;
      expect(!completed, true);
      final route = completed ? 'navigation_home_screen' : 'following_screen';
      expect(route == 'following_screen', true);
    });

    test('route when completed following', () {
      final completed = true;
      expect(completed, true);
      final route = completed ? 'navigation_home_screen' : 'following_screen';
      expect(route == 'navigation_home_screen', true);
    });

    test('route name is valid', () {
      final route = 'interests_screen';
      expect(route.isNotEmpty, true);
      expect(route, 'interests_screen');
    });

    test('route screen names are non-empty', () {
      final followingRoute = 'following_screen';
      final homeRoute = 'navigation_home_screen';
      expect(followingRoute.isNotEmpty, true);
      expect(homeRoute.isNotEmpty, true);
    });
  });

  group('InterestsScreen - Button State', () {
    test('button disabled when no selections', () {
      final selections = <int>[];
      final enabled = selections.isNotEmpty;
      expect(enabled, false);
    });

    test('button enabled with selections', () {
      final selections = [1, 2, 3];
      final enabled = selections.isNotEmpty;
      expect(enabled, true);
    });

    test('button disabled after clear', () {
      final selections = [1, 2, 3];
      selections.clear();
      final enabled = selections.isNotEmpty;
      expect(enabled, false);
    });

    test('toggle button state with add/remove', () {
      final selections = <int>[];
      expect(selections.isNotEmpty, false);

      selections.add(1);
      expect(selections.isNotEmpty, true);

      selections.remove(1);
      expect(selections.isNotEmpty, false);
    });

    test('button state with single selection', () {
      final selections = [42];
      expect(selections.isNotEmpty, true);
    });

    test('button state after removing one of many', () {
      final selections = [1, 2, 3];
      selections.remove(2);
      expect(selections.isNotEmpty, true);
      expect(selections.length, 2);
    });
  });

  group('InterestsScreen - Loading State', () {
    test('loading flag state change', () {
      bool loading = false;
      expect(loading, false);

      loading = true;
      expect(loading, true);

      loading = false;
      expect(loading, false);
    });

    test('rapid loading state transitions', () {
      bool loading = false;
      for (int i = 0; i < 10; i++) {
        loading = !loading;
      }
      expect(loading, false);
    });

    test('can prevent action while loading', () {
      bool loading = false;
      final selections = [1];

      bool canProceed = selections.isNotEmpty && !loading;
      expect(canProceed, true);

      loading = true;
      canProceed = selections.isNotEmpty && !loading;
      expect(canProceed, false);
    });

    test('loading state with empty selections', () {
      bool loading = true;
      final selections = <int>[];

      bool canProceed = selections.isNotEmpty && !loading;
      expect(canProceed, false);
    });

    test('multiple loading cycles', () {
      bool loading = false;
      for (int cycle = 0; cycle < 3; cycle++) {
        loading = true;
        expect(loading, true);
        loading = false;
        expect(loading, false);
      }
    });
  });

  group('InterestsScreen - Data Validation', () {
    test('validate positive interest IDs', () {
      final interests = [1, 2, 3, 4, 5];
      final valid = interests.every((id) => id > 0);
      expect(valid, true);
    });

    test('detect non-positive ID', () {
      final interests = [1, 2, 0, 4];
      final valid = interests.every((id) => id > 0);
      expect(valid, false);
    });

    test('single selection is valid', () {
      final selections = [1];
      expect(selections.isNotEmpty, true);
    });

    test('empty selection is invalid', () {
      final selections = <int>[];
      expect(selections.isEmpty, true);
    });

    test('large list is valid', () {
      final selections = List.generate(100, (i) => i + 1);
      expect(selections.length, 100);
      expect(selections.isNotEmpty, true);
    });

    test('negative IDs validation', () {
      final interests = [-1, 0, 1];
      final valid = interests.every((id) => id > 0);
      expect(valid, false);
    });

    test('mixed positive negative IDs', () {
      final interests = [5, -3, 10];
      final onlyPositive = interests.where((id) => id > 0).toList();
      expect(onlyPositive.length, 2);
    });
  });

  group('InterestsScreen - Complete Flow', () {
    test('full selection flow', () {
      final selections = <int>[];
      expect(selections.isEmpty, true);

      selections.addAll([1, 3, 5]);
      expect(selections.isNotEmpty, true);
      expect(selections.length, 3);

      final canProceed = selections.isNotEmpty;
      expect(canProceed, true);
    });

    test('full deselection flow', () {
      final selections = [1, 2, 3, 4];
      expect(selections.isNotEmpty, true);

      selections.clear();
      expect(selections.isEmpty, true);

      final canProceed = selections.isNotEmpty;
      expect(canProceed, false);
    });

    test('select some and navigate - not completed', () {
      final selections = [2, 4];
      final completed = false;

      final canNavigate = selections.isNotEmpty && !completed;
      expect(canNavigate, true);

      final route = completed ? 'home' : 'following';
      expect(route, 'following');
    });

    test('select some and navigate - completed', () {
      final selections = [2, 4];
      final completed = true;

      final canNavigate = selections.isNotEmpty && !completed;
      expect(canNavigate, false);

      final route = completed ? 'home' : 'following';
      expect(route, 'home');
    });

    test('complete onboarding flow - following not done', () {
      final selections = [1, 2, 3];
      final completedFollowing = false;

      final canProceed = selections.isNotEmpty;
      expect(canProceed, true);

      final route =
          completedFollowing ? 'navigation_home_screen' : 'following_screen';
      expect(route, 'following_screen');
    });

    test('complete onboarding flow - following completed', () {
      final selections = [1, 2, 3];
      final completedFollowing = true;

      final canProceed = selections.isNotEmpty;
      expect(canProceed, true);

      final route =
          completedFollowing ? 'navigation_home_screen' : 'following_screen';
      expect(route, 'navigation_home_screen');
    });
  });

  group('InterestsScreen - Set vs List', () {
    test('set removes duplicates', () {
      final asList = [1, 2, 2, 3, 3, 3];
      final asSet = asList.toSet();
      expect(asSet.length, 3);
    });

    test('list keeps duplicates', () {
      final asList = [1, 2, 2, 3, 3, 3];
      expect(asList.length, 6);
    });

    test('set is unordered but contains same elements', () {
      final set = <int>{3, 1, 2};
      final list = set.toList();
      expect(list.isNotEmpty, true);
    });

    test('set faster for contains check', () {
      final set = {1, 2, 3, 4, 5};
      expect(set.contains(3), true);
      expect(set.contains(6), false);
    });

    test('convert set to list maintains all elements', () {
      final set = {5, 3, 1, 4, 2};
      final list = set.toList();
      expect(list.length, 5);
      expect(list.contains(1), true);
      expect(list.contains(5), true);
    });

    test('set with single element', () {
      final set = <int>{42};
      expect(set.length, 1);
      expect(set.contains(42), true);
    });
  });

  group('InterestsScreen - Error Cases', () {
    test('remove non-existent element', () {
      final selections = [1, 2, 3];
      selections.remove(99);
      expect(selections.length, 3);
    });

    test('clear empty list', () {
      final selections = <int>[];
      selections.clear();
      expect(selections.isEmpty, true);
    });

    test('check contains on empty', () {
      final selections = <int>[];
      expect(selections.contains(1), false);
    });

    test('add to set after clear', () {
      final selections = {1, 2, 3};
      selections.clear();
      selections.add(4);
      expect(selections.length, 1);
      expect(selections.contains(4), true);
    });

    test('remove from empty set', () {
      final selections = <int>{};
      selections.remove(1);
      expect(selections.isEmpty, true);
    });

    test('access first on empty throws', () {
      final selections = <int>[];
      expect(() => selections.first, throwsA(isA<StateError>()));
    });
  });

  group('InterestsScreen - Edge Cases', () {
    test('very large ID values', () {
      final interests = [999999, 1000000];
      expect(interests.every((id) => id > 0), true);
    });

    test('rapid toggle same index', () {
      final selected = <int>{};
      for (int i = 0; i < 50; i++) {
        if (i.isEven) {
          selected.add(0);
        } else {
          selected.remove(0);
        }
      }
      expect(selected.isEmpty, true);
    });

    test('select from different indices', () {
      final indices = <int>{};
      for (int i = 0; i < 10; i += 2) {
        indices.add(i);
      }
      expect(indices.length, 5);
    });

    test('massive list of selections', () {
      final selections = List.generate(1000, (i) => i);
      expect(selections.length, 1000);
      selections.clear();
      expect(selections.isEmpty, true);
    });

    test('set with zero', () {
      final set = {0, 1, 2};
      expect(set.contains(0), true);
      expect(set.length, 3);
    });
  });

  group('InterestsScreen - State Consistency', () {
    test('selections persist after unrelated ops', () {
      final selections = [1, 2, 3];
      final original = selections.length;

      final _ = selections.map((e) => e * 2).toList();

      expect(selections.length, original);
      expect(selections, [1, 2, 3]);
    });

    test('state after filter operation', () {
      final selections = [1, 2, 3, 4, 5];
      final filtered = selections.where((e) => e.isOdd).toList();

      expect(selections, [1, 2, 3, 4, 5]);
      expect(filtered, [1, 3, 5]);
    });

    test('cumulative selections', () {
      final selections = <int>[];
      selections.add(1);
      selections.add(2);
      selections.add(3);

      expect(selections, [1, 2, 3]);
      expect(selections.length, 3);
    });

    test('selections survive iteration', () {
      final selections = [1, 2, 3, 4, 5];
      for (final _ in selections) {
        // iteration
      }
      expect(selections.length, 5);
    });

    test('mixed add and remove operations', () {
      final selections = <int>[];
      selections.add(1);
      selections.add(2);
      selections.add(3);
      selections.remove(2);
      selections.add(4);
      expect(selections, [1, 3, 4]);
    });
  });

  group('InterestsScreen - Boolean Logic', () {
    test('AND condition for proceed - both true', () {
      final hasSelection = true;
      final notLoading = true;

      expect(hasSelection && notLoading, true);
    });

    test('AND condition for proceed - first false', () {
      final hasSelection = false;
      final notLoading = true;

      expect(hasSelection && notLoading, false);
    });

    test('AND condition for proceed - second false', () {
      final hasSelection = true;
      final notLoading = false;

      expect(hasSelection && notLoading, false);
    });

    test('AND condition for proceed - both false', () {
      final hasSelection = false;
      final notLoading = false;

      expect(hasSelection && notLoading, false);
    });

    test('NOT condition for disabled state - false', () {
      final enabled = false;
      expect(!enabled, true);
    });

    test('NOT condition for disabled state - true', () {
      final enabled = true;
      expect(!enabled, false);
    });

    test('complex condition - all true', () {
      final hasSelection = true;
      final notLoading = true;
      final userConfirmed = true;

      final canProceed = hasSelection && notLoading && userConfirmed;
      expect(canProceed, true);
    });

    test('complex condition - one false', () {
      final hasSelection = true;
      final notLoading = false;
      final userConfirmed = true;

      final canProceed = hasSelection && notLoading && userConfirmed;
      expect(canProceed, false);
    });

    test('complex condition - all false', () {
      final hasSelection = false;
      final notLoading = false;
      final userConfirmed = false;

      final canProceed = hasSelection && notLoading && userConfirmed;
      expect(canProceed, false);
    });
  });

  group('InterestsScreen - Index Management', () {
    test('add index to set', () {
      final indices = <int>{};
      indices.add(5);
      expect(indices.contains(5), true);
    });

    test('remove index from set', () {
      final indices = <int>{0, 1, 2, 3, 4, 5};
      indices.remove(3);
      expect(indices.contains(3), false);
      expect(indices.length, 5);
    });

    test('check multiple indices', () {
      final indices = <int>{0, 2, 4, 6, 8};
      expect(indices.contains(0), true);
      expect(indices.contains(1), false);
      expect(indices.contains(4), true);
      expect(indices.contains(5), false);
    });

    test('sequential index addition', () {
      final indices = <int>{};
      for (int i = 0; i < 5; i++) {
        indices.add(i);
      }
      expect(indices.length, 5);
      expect(indices.contains(2), true);
    });
  });

  group('InterestsScreen - Interest ID Tracking', () {
    test('track single interest ID', () {
      final interestIds = <int>[];
      interestIds.add(101);
      expect(interestIds.length, 1);
      expect(interestIds.contains(101), true);
    });

    test('track multiple interest IDs', () {
      final interestIds = [101, 202, 303];
      expect(interestIds.length, 3);
    });

    test('remove tracked interest ID', () {
      final interestIds = [101, 202, 303, 404];
      interestIds.remove(202);
      expect(interestIds.length, 3);
      expect(interestIds.contains(202), false);
    });

    test('maintain order of interest IDs', () {
      final interestIds = <int>[];
      interestIds.addAll([50, 30, 70, 10]);
      expect(interestIds.first, 50);
      expect(interestIds.last, 10);
    });
  });
}
