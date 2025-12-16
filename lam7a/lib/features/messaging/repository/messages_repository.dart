import 'dart:async';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/errors/blocked_user_error.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_repository.g.dart';

@Riverpod(keepAlive: true)
MessagesRepository messagesRepository(Ref ref) {
  var repo = MessagesRepository(
    ref.read(messagesStoreProvider),
    ref.read(messagesSocketServiceProvider),
    ref.read(dmsApiServiceProvider),
    ref.watch(authenticationProvider),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
}

class MessagesRepository {
  final Logger _logger = getLogger(MessagesRepository);

  final MessagesStore _cache;
  final MessagesSocketService _socket;
  final DMsApiService _apiService;
  final AuthState _authState;

  final Map<int, StreamController<void>> _notifier = {};
  StreamSubscription<MessageDto>? _incomingSub;
  StreamSubscription<MessageDto>? _incomingNotifSub;
  StreamSubscription<TypingEventDto>? _typingSub;
  StreamSubscription<TypingEventDto>? _stopTypingSub;
  StreamSubscription<void>? _reconnectedSub;
  StreamSubscription<MessagesSeenDto>? _messagesSeenSub;

  final Map<int, StreamController<bool>> _typingNotifier = {};
  final Set<int> _joinedConversations = {};

  MessagesRepository(this._cache, this._socket, this._apiService, this._authState) {

    _logger.w("Create MessagesRepository");
    _incomingSub = _socket.incomingMessages.listen(_onReceivedMessage);
    _incomingNotifSub = _socket.incomingMessagesNotifications.listen(
      _onReceivedMessage,
    );
    _typingSub = _socket.userTyping.listen(_onUserTypingEvent);
    _stopTypingSub = _socket.userStoppedTyping.listen(
      _onUserStoppedTypingEvent,
    );
    _messagesSeenSub = _socket.messagesSeen.listen(_onMessagesSeen);
    _reconnectedSub = _socket.onConnected.listen((_) => _onReconnected());
  }

  void dispose() {
    _logger.i("Disposing MessagesRepository");
      _incomingSub?.cancel();
      _incomingNotifSub?.cancel();

      _typingSub?.cancel();
      _stopTypingSub?.cancel();
      _messagesSeenSub?.cancel();

      _reconnectedSub?.cancel();

      for (final ctrl in _typingNotifier.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
      _typingNotifier.clear();

      for (final ctrl in _notifier.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
      _notifier.clear();
  }

  Future<void> _onMessagesSeen(MessagesSeenDto dto) async {
    try {
      final convId = dto.conversationId;
      _logger.i('Messages seen event received for conversation $convId by user ${dto.userId}');

      final messages = await _cache.getMessages(convId);
      var changed = false;

      for (var i = 0; i < messages.length; i++) {
        final m = messages[i];
        if (!m.isSeen) {
          messages[i] = m.copyWith(isSeen: true);
          changed = true;
        }
      }
      if (changed) {
        _cache.addMessages(convId, messages);
        _getNotifier(convId).add(null);
      }
    } catch (e, st) {
      _logger.e('Error handling messagesSeen event: $e\n$st');
    }
  }

  void _onReconnected() {
    _logger.i("Socket reconnected, rejoining conversations");
    for (var conversationId in _joinedConversations) {
      _socket.joinConversation(conversationId);
      _reSyncMessageHistory(conversationId);
    }
  }

  void _onReceivedMessage(MessageDto data) {
    _logger.d("Received message on socket: ${data.toJson()}");

    var message = ChatMessage.fromDto(data, currentUserId: _authState.user!.id!);

    _cache.addMessage(message.conversationId ?? -1, message);

    _getNotifier(message.conversationId ?? -1).add(null);
  }

  void _onUserTypingEvent(TypingEventDto event) {
    _logger.i(
      "User ${event.userId} is typing in conversation ${event.conversationId}",
    );
    _getTypingNotifier(event.conversationId).add(true);
  }

  void _onUserStoppedTypingEvent(TypingEventDto event) {
    _logger.i(
      "User ${event.userId} stopped typing in conversation ${event.conversationId}",
    );
    _getTypingNotifier(event.conversationId).add(false);
  }

  Stream<void> onMessageRecieved(int conversationId) =>
      _getNotifier(conversationId).stream;
  StreamController<void> _getNotifier(int conversationId) => _notifier
      .putIfAbsent(conversationId, () => StreamController<void>.broadcast());

  Stream<bool> onUserTyping(int conversationId) =>
      _getTypingNotifier(conversationId).stream;
  StreamController<bool> _getTypingNotifier(int conversationId) =>
      _typingNotifier.putIfAbsent(
        conversationId,
        () => StreamController<bool>.broadcast(),
      );

  Stream<void> onConnected() => _socket.onConnected;

  Future<List<ChatMessage>> fetchMessage(int chatId) async {
    return await _cache.getMessages(chatId);
  }

  void updateTypingStatus(int conversationId, bool isTyping) {
    _logger.d(
      "Updating typing status to $isTyping for conversation $conversationId",
    );
    if (isTyping) {
      _socket.sendTypingEvent(TypingRequest(conversationId: conversationId));
    } else {
      _socket.sendStopTypingEvent(
        TypingRequest(conversationId: conversationId),
      );
    }
  }

  


  Future<bool> _reSyncMessageHistory(int conversationId) async {
    _logger.i("Re-syncing Messages for conversation id {$conversationId}");

    int? newwestId = (await _cache.getMessages(conversationId))
        .map((e) => e.id)
        .fold<int?>(null, (previousValue, element) {
      if (previousValue == null) return element;
      return element > previousValue ? element : previousValue;
    });
    _logger.i("Re-syncing Lost Messages first message id is {$newwestId}");
    
    var messagesDto = await _apiService.getLostMessages(
        conversationId,
        newwestId,
      );

    var messages = messagesDto.data
        .map((x) => ChatMessage.fromDto(x, currentUserId: _authState.user!.id!))
        .toList();

    _cache.addMessages(conversationId, messages);
    _getNotifier(conversationId).add(null);

    return messagesDto.metadata.hasMore ?? false;
  }

  Future<bool> loadMessageHistory(int conversationId) async {
    int? lastMessageId = (await _cache.getMessages(conversationId)).firstOrNull?.id;
    _logger.i("Loading More Messages last message id is {$lastMessageId}");

    var messagesDto = await _apiService.getMessageHistory(
      conversationId,
      lastMessageId,
    );

    var messages = messagesDto.data
        .map((x) => ChatMessage.fromDto(x, currentUserId: _authState.user!.id!))
        .toList();

    _cache.addMessages(conversationId, messages);
    _getNotifier(conversationId).add(null);

    return messagesDto.metadata.hasMore ?? false;
  }
  
  Future<bool> loadInitMessage(int conversationId) async {

    var messages = await _cache.getMessages(conversationId);
    
    if(messages.isNotEmpty) {
      _logger.i("Messages already loaded for conversation id {$conversationId}");

      // Notify listeners to update UI
      _getNotifier(conversationId).add(null);

      // Synchronize lost messages
      int? newwestId = (await _cache.getMessages(conversationId))
        .map((e) => e.id)
        .fold<int?>(null, (previousValue, element) {
        if (previousValue == null) return element;
        return element > previousValue ? element : previousValue;
      });

      _logger.i("Loading Lost Messages first message id is {$newwestId}");
      var messagesDto = await _apiService.getLostMessages(
        conversationId,
        newwestId,
      );

      var newMessages = messagesDto.data
        .map((x) => ChatMessage.fromDto(x, currentUserId: _authState.user!.id!))
        .toList();

      await _cache.addMessages(conversationId, newMessages);
      _getNotifier(conversationId).add(null);
    }

    messages = await _cache.getMessages(conversationId);

    int? minMessageId = messages.isNotEmpty
      ? messages.map((e) => e.id).reduce((value, element) => value < element ? value : element)
      : null;

    _logger.i("Loading Initial Messages for conversation id {$conversationId}");
    var messagesDto = await _apiService.getMessageHistory(conversationId, minMessageId);

    var newMessages = messagesDto.data
      .map((x) => ChatMessage.fromDto(x, currentUserId: _authState.user!.id!))
      .toList();

    await _cache.addMessages(conversationId, newMessages);
    _getNotifier(conversationId).add(null);


    return messagesDto.metadata.hasMore ?? false;
  }

  Future<void> sendMessage(int senderId, int conversationId, String message) async {
    _logger.i("Sending message to conversation $conversationId: $message");

    final request = CreateMessageRequest(
      conversationId: conversationId,
      senderId: senderId,
      text: message,
    );

    // 1. Create a temporary local message (with negative ID to avoid conflicts)
    final tempId = -DateTime.now().millisecondsSinceEpoch;

    final optimisticMessage = ChatMessage(
      id: tempId,
      text: message,
      time: DateTime.now(),
      isMine: true,
      isDelivered: false,
      isSeen: false,
      senderId: senderId,
      conversationId: conversationId,
    );

    // Add optimistic message
    _cache.addMessage(conversationId, optimisticMessage);
    _getNotifier(conversationId).add(null);

    MessageDto? messageDto;

    try {
      messageDto = await _socket.sendMessage(request);
    } on BlockedUserError {
      // Remove the optimistic message
      _cache.removeMessage(conversationId, tempId);
      _getNotifier(conversationId).add(null);
      rethrow;
    }

    // If server sent nothing, just remove local optimistic message
    if (messageDto == null) {
      _logger.e("Failed to send message, server returned null");
      _cache.removeMessage(conversationId, tempId);
      _getNotifier(conversationId).add(null);
      return;
    }

    // Remove the optimistic message
    _cache.removeMessage(conversationId, tempId);

    // Add the real server message
    _cache.addMessage(
      conversationId,
      ChatMessage.fromDto(
        messageDto,
        currentUserId: _authState.user!.id!,
      ),
    );

    _getNotifier(conversationId).add(null);
  }

  void sendMarkAsSeen(int conversationId) async {
    
    final req = MarkSeenRequest(
      conversationId: conversationId,
      userId: _authState.user!.id!,
    );

    _socket.markSeen(req);
  }
  void joinConversation(int conversationId) {
    _logger.i("Joining conversation $conversationId");
    _socket.joinConversation(conversationId);
    _joinedConversations.add(conversationId);
  }

  void leaveConversation(int conversationId) {
    _logger.i("Leaving conversation $conversationId");
    _socket.leaveConversation(conversationId);
    _joinedConversations.remove(conversationId);
  }

}
