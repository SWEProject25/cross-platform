// coverage:ignore-file

import 'dart:async';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/messaging/errors/blocked_user_error.dart';
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
  final StreamController<void> _connectedController = StreamController<void>.broadcast();
  final StreamController<MessagesSeenDto> _messagesSeenController = StreamController<MessagesSeenDto>.broadcast();

  MessagesSocketService(this._socket){
    _logger.w("Create MessagesSocketService");
  }

  void setUpListners(){
    _listenToMessages();
    _listenToMessagesNotifications();
    _listenToTypingEvents();
    _listenToStopTypingEvents();
    _listenToMessagesSeen();
    _listenForReconnected();
  }

  void _listenForReconnected() {
    _socket.on("connect", (_) {
      _connectedController.add(null);
    });
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

  void _listenToMessagesSeen() {
    _socket.on("messagesSeen", (data) {
      try {
        _logger.i("Received messagesSeen event on socket: $data");
        final dto = MessagesSeenDto.fromJson(Map<String, dynamic>.from(data));
        _messagesSeenController.add(dto);
      } catch (e) {
        _logger.e("Error parsing messagesSeen event: $e");
      }
    });
  }

  Stream<MessageDto> get incomingMessages => _incomingMessagesController.stream;

  Stream<MessageDto> get incomingMessagesNotifications => _incomingMessagesNotificationsController.stream;
  
  Stream<TypingEventDto> get userTyping => _userTypingController.stream;

  Stream<TypingEventDto> get userStoppedTyping => _userStoppedTypingController.stream;

  Stream<void> get onConnected => _connectedController.stream;

  Stream<MessagesSeenDto> get messagesSeen => _messagesSeenController.stream;

  Future<MessageDto?> sendMessage(CreateMessageRequest request) async {
    try {
      final resp = await _socket.emitWithAck("createMessage", request.toJson());
      _logger.i("Socket response for sendMessage: $resp");

      if (resp == null) return null;

      var payload = resp;
      if (resp is List && resp.isNotEmpty) payload = resp.first;
      if (payload is Map) {
        if (payload["status"] == "error") {
          if (payload["message"] != null && payload["message"] is String) {
            String errorMessage = payload["message"];
            if (errorMessage.contains("blocked")) {
              throw BlockedUserError();
            } else {
              throw Exception("Socket error: $errorMessage");
            }
          } else {
            throw Exception("Unknown socket error");
          }
        }
        return MessageDto.fromJson(Map<String, dynamic>.from(payload["data"]));
      }

      // Unexpected format
      _logger.w("Unexpected socket response format: $resp");
      return null;
    } on BlockedUserError catch (e) {
      rethrow;
    } catch (e) {
      _logger.e("Failed to send message with ack: $e");
      rethrow;
    }
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

  void markSeen(MarkSeenRequest request) {
    _socket.emit('markSeen', request.toJson());
  }

  void dispose() {
    // Remove all attached listeners we registered
    _socket.off("messageCreated");
    _socket.off("newMessageNotification");
    _socket.off("userTyping");
    _socket.off("userStoppedTyping");
    _socket.off("messagesSeen");
    _socket.off("connect");

    // Close controllers
    try {
      _incomingMessagesController.close();
    } catch (_) {}
    try {
      _incomingMessagesNotificationsController.close();
    } catch (_) {}
    try {
      _userTypingController.close();
    } catch (_) {}
    try {
      _userStoppedTypingController.close();
    } catch (_) {}
    try {
      _connectedController.close();
    } catch (_) {}
    try {
      _messagesSeenController.close();
    } catch (_) {}
  }
}
