import 'dart:async';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/services/socket_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messages_socket_service.g.dart';

@Riverpod(keepAlive: true)
MessagesSocketService messagesSocketService(Ref ref) {
  final socket = ref.read(socketServiceProvider); 
  return MessagesSocketService(socket);
}

class MessagesSocketService {
  final Logger _logger = getLogger(MessagesSocketService);
  final SocketService _socket;

  final StreamController<MessageDto> _incomingMessagesController = StreamController<MessageDto>.broadcast();
  final StreamController<MessageDto> _incomingMessagesNotificationsController = StreamController<MessageDto>.broadcast();

  MessagesSocketService(this._socket){
    _logger.w("Create MessagesSocketService");
  }

  void setUpListners(){
    _listenToMessages();
    _listenToMessagesNotifications();
  }

  void _listenToMessages() {
    _socket.on("messageCreated", (data) {
      try {
        _logger.i("Recieved message on socket: $data");
        final message = MessageDto.fromJson(Map<String, dynamic>.from(data));
        _incomingMessagesController.add(message);
      } catch (e) {
        _logger.e("Error parsing message: $e");
      }
    });
  }

  void _listenToMessagesNotifications() {
    _socket.on("newMessageNotification", (data) {
      try {
        _logger.i("Recieved message on socket: $data");
        final message = MessageDto.fromJson(Map<String, dynamic>.from(data));
        _incomingMessagesNotificationsController.add(message);
      } catch (e) {
        _logger.e("Error parsing message: $e");
      }
    });
  }

  Stream<MessageDto> get incomingMessages => _incomingMessagesController.stream;

  Stream<MessageDto> get incomingMessagesNotifications => _incomingMessagesNotificationsController.stream;

  void sendMessage(CreateMessageRequest request) {
    _socket.emit("createMessage", request.toJson());
  }

  void joinConversation(int conversationId) {
    _socket.emit("joinConversation", conversationId);
  }
  
  void leaveConversation(int conversationId) {
    _socket.emit("joinConversation", conversationId);
  }

  void dispose() {
    _socket.off("messageCreated");
    _socket.off("createMessageNotification");
    _incomingMessagesController.close();
    _incomingMessagesNotificationsController.close();
  }
}
