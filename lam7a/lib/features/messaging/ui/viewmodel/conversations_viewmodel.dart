import 'dart:async';

import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/providers/conversations_provider.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/ui/state/conversations_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_viewmodel.g.dart';

@riverpod
class ConversationsViewModel extends _$ConversationsViewModel {
  late ConversationsRepository _conversationsRepository;
  // will listen to pagination provider updates instead of reading synchronously
  final Map<int, StreamSubscription<void>?> newMessageSub = {};

  @override
  ConversationsState build() {
    _conversationsRepository = ref.read(conversationsRepositoryProvider);

    ref.listen<PaginationState<Conversation>>(conversationsProvider, (
      previous,
      next,
    ) {
      if (next.isLoading) {
        state = state.copyWith(conversations: const AsyncLoading());
      } else if (next.error != null) {
        state = state.copyWith(
          conversations: AsyncError(
            next.error ?? 'Unknown',
            StackTrace.current,
          ),
        );
      } else {
        state = state.copyWith(conversations: AsyncData(next.items));
      }
    }, fireImmediately: false);

    Future.microtask(() {
      final current = ref.read(conversationsProvider);
      if (current.items.isNotEmpty ||
          current.isLoading ||
          current.error != null) {
        if (current.isLoading) {
          state = state.copyWith(conversations: const AsyncLoading());
        } else if (current.error != null) {
          state = state.copyWith(
            conversations: AsyncError(current.error!, StackTrace.current),
          );
        } else {
          state = state.copyWith(conversations: AsyncData(current.items));
        }
      }
    });

    return const ConversationsState();
  }

  // Future<void> _loadConversations() async {

  //   state = state.copyWith(conversations: const AsyncLoading());
  //   try {
  //     final data = await _conversationsRepository.fetchConversations();
  //     state = state.copyWith(conversations: AsyncData(data));
  //   } catch (e, st) {
  //     state = state.copyWith(conversations: AsyncError(e, st));
  //   }
  // }

  void onQueryChanged(String v) {
    state = state.copyWith(searchQuery: v, searchQueryError: _validateQuery(v));

    updateSerch(v);
  }

  String? _validateQuery(String v) {
    if (v.trim().isEmpty) return 'Query is required';
    if (v.length < 2) return 'Too short';
    return null;
  }

  Future<void> updateSerch(String query) async {
    if (state.searchQueryError != null) {
      return;
    }

    try {
      var data = await _conversationsRepository.searchForContacts(query, 1);
      state = state.copyWith(contacts: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(contacts: AsyncError(e, st));
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      // _loadConversations(),
    ]);
  }
}
