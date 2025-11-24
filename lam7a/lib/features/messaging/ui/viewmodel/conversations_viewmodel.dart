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
    var conversations = ref.watch(conversationsProvider);

    AsyncValue<List<Conversation>> asyncConversation = const AsyncLoading();
    if (conversations.error != null) {
      asyncConversation = AsyncError(
          conversations.error ?? 'Unknown',
          StackTrace.current,
        );
    } else {
      asyncConversation = AsyncData(conversations.items);
    }

    return ConversationsState(conversations: asyncConversation);
  }

  Future<void> onQueryChanged(String v) async {
    state = state.copyWith(searchQuery: v, searchQueryError: _validateQuery(v));

    await updateSerch(v);
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
