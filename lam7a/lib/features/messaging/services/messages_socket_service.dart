import 'dart:async';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/core/services/socket_service.dart';
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
  final StreamController<TypingEventDto> _userTypingController = StreamController<TypingEventDto>.broadcast();
  final StreamController<TypingEventDto> _userStoppedTypingController = StreamController<TypingEventDto>.broadcast();

  MessagesSocketService(this._socket){
    _logger.w("Create MessagesSocketService");
  }

  void setUpListners(){
    _listenToMessages();
    _listenToMessagesNotifications();
    _listenToTypingEvents();
    _listenToStopTypingEvents();
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

  void _listenToTypingEvents() {
    _socket.on("userTyping", (data) {
      try {
        _logger.i("Recieved typing event on socket: $data");
        final typingEvent = TypingEventDto.fromJson(Map<String, dynamic>.from(data));
        _userTypingController.add(typingEvent);
      } catch (e) {
        _logger.e("Error parsing typing event: $e");
      }
    });
  }

  void _listenToStopTypingEvents() {
    _socket.on("userStoppedTyping", (data) {
      try {
        _logger.i("Recieved stop typing event on socket: $data");
        final typingEvent = TypingEventDto.fromJson(Map<String, dynamic>.from(data));
        _userStoppedTypingController.add(typingEvent);
      } catch (e) {
        _logger.e("Error parsing stop typing event: $e");
      }
    });
  }

  Stream<MessageDto> get incomingMessages => _incomingMessagesController.stream;

  Stream<MessageDto> get incomingMessagesNotifications => _incomingMessagesNotificationsController.stream;
  
  Stream<TypingEventDto> get userTyping => _userTypingController.stream;

  Stream<TypingEventDto> get userStoppedTyping => _userStoppedTypingController.stream;

  void sendMessage(CreateMessageRequest request) {
    _socket.emit("createMessage", request.toJson());
  }

  void joinConversation(int conversationId) {
    _socket.emit("joinConversation", conversationId);
  }
  
  void leaveConversation(int conversationId) {
    _socket.emit("leaveConversation", conversationId);
  }

  void sendTypingEvent(TypingRequest request) {
     _socket.emit("typing", request.toJson());
  }

  void sendStopTypingEvent(TypingRequest request) {
    _socket.emit("stopTyping", request.toJson());
  }

  void dispose() {
    _socket.off("messageCreated");
    _socket.off("createMessageNotification");
    _incomingMessagesController.close();
    _incomingMessagesNotificationsController.close();
  }
}
