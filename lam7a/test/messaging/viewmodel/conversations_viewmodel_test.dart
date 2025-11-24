import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/providers/conversations_provider.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/ui/state/conversations_state.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mock the repository
class MockConversationsRepository extends Mock implements ConversationsRepository {}

void main() {
  group('ConversationsViewModel Tests', () {
    late MockConversationsRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockConversationsRepository();

      // default stub for searches (can be overridden per-test)
      when(() => mockRepository.searchForContacts(any(), any()))
          .thenAnswer((_) async => <Contact>[]);

      container = ProviderContainer(
        overrides: [
          // If `conversationsRepositoryProvider` is a plain Provider/ProviderFamily
          // this will work to inject the mock implementation:
          conversationsRepositoryProvider.overrideWithValue(mockRepository),

          // Provide an empty conversations pagination state to the viewmodel
          conversationsProvider.overrideWithBuild(
            (ref, _) => PaginationState<Conversation>(items: []),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be ConversationsState with AsyncData', () {
      final state = container.read(conversationsViewModelProvider);

      expect(state, isA<ConversationsState>());
      expect(state.conversations, isA<AsyncData>());
    });

    test('onQueryChanged should validate short query', () async {
      final viewmodel = container.read(conversationsViewModelProvider.notifier);

      viewmodel.onQueryChanged('a');
      var state = container.read(conversationsViewModelProvider);

      expect(state.searchQueryError, equals('Too short'));
    });

    test('onQueryChanged with valid query should search', () async {
      // override stub for this test
      when(() => mockRepository.searchForContacts('test query', 1))
          .thenAnswer((_) async => <Contact>[]);

      final viewmodel = container.read(conversationsViewModelProvider.notifier);

      await viewmodel.onQueryChanged('test query');
      var state = container.read(conversationsViewModelProvider);
      
      expect(state.searchQueryError, isNull);
      expect(state.contacts, isA<AsyncData>());
    });

    test('onQueryChanged should handle search errors', () async {
      when(() => mockRepository.searchForContacts('test query', 1))
          .thenThrow(Exception('Search failed'));

      final viewmodel = container.read(conversationsViewModelProvider.notifier);

      await viewmodel.onQueryChanged('test query');

      var state = container.read(conversationsViewModelProvider);
      expect(state.contacts, isA<AsyncError>());
    });
//   test('build() should set conversations to AsyncError when provider has an error', () {
//   final errorState = PaginationState<Conversation>(
//     items: [],
//     error: 'Some error',
//   );

//   var container = ProviderContainer(
//     overrides: [
//       conversationsRepositoryProvider.overrideWithValue(mockRepository),
//       conversationsProvider.overrideWithBuild((ref, _) => errorState),
//     ],
//   );

//   final state = container.listen(conversationsViewModelProvider, (_, __) {}).read();

//   expect(state.conversations, isA<AsyncError>());
//   expect((state.conversations as AsyncError).error, equals('Some error'));
// });
test('_validateQuery returns correct error messages', () {

  // act
  final viewmodel = container.listen(conversationsViewModelProvider.notifier, (_, __) {}).read();
  viewmodel.onQueryChanged(" ");

  // assert
  expect(viewmodel.state.searchQueryError, 'Query is required');
});
test('_validateQuery returns correct error messages', () {

  // act
  final viewmodel = container.listen(conversationsViewModelProvider.notifier, (_, __) {}).read();
  viewmodel.onQueryChanged("a");

  // assert
  expect(viewmodel.state.searchQueryError, 'Too short');
});

test('_validateQuery returns correct error messages', () {

  // act
  final viewmodel = container.listen(conversationsViewModelProvider.notifier, (_, __) {}).read();
  viewmodel.onQueryChanged("ab");

  // assert
  expect(viewmodel.state.searchQueryError, isNull);
});
test('updateSerch returns early when searchQueryError is not null', () async {
  final viewmodel = container.read(conversationsViewModelProvider.notifier);

  // Force an error in state
  viewmodel.state = viewmodel.state.copyWith(searchQueryError: 'Too short');

  await viewmodel.updateSerch('whatever');

  // Should NOT call repository
  verifyNever(() => mockRepository.searchForContacts(any(), any()));
});
test('updateSerch should update contacts with AsyncData on success', () async {
  when(() => mockRepository.searchForContacts('abc', 1))
      .thenAnswer((_) async => <Contact>[
            Contact(id: 1, name: 'Test', handle: 'test')
          ]);

  final vm = container.read(conversationsViewModelProvider.notifier);

  vm.state = vm.state.copyWith(searchQueryError: null);

  await vm.updateSerch('abc');

  final state = container.read(conversationsViewModelProvider);

  expect(state.contacts, isA<AsyncData>());
  expect(state.contacts.value!.length, 1);
});
test('refresh() completes without errors', () async {
  final vm = container.read(conversationsViewModelProvider.notifier);

  await expectLater(vm.refresh(), completes);
});

test('build() sets conversations to AsyncError when provider has an error', () {
  final errorState = PaginationState<Conversation>(
    items: [],
    error: 'Some error',
  );

  final c = ProviderContainer(
    overrides: [
      conversationsRepositoryProvider.overrideWithValue(mockRepository),
      conversationsProvider.overrideWithBuild((ref, _) => errorState),
    ],
  );

  final state = c.listen(conversationsViewModelProvider, (_,__){}).read();

  expect(state.conversations, isA<AsyncError>());
  expect((state.conversations as AsyncError).error, equals('Some error'));
});

test('build() returns AsyncData when conversationsProvider has items', () {
  final itemsState = PaginationState<Conversation>(
    items: [
      Conversation(id: 1, name: "sdfs", userId: 2, username: "dsf"),
    ],
  );

  final c = ProviderContainer(
    overrides: [
      conversationsRepositoryProvider.overrideWithValue(mockRepository),
      conversationsProvider.overrideWithBuild((ref, _) => itemsState),
    ],
  );

  final state = c.read(conversationsViewModelProvider);

  expect(state.conversations, isA<AsyncData<List<Conversation>>>());
  expect(state.conversations.value!.length, 1);
});
test('newMessageSub is empty on initialization', () {
  final vm = container.read(conversationsViewModelProvider.notifier);

  expect(vm.newMessageSub, isEmpty);
});

  });

}