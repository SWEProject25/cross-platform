import 'dart:async';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/services/socket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'messages_socket_service.g.dart';

@riverpod
MessagesSocketService messagesSocketService(Ref ref) {
  final socket = ref.read(socketServiceProvider); 
  return MessagesSocketService(socket);
}

class MessagesSocketService {
  final SocketService _socket;
  final StreamController<MessageDto> _incomingController = StreamController<MessageDto>.broadcast();

  Stream<MessageDto> get incomingMessages => _incomingController.stream;

  MessagesSocketService(this._socket);

  void connect(){
    _listenToMessages();
  }

  void _listenToMessages() {
    _socket.on("newMessageNotification", (data) {
      try {
        print("Recieved message on socket: $data");
        final message = MessageDto.fromJson(Map<String, dynamic>.from(data));
        _incomingController.add(message);
      } catch (e) {
        print("Error parsing message: $e");
      }
    });
  }

  void sendMessage(CreateMessageRequest request) {
    _socket.emit("createMessage", request.toJson());
  }

  void dispose() {
    _socket.off("createMessageNotification");
    _incomingController.close();
  }
}
