import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/contact_search_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationsRepository extends Mock implements ConversationsRepository {}

void main() {
  final testContacts = [
    Contact(
      id: 1,
      name: 'Test User 1',
      handle: '@testuser1',
    ),
    Contact(
      id: 2,
      name: 'Test User 2',
      handle: '@testuser2',
    ),
  ];

  group('ContactSearchViewModel Tests', () {
    test('initializes and loads search suggestions', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(contactSearchViewModelProvider);
      expect(state.contacts.value, testContacts);
      expect(state.searchQuery, '');
      expect(state.searchQueryError, null);

      verify(() => mockRepository.searchForContacts("", 1)).called(1);

      container.dispose();
    });

    test('loadSearchSuggestion loads contacts successfully', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.loadSearchSuggestion();

      final state = container.read(contactSearchViewModelProvider);
      expect(state.contacts.value, testContacts);

      verify(() => mockRepository.searchForContacts("", 1)).called(greaterThanOrEqualTo(2));

      container.dispose();
    });

    test('onQueryChanged updates query and searches', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.onQueryChanged('test');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.searchQuery, 'test');
      expect(state.searchQueryError, null);
      expect(state.contacts.value, testContacts);

      verify(() => mockRepository.searchForContacts('test', 1)).called(1);

      container.dispose();
    });

    test('onQueryChanged with single character sets validation error', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.onQueryChanged('a');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.searchQuery, 'a');
      expect(state.searchQueryError, 'Too short. Here are some suggested Results:');

      container.dispose();
    });

    test('onQueryChanged with empty string has no error', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.onQueryChanged('');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.searchQuery, '');
      expect(state.searchQueryError, null);

      container.dispose();
    });

    test('updateSerch handles search successfully', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.updateSerch('search query');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.contacts.value, testContacts);

      verify(() => mockRepository.searchForContacts('search query', 1)).called(1);

      container.dispose();
    });

    test('updateSerch handles error', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);
      when(() => mockRepository.searchForContacts('error', 1))
          .thenThrow(Exception('Search failed'));

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.updateSerch('error');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.contacts.hasError, true);
      expect(state.contacts.error.toString(), contains('Search failed'));

      container.dispose();
    });

    test('createConversationId returns conversation id and updates loading state', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);
      when(() => mockRepository.getConversationIdByUserId(1))
          .thenAnswer((_) async => 42);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final result = await viewModel.createConversationId(1);

      expect(result, 42);

      final state = container.read(contactSearchViewModelProvider);
      expect(state.loadingConversationId, false);

      verify(() => mockRepository.getConversationIdByUserId(1)).called(1);

      container.dispose();
    });

    test('createConversationId sets loading state correctly', () async {
      final mockRepository = MockConversationsRepository();
      bool loadingStateDuringCall = false;

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);
      when(() => mockRepository.getConversationIdByUserId(1))
          .thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 50));
        return 42;
      });

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final futureResult = viewModel.createConversationId(1);
      await Future.delayed(const Duration(milliseconds: 10));

      loadingStateDuringCall = container.read(contactSearchViewModelProvider).loadingConversationId;

      await futureResult;

      expect(loadingStateDuringCall, true);
      expect(container.read(contactSearchViewModelProvider).loadingConversationId, false);

      container.dispose();
    });

    test('refresh reloads search suggestions', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts("", 1))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.refresh();

      final state = container.read(contactSearchViewModelProvider);
      expect(state.contacts.value, testContacts);

      verify(() => mockRepository.searchForContacts("", 1)).called(greaterThanOrEqualTo(2));

      container.dispose();
    });

    test('onQueryChanged with multi-character string has no error', () async {
      final mockRepository = MockConversationsRepository();

      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => testContacts);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final viewModel = container.listen(contactSearchViewModelProvider.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.onQueryChanged('ab');

      final state = container.read(contactSearchViewModelProvider);
      expect(state.searchQuery, 'ab');
      expect(state.searchQueryError, null);

      container.dispose();
    });
  });
}
