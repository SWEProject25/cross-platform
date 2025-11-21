import 'dart:async';

import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/conversations_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_viewmodel.g.dart';

@riverpod
class ConversationsViewModel extends _$ConversationsViewModel {
  
  late ConversationsRepository _conversationsRepository;
  late MessagesRepository _messagesRepository;

  final Map<int, StreamSubscription<void>?> newMessageSub = {};
  final Map<int, StreamSubscription<bool>?> _typingSub = {};

  @override
  ConversationsState build() {
    _conversationsRepository = ref.read(conversationsRepositoryProvider);
    _messagesRepository = ref.read(messagesRepositoryProvider.notifier);

    ref.onDispose(()=>_onDispose());

    Future.microtask(() async {
      await _loadConversations();
      setUpNewMessageListeners();
    });
    

    return const ConversationsState();
  }

  void _onDispose(){
    newMessageSub.forEach((i,x)=>newMessageSub[i]?.cancel());
    newMessageSub.forEach((i,x)=>newMessageSub[i] = null);
    _typingSub.forEach((i,x)=>_typingSub[i]?.cancel());
    _typingSub.forEach((i,x)=>_typingSub[i] = null);
  }

  Future<void> _loadConversations() async {

    state = state.copyWith(conversations: const AsyncLoading());
    try {
      final data = await _conversationsRepository.fetchConversations();
      state = state.copyWith(conversations: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(conversations: AsyncError(e, st));
    }
  }

  void setUpNewMessageListeners() {
    newMessageSub.forEach((i,x)=>newMessageSub[i]?.cancel());
    newMessageSub.forEach((i,x)=>newMessageSub[i] = null);
    _typingSub.forEach((i,x)=>_typingSub[i]?.cancel());
    _typingSub.forEach((i,x)=>_typingSub[i] = null);

    if(state.conversations.hasValue){
      state.conversations.value!.forEach((x)=>{
      });

      for (var x in state.conversations.value!) {
        newMessageSub[x.id] = _messagesRepository.onMessageRecieved(x.id).listen((_)=>_onNewMessageRecieved(x.id));
        // subscribe to typing events for this conversation
        _typingSub[x.id] = _messagesRepository.onUserTyping(x.id).listen((isTyping) => _onUserTypingChanged(x.id, isTyping));
      }
    }
  }

  void _onUserTypingChanged(int convId, bool isTyping) {
    // update typing map in state
    final typingMap = Map<String, bool>.from(state.isTyping);
    typingMap[convId.toString()] = isTyping;
    state = state.copyWith(isTyping: typingMap);
  }

  void _onNewMessageRecieved(int convId) {
    final message = _messagesRepository.fetchMessage(convId).lastOrNull;
    if (message == null) return;

    final current = state.conversations;
    if (!current.hasValue) return;

    final conversations = current.value!;

    final updated = conversations.map((c) {
      if (c.id == convId) {
        return c.copyWith(
          lastMessage: message.text,
          lastMessageTime: message.time,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(conversations: AsyncData(updated));
  }


  void onQueryChanged(String v) {
    state = state.copyWith(
      searchQuery: v,
      searchQueryError: _validateQuery(v),
    );
    
    updateSerch(v);
  }

  String? _validateQuery(String v) {
    if (v.trim().isEmpty) return 'Query is required';
    if (v.length < 2) return 'Too short';
    return null;
  }

  Future<void> updateSerch(String query) async {
    if(state.searchQueryError != null){
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
      _loadConversations(),
    ]);
  }

}


