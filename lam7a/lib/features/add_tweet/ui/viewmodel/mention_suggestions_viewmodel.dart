import 'dart:async';

import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mention_suggestions_viewmodel.g.dart';

class MentionSuggestionsState {
  final String query;
  final bool isOpen;
  final bool isLoading;
  final List<Contact> suggestions;

  const MentionSuggestionsState({
    this.query = '',
    this.isOpen = false,
    this.isLoading = false,
    this.suggestions = const [],
  });

  MentionSuggestionsState copyWith({
    String? query,
    bool? isOpen,
    bool? isLoading,
    List<Contact>? suggestions,
  }) {
    return MentionSuggestionsState(
      query: query ?? this.query,
      isOpen: isOpen ?? this.isOpen,
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}

@riverpod
class MentionSuggestionsViewModel extends _$MentionSuggestionsViewModel {
  late ConversationsRepository _conversationsRepository;
  Timer? _debounce;

  @override
  MentionSuggestionsState build() {
    _conversationsRepository = ref.read(conversationsRepositoryProvider);

    ref.onDispose(() {
      _debounce?.cancel();
      _debounce = null;
    });

    return const MentionSuggestionsState();
  }

  void clear() {
    _debounce?.cancel();
    state = const MentionSuggestionsState();
  }

  Future<void> updateQuery(String query) async {
    state = state.copyWith(query: query);

    _debounce?.cancel();

    if (query.isEmpty) {
      state = state.copyWith(
        isOpen: false,
        isLoading: false,
        suggestions: const [],
      );
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 250), () async {
      state = state.copyWith(isLoading: true, isOpen: true);

      try {
        final results = await _conversationsRepository.searchForContacts(
          query,
          1,
          5,
        );

        state = state.copyWith(
          isLoading: false,
          isOpen: results.isNotEmpty,
          suggestions: results,
        );
      } catch (_) {
        state = state.copyWith(
          isLoading: false,
          isOpen: false,
          suggestions: const [],
        );
      }
    });
  }
}
