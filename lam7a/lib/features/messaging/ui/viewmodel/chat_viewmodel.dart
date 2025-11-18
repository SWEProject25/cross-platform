import 'dart:async';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {  
  final Logger _logger = getLogger(ChatViewModel);
  late int? _conversationId;
  late int _userId;

  late ConversationsRepository _conversationsRepository;
  late MessagesRepository _messagesRepository;
  late AuthState _authState;

  StreamSubscription<void>? _newMessagesSub;
  StreamSubscription<bool>? _userTypingSub;
  Timer? _typingTimer;

  @override
  ChatState build({required int userId, int? conversationId}) {
    _userId = userId;
    _conversationId = conversationId;

    ref.onDispose(_onDispose);

    _conversationsRepository = ref.read(conversationsRepositoryProvider);
    _messagesRepository = ref.read(messagesRepositoryProvider.notifier);
    _authState = ref.watch(authenticationProvider);

    Future.microtask(() async {
      await _getConvId();

      _newMessagesSub = _messagesRepository.onMessageRecieved(state.conversationId).listen((_)=>_onNewMessagesArrive());
      _userTypingSub = _messagesRepository.onUserTyping(state.conversationId).listen(((isTyping)=> _onOtherTyping(isTyping)));
      _messagesRepository.joinConversation(state.conversationId);
      _loadContact();
      _loadMessages();

      await loadMoreMessages();

    });
  

    return ChatState();
  }

  void _onDispose() {
    _logger.d("Disposing ChatViewModel");

    _newMessagesSub?.cancel();
    _newMessagesSub = null;

    _userTypingSub?.cancel();
    _userTypingSub = null;
    _typingTimer?.cancel();
    _typingTimer = null;
  }


  Future<void> _getConvId() async{
    if(_conversationId == null){
      _logger.d("Getting ConvId from UserId {$_userId}");
      int convId = await _conversationsRepository.getConversationIdByUserId(_userId);

      if(convId == -1){
        _logger.e("UserId {$_userId} conversion got {$convId}");
        return;
      }

      _logger.d("Converted UserId to {$convId}");
      state = state.copyWith(conversationId: convId);
    }else{
      state = state.copyWith(conversationId: _conversationId ?? -1);
    }
  }

  Future<void> _loadContact() async {

    state = state.copyWith(contact: const AsyncLoading());
    try {
      final contact = await _conversationsRepository.getContactByUserId(_userId);
      state = state.copyWith(contact: AsyncData(contact));
    } catch (e,st) {
      state = state.copyWith(contact: AsyncError(e,st));
      _logger.e(e);
    }
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final data = await _messagesRepository.fetchMessage(state.conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  void _onNewMessagesArrive(){
    _refreshMessages();
  }

  void _onOtherTyping (bool isTyping) {
    state = state.copyWith(isTyping: isTyping);
  }

  void _refreshMessages() {
    try {
      final data = _messagesRepository.fetchMessage(state.conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  void updateDraftMessage(String draft){
    state = state.copyWith(draftMessage: draft);

    _messagesRepository.updateTypingStatus(state.conversationId, true);
    if (_typingTimer?.isActive ?? false) {
      _typingTimer!.cancel();
    }

    _typingTimer = Timer(const Duration(seconds: 3), () {
      _messagesRepository.updateTypingStatus(state.conversationId, false);
      _typingTimer = null;
    });
  }

  Future<void> sendMessage() async {
    _messagesRepository.sendMessage(_authState.user!.id!, state.conversationId, state.draftMessage.trim());
  
    state = state.copyWith(draftMessage: "");
  }


  Future<void> loadMoreMessages() async {
    if(state.loadingMoreMessages) return;
    if(!state.hasMoreMessages){
      _logger.d("Done Loading all messages");
      return;
    }
    state = state.copyWith(loadingMoreMessages: true);

    var hasMore = await _messagesRepository.loadMessageHistory(state.conversationId);

    state = state.copyWith(loadingMoreMessages: false, hasMoreMessages: hasMore);
  }

  Future<void> refresh() async {
    await  _loadMessages();
  }

}