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

    Future.microtask(() async {
      loadSearchSuggestion();
    });

    return ConversationsState(conversations: asyncConversation);
  }

  void loadSearchSuggestion() async {
    state = state.copyWith(contacts: AsyncLoading());
    
    var contacts = await _conversationsRepository.searchForContactsExtended("", 1);
    state = state.copyWith(contacts: AsyncData(contacts));

  }

  Future<void> onQueryChanged(String v) async {
    state = state.copyWith(searchQuery: v, searchQueryError: _validateQuery(v));

    await updateSerch(v);
  }

  String? _validateQuery(String v) {
    // if (v.trim().isEmpty) return 'Query is required';
    if (v.length == 1) return 'Too short. Here are some suggested Results:';
    return null;
  }

  Future<void> updateSerch(String query) async {
    // if (state.searchQueryError != null) {
    //   return;
    // }

    try {
      var data = await _conversationsRepository.searchForContactsExtended(query, 1);
      state = state.copyWith(contacts: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(contacts: AsyncError(e, st));
    }
  }

  Future<int> createConversationId(int userId) async {
    state = state.copyWith(loadingConversationId: true);
    var res = await _conversationsRepository.getConversationIdByUserId(userId);
    state = state.copyWith(loadingConversationId: false);

    return res;
  }

  Future<void> refresh() async {
    await Future.wait([
      // _loadConversations(),
    ]);
  }
}
