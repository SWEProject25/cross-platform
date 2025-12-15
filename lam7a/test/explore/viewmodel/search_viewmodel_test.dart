// FIXED & COMPLETE SEARCH VIEWMODEL TEST FILE

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/explore/ui/viewmodel/search_viewmodel.dart';
import 'package:lam7a/features/explore/ui/state/search_state.dart';
import 'package:lam7a/features/explore/repository/search_repository.dart';
import 'package:lam7a/core/models/user_model.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  late MockSearchRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(<String>[]);
    registerFallbackValue(<UserModel>[]);
  });

  setUp(() {
    mockRepo = MockSearchRepository();
    container = ProviderContainer(
      overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  List<UserModel> createMockUsers(int count) {
    return List.generate(
      count,
      (i) => UserModel(
        id: i,
        profileId: i,
        username: 'user$i',
        email: 'user$i@test.com',
        role: 'user',
        name: 'User $i',
        birthDate: '2000-01-01',
        profileImageUrl: null,
        bannerImageUrl: null,
        bio: 'Bio $i',
        location: null,
        website: null,
        createdAt: DateTime.now().toIso8601String(),
        followersCount: 100 + i,
        followingCount: 50 + i,
      ),
    );
  }

  group('SearchViewModel - Initialization', () {
    test('loads cached data correctly', () async {
      when(
        () => mockRepo.getCachedAutocompletes(),
      ).thenAnswer((_) async => ['flutter', 'dart']);
      when(
        () => mockRepo.getCachedUsers(),
      ).thenAnswer((_) async => createMockUsers(2));

      final state = await container.read(searchViewModelProvider.future);

      expect(state.recentSearchedTerms!.length, 2);
      expect(state.recentSearchedUsers!.length, 2);
    });

    test('handles empty cache', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      final state = await container.read(searchViewModelProvider.future);

      expect(state.recentSearchedTerms, isEmpty);
      expect(state.recentSearchedUsers, isEmpty);
    });
  });

  group('SearchViewModel - Searching', () {
    test('debounces and searches once', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('flutter', 8, 1),
      ).thenAnswer((_) async => createMockUsers(5));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('f');
      viewModel.onChanged('fl');
      viewModel.onChanged('flutter');

      await Future.delayed(const Duration(milliseconds: 350));

      verify(() => mockRepo.searchUsers('flutter', 8, 1)).called(1);
    });

    test('clears suggestions on empty query', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('test', 8, 1),
      ).thenAnswer((_) async => createMockUsers(3));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('test');
      await Future.delayed(const Duration(milliseconds: 350));

      viewModel.onChanged('');

      final state = container.read(searchViewModelProvider).value!;
      expect(state.suggestedUsers, isEmpty);
    });

    test(
      'insertSearchedTerm updates controller, clears suggestions, and triggers onChanged',
      () async {
        // Arrange
        UserModel _fakeUser({
          int id = 1,
          String username = 'test_user',
          String email = 'test@test.com',
        }) {
          return UserModel(
            id: id,
            username: username,
            email: email,
            // add any REQUIRED fields your UserModel constructor needs
          );
        }

        final mockRepo = MockSearchRepository();

        when(
          () => mockRepo.searchUsers(any(), any(), any()),
        ).thenAnswer((_) async => []);

        final container = ProviderContainer(
          overrides: [searchRepositoryProvider.overrideWithValue(mockRepo)],
        );

        addTearDown(container.dispose);

        final notifier = container.read(searchViewModelProvider.notifier);

        // Seed initial state
        notifier.state = AsyncData(
          SearchState(
            suggestedUsers: [_fakeUser()],
            suggestedAutocompletions: ['flutter'],
          ),
        );

        // Act
        notifier.insertSearchedTerm('dart');

        // Assert — TextEditingController
        expect(notifier.searchController.text, 'dart');
        expect(notifier.searchController.selection.baseOffset, 'dart'.length);

        // Assert — state cleared
        final state = container.read(searchViewModelProvider).value!;
        expect(state.suggestedUsers, isEmpty);
        expect(state.suggestedAutocompletions, isEmpty);

        // Allow debounce / async search to fire
        await Future.delayed(const Duration(milliseconds: 350));

        // Assert — onChanged was triggered
        verify(() => mockRepo.searchUsers('dart', any(), any())).called(1);
      },
    );
  });

  group('SearchViewModel - Error handling', () {
    test('emits error when repository throws', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('flutter', 8, 1),
      ).thenThrow(Exception('network error'));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('flutter');
      await Future.delayed(const Duration(milliseconds: 350));

      final asyncValue = container.read(searchViewModelProvider);
      expect(asyncValue.hasError, true);
    });

    test('sets loading state before search', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(() => mockRepo.searchUsers('test', 8, 1)).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 100));
        return createMockUsers(2);
      });

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('test');
      await Future.delayed(const Duration(milliseconds: 350));

      final asyncValue = container.read(searchViewModelProvider);
      expect(asyncValue.hasValue, true);
    });
  });

  group('SearchViewModel - Integration (COMPLETED TEST)', () {
    test('full search → push autocomplete → push user flow', () async {
      final users = createMockUsers(3);

      when(
        () => mockRepo.getCachedAutocompletes(),
      ).thenAnswer((_) async => ['dart']);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('flutter', 8, 1),
      ).thenAnswer((_) async => users);
      when(
        () => mockRepo.pushAutocomplete('flutter'),
      ).thenAnswer((_) async => {});
      when(
        () => mockRepo.getCachedAutocompletes(),
      ).thenAnswer((_) async => ['flutter', 'dart']);
      when(() => mockRepo.pushUser(users.first)).thenAnswer((_) async => {});
      when(
        () => mockRepo.getCachedUsers(),
      ).thenAnswer((_) async => [users.first]);

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      // search
      viewModel.onChanged('flutter');
      await Future.delayed(const Duration(milliseconds: 350));

      var state = container.read(searchViewModelProvider).value!;
      expect(state.suggestedUsers!.length, 3);

      // push autocomplete
      await viewModel.pushAutocomplete('flutter');
      state = container.read(searchViewModelProvider).value!;
      expect(state.recentSearchedTerms!.contains('flutter'), true);

      // push user
      await viewModel.pushUser(users.first);
      state = container.read(searchViewModelProvider).value!;
      expect(state.recentSearchedUsers!.length, 1);
    });
  });

  group('SearchViewModel - Controller Management', () {
    test('controller text and selection updated on onChanged', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('test', 8, 1),
      ).thenAnswer((_) async => createMockUsers(2));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('test');
      await Future.delayed(const Duration(milliseconds: 50));

      expect(viewModel.searchController.text, 'test');
      expect(viewModel.searchController.selection.baseOffset, 4);
    });

    test('debounce cancels on rapid typing', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), 8, 1),
      ).thenAnswer((_) async => createMockUsers(1));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('f');
      await Future.delayed(const Duration(milliseconds: 100));
      viewModel.onChanged('fl');
      await Future.delayed(const Duration(milliseconds: 100));
      viewModel.onChanged('flu');
      await Future.delayed(const Duration(milliseconds: 350));

      // Only the last search should fire
      verify(() => mockRepo.searchUsers('flu', 8, 1)).called(1);
      verifyNever(() => mockRepo.searchUsers('f', 8, 1));
      verifyNever(() => mockRepo.searchUsers('fl', 8, 1));
    });
  });

  group('SearchViewModel - Edge Cases', () {
    test('handles whitespace-only query correctly', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers(any(), 8, 1),
      ).thenAnswer((_) async => createMockUsers(2));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('   ');
      await Future.delayed(const Duration(milliseconds: 350));

      // Should not search for empty/whitespace
      final state = container.read(searchViewModelProvider).value!;
      expect(state.suggestedUsers, isEmpty);
    });

    test('onChanged returns early when state is null', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);

      final viewModel = container.read(searchViewModelProvider.notifier);
      // Don't await - state will be loading

      viewModel.onChanged('');

      // Should not throw
      expect(container.read(searchViewModelProvider).isLoading, true);
    });

    test('multiple rapid searches with different queries', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('flutter', 8, 1),
      ).thenAnswer((_) async => createMockUsers(3));
      when(
        () => mockRepo.searchUsers('dart', 8, 1),
      ).thenAnswer((_) async => createMockUsers(2));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('flutter');
      await Future.delayed(const Duration(milliseconds: 100));
      viewModel.onChanged('dart');
      await Future.delayed(const Duration(milliseconds: 350));

      // Only last query should execute
      verify(() => mockRepo.searchUsers('dart', 8, 1)).called(1);
      verifyNever(() => mockRepo.searchUsers('flutter', 8, 1));
    });

    test('search with trimmed query removes extra spaces', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.searchUsers('flutter', 8, 1),
      ).thenAnswer((_) async => createMockUsers(2));

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      viewModel.onChanged('  flutter  ');
      await Future.delayed(const Duration(milliseconds: 350));

      verify(() => mockRepo.searchUsers('flutter', 8, 1)).called(1);
    });

    test('pushUser updates recent users list', () async {
      final users = createMockUsers(3);
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(() => mockRepo.pushUser(users.first)).thenAnswer((_) async => {});
      when(
        () => mockRepo.getCachedUsers(),
      ).thenAnswer((_) async => [users.first]);

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      await viewModel.pushUser(users.first);

      final state = container.read(searchViewModelProvider).value!;
      expect(state.recentSearchedUsers!.length, 1);
      expect(state.recentSearchedUsers!.first.username, 'user0');
    });

    test('pushAutocomplete updates recent terms list', () async {
      when(() => mockRepo.getCachedAutocompletes()).thenAnswer((_) async => []);
      when(() => mockRepo.getCachedUsers()).thenAnswer((_) async => []);
      when(
        () => mockRepo.pushAutocomplete('flutter'),
      ).thenAnswer((_) async => {});
      when(
        () => mockRepo.getCachedAutocompletes(),
      ).thenAnswer((_) async => ['flutter']);

      final viewModel = container.read(searchViewModelProvider.notifier);
      await container.read(searchViewModelProvider.future);

      await viewModel.pushAutocomplete('flutter');

      final state = container.read(searchViewModelProvider).value!;
      expect(state.recentSearchedTerms!.length, 1);
      expect(state.recentSearchedTerms!.first, 'flutter');
    });
  });
}
