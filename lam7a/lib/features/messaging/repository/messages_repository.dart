import 'dart:async';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_repository.g.dart';

@Riverpod(keepAlive: true)
class MessagesRepository extends _$MessagesRepository {
  final Logger _logger = getLogger(MessagesRepository);
  
  late MessagesStore _cache;
  late MessagesSocketService _socket;
  late DMsApiService _apiService;
  late AuthState _authState;

  final Map<int, StreamController<void>> _notifier = {};
  StreamSubscription<MessageDto>? _incomingSub;
  StreamSubscription<MessageDto>? _incomingNotifSub;
  StreamSubscription<TypingEventDto>? _typingSub;
  StreamSubscription<TypingEventDto>? _stopTypingSub;

  final Map<int, StreamController<bool>> _typingNotifier = {};

  @override
  void build() {
    _cache = ref.read(messagesStoreProvider);
    _apiService = ref.read(dmsApiServiceProvider);
    _socket = ref.read(messagesSocketServiceProvider);
    _authState = ref.watch(authenticationProvider);

    _logger.w("Create MessagesRepository");
    _incomingSub = _socket.incomingMessages.listen(_onReceivedMessage);
    _incomingNotifSub = _socket.incomingMessagesNotifications.listen(_onReceivedMessage);
    _typingSub = _socket.userTyping.listen(_onUserTypingEvent);
    _stopTypingSub = _socket.userStoppedTyping.listen(_onUserStoppedTypingEvent);

    ref.onDispose(() {
      _logger.i("Disposing MessagesRepository");
      _incomingSub?.cancel();
      _incomingNotifSub?.cancel();

      // close and clear all controllers
      for (final ctrl in _notifier.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
      _notifier.clear();
    });

  }

  void _onReceivedMessage(MessageDto data) {
    var message = ChatMessage(
      conversationId: data.conversationId,
      id: data.id ?? -1,
      text: data.text ?? "(Missing Message)",
      time: data.createdAt!,
      isMine:
          _authState.isAuthenticated && data.senderId == _authState.user!.id,
    );

    _cache.addMessage(message.conversationId ?? -1, message);

    _getNotifier(message.conversationId ?? -1).add(null);
  }

  void _onUserTypingEvent(TypingEventDto event) {
    _logger.i("User ${event.userId} is typing in conversation ${event.conversationId}");
    _getTypingNotifier(event.conversationId).add(true);
  }
  
  void _onUserStoppedTypingEvent(TypingEventDto event) {
    _logger.i("User ${event.userId} stopped typing in conversation ${event.conversationId}");
    _getTypingNotifier(event.conversationId).add(false);
  }

  Stream<void> onMessageRecieved(int conversationId) => _getNotifier(conversationId).stream;
  StreamController<void> _getNotifier(int conversationId) => _notifier.putIfAbsent(conversationId, ()=>StreamController<void>.broadcast());

  Stream<bool> onUserTyping(int conversationId) => _getTypingNotifier(conversationId).stream;
  StreamController<bool> _getTypingNotifier(int conversationId) => _typingNotifier.putIfAbsent(conversationId, ()=>StreamController<bool>.broadcast());

  List<ChatMessage> fetchMessage(int chatId) {
    return _cache.getMessages(chatId);
  }

  void updateTypingStatus(int conversationId, bool isTyping) {
    if(isTyping){
      _socket.sendTypingEvent(TypingRequest(conversationId: conversationId));
    } else {
      _socket.sendStopTypingEvent(TypingRequest(conversationId: conversationId));
    }
  }

  void sendMessage(int senderId, int conversationId, String message) {
    _logger.i("Sending message to conversation $conversationId: $message");

    CreateMessageRequest request = CreateMessageRequest(
      conversationId: conversationId,
      senderId: senderId,
      text: message,
    );

    _socket.sendMessage(request);
  }

  Future<bool> loadMessageHistory(int conversationId) async{

    int? lastMessageId = _cache.getMessages(conversationId).firstOrNull?.id;
    _logger.i("Loading More Messages last message id is {$lastMessageId}");

    var messagesDto = await _apiService.getMessageHistory(conversationId, lastMessageId);

    var messages = messagesDto.data.map((x)=> ChatMessage.fromDto(x, currentUserId: _authState.user!.id!)).toList();
  
    _cache.addMessages(conversationId, messages);
    _getNotifier(conversationId).add(null);

    return messagesDto.metadata.hasMore;
  }

  void joinConversation(int conversationId) {
    _socket.joinConversation(conversationId);
  }

  void leaveConversation(int conversationId) {
    _socket.leaveConversation(conversationId);
  }
}
