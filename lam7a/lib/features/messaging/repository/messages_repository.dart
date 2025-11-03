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

  @override
  void build() {
    _cache = ref.read(messagesStoreProvider);
    _apiService = ref.read(dmsApiServiceProvider);
    _socket = ref.read(messagesSocketServiceProvider);
    _authState = ref.watch(authenticationProvider);

    _logger.w("Create MessagesRepository");
    _incomingSub = _socket.incomingMessages.listen(_onReceivedMessage);
    _incomingNotifSub = _socket.incomingMessagesNotifications.listen(_onReceivedMessage);

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

  Stream<void> onMessageRecieved(int conversationId) => _getNotifier(conversationId).stream;
  StreamController<void> _getNotifier(int conversationId) => _notifier.putIfAbsent(conversationId, ()=>StreamController<void>.broadcast());

  List<ChatMessage> fetchMessage(int chatId) {
    return _cache.getMessages(chatId);
  }

  void sendMessage(int senderId, int conversationId, String message) {
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
