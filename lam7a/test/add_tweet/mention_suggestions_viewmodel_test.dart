
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/mention_suggestions_viewmodel.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationsRepository extends Mock
    implements ConversationsRepository {}

void main() {
  late MockConversationsRepository mockRepository;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockConversationsRepository();
    container = ProviderContainer(
      overrides: [
        conversationsRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  MentionSuggestionsViewModel getViewModel() {
    return container.read(mentionSuggestionsViewModelProvider.notifier);
  }

  MentionSuggestionsState getState() {
    return container.read(mentionSuggestionsViewModelProvider);
  }

  group('MentionSuggestionsViewModel Tests', () {
    test('initial state is correct', () {
      final state = getState();
      expect(state.query, '');
      expect(state.isOpen, false);
      expect(state.isLoading, false);
      expect(state.suggestions, isEmpty);
    });

    test('updateQuery updates query immediately', () async {
      final viewModel = getViewModel();
      await viewModel.updateQuery('test');
      
      final state = getState();
      expect(state.query, 'test');
    });

    test('updateQuery with empty string clears state', () async {
      final viewModel = getViewModel();
      
      // First set some state
      await viewModel.updateQuery('test');
      
      // Then clear it
      await viewModel.updateQuery('');
      
      final state = getState();
      expect(state.query, '');
      expect(state.isOpen, false);
      expect(state.isLoading, false);
      expect(state.suggestions, isEmpty);
    });

    test('updateQuery with non-empty string opens panel with suggestions',
        () async {
      final viewModel = getViewModel();

      final contacts = [
        Contact(id: 1, handle: '@alice', name: 'Alice'),
        Contact(id: 2, handle: '@bob', name: 'Bob'),
      ];

      when(() => mockRepository.searchForContacts('al', 1, 5))
          .thenAnswer((_) async => contacts);

      await viewModel.updateQuery('al');

      // Wait for debounce timer (250 ms) to fire
      await Future.delayed(const Duration(milliseconds: 300));

      final state = getState();
      expect(state.query, 'al');
      expect(state.isLoading, false);
      expect(state.isOpen, true);
      expect(state.suggestions, contacts);
    });

    test('updateQuery handles repository error and closes panel', () async {
      final viewModel = getViewModel();

      when(() => mockRepository.searchForContacts('err', 1, 5))
          .thenThrow(Exception('network')); 

      await viewModel.updateQuery('err');

      await Future.delayed(const Duration(milliseconds: 300));

      final state = getState();
      expect(state.query, 'err');
      expect(state.isLoading, false);
      expect(state.isOpen, false);
      expect(state.suggestions, isEmpty);
    });
  });
}
