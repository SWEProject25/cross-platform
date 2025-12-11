import 'dart:async';
import 'dart:math';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/errors/blocked_user_error.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_viewmodel.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {  
  final Logger _logger = getLogger(ChatViewModel);
  late int _conversationId;
  late int _userId;

  late ConversationsRepository _conversationsRepository;
  late MessagesRepository _messagesRepository;
  late AuthState _authState;
  StreamSubscription<void>? _newMessagesSub;
  StreamSubscription<bool>? _userTypingSub;
  Timer? _typingTimer;
  Timer? _othertypingTimer;
  bool _disposed = false;

  @override
  ChatState build({required int userId, required int conversationId}) {
    _userId = userId;
    _conversationId = conversationId;

    ref.onDispose(_onDispose);

    _conversationsRepository = ref.read(conversationsRepositoryProvider);
    _messagesRepository = ref.read(messagesRepositoryProvider);
    _authState = ref.watch(authenticationProvider);

    if(_authState.user == null){
      throw Exception("User not authenticated");
    }

    _newMessagesSub = _messagesRepository.onMessageRecieved(_conversationId).listen((_)=>_onNewMessagesArrive());
    _userTypingSub = _messagesRepository.onUserTyping(_conversationId).listen(((isTyping)=> _onOtherTyping(isTyping)));
    
    _messagesRepository.joinConversation(_conversationId);
    _messagesRepository.sendMarkAsSeen(_conversationId);

    Future.microtask(() async {

      ref.read(conversationViewmodelProvider(_conversationId).notifier).markConversationAsSeen();
      _loadContact();
      _prepareConversation();
      _loadMessages();

      await requestInitMessages();

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

    _disposed = true;
    Future.microtask(() {
      _messagesRepository.leaveConversation(_conversationId);
    });

  }

  Future<void> _prepareConversation() async {
    var conversationViewmodel = ref.read(conversationViewmodelProvider(_conversationId).notifier);
    if (conversationViewmodel.state.conversation == null) {
      var conv = await _conversationsRepository.getConversationById(_conversationId);
      conversationViewmodel.setConversation(conv);
      state = state.copyWith(conversation: AsyncData(conv));
    }else{
      state = state.copyWith(conversation: AsyncData(conversationViewmodel.state.conversation!));
    }
  }

  Future<void> _loadContact() async {

    state = state.copyWith(contact: const AsyncLoading());
    try {
      final contact = await _conversationsRepository.getContactByUserId(_userId);

      if(_disposed) return;
        state = state.copyWith(contact: AsyncData(contact));
    } catch (e,st) {
      state = state.copyWith(contact: AsyncError(e,st));
      _logger.e(e);
    }
  }

  Future<void> _loadMessages() async {
    state = state.copyWith(messages: const AsyncLoading());
    try {
      final data = await _messagesRepository.fetchMessage(_conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  void _onNewMessagesArrive(){
    _refreshMessages();
    _messagesRepository.sendMarkAsSeen(_conversationId);
    ref.read(conversationViewmodelProvider(_conversationId).notifier).markConversationAsSeen();
  }

  void _onOtherTyping (bool isTyping) {
    if(state.conversation.value?.isBlocked ?? false) return;
    
    state = state.copyWith(isTyping: isTyping);

    if (isTyping) {
      if (_othertypingTimer?.isActive ?? false) {
        _othertypingTimer!.cancel();
        _othertypingTimer = null;
      }

      _othertypingTimer = Timer(const Duration(seconds: 5), () {
        state = state.copyWith(isTyping: false);
        _othertypingTimer = null;
      });
    } else {
      _othertypingTimer?.cancel();
      _othertypingTimer = null;
    }
  }

  Future<void> _refreshMessages() async {
    try {
      final data = await _messagesRepository.fetchMessage(_conversationId);
      state = state.copyWith(messages: AsyncData(data));
    } catch (e, st) {
      state = state.copyWith(messages: AsyncError(e, st));
    }
  }

  void updateDraftMessage(String draft){
    state = state.copyWith(draftMessage: draft.substring(0, min(draft.length, 1000)));

    _messagesRepository.updateTypingStatus(_conversationId, true);
    if (_typingTimer?.isActive ?? false) {
      _typingTimer!.cancel();
    }

    _typingTimer = Timer(const Duration(seconds: 3), () {
      _messagesRepository.updateTypingStatus(_conversationId, false);
      _typingTimer = null;
    });
  }

  Future<void> sendMessage() async {
    try {
      _messagesRepository.updateTypingStatus(_conversationId, false);
      state = state.copyWith(draftMessage: "");
      await _messagesRepository.sendMessage(_authState.user!.id!, _conversationId, state.draftMessage.trim());
    } on BlockedUserError catch (e) {
      _logger.w("Cannot send message, user is blocked: $e");
      ref.read(conversationViewmodelProvider(_conversationId).notifier).setConversationBlocked(true);
      state = state.copyWith(
        conversation: AsyncData(
          state.conversation.value!.copyWith(isBlocked: true),
        ),
      );
    } catch (e) {
      _logger.e("Error sending message: $e");
    }
    
  }

  Future<void> requestInitMessages() async {
    if(state.loadingMoreMessages) return;

    state = state.copyWith(loadingMoreMessages: true);

    var hasMore = await _messagesRepository.loadInitMessage(_conversationId);

    if(_disposed) return;
    state = state.copyWith(loadingMoreMessages: false, hasMoreMessages: hasMore);
  }


  Future<void> loadMoreMessages() async {
    if(state.loadingMoreMessages) return;
    if(!state.hasMoreMessages){
      _logger.d("Done Loading all messages");
      return;
    }
    state = state.copyWith(loadingMoreMessages: true);

    var hasMore = await _messagesRepository.loadMessageHistory(_conversationId);

    if(_disposed) return;
    state = state.copyWith(loadingMoreMessages: false, hasMoreMessages: hasMore);
  }

  Future<void> refresh() async {
    await  _loadMessages();
  }

}