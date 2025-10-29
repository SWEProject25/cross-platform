import 'package:lam7a/core/constants/server_constant.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part 'socket_service.g.dart';

@riverpod
SocketService socketService(Ref ref) {
  return SocketService();
}

class SocketService {
  late final IO.Socket _socket;

  void connect(String token) {
    _socket = IO.io(
      ServerConstant.socketServer,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setExtraHeaders({'Authorization': token})
          .build(),
    );

    _socket.onError((err) => print(err.toString()));

    _socket.onConnect((_) => print('Connected to socket'));
    _socket.onDisconnect((_) => print('Disconnected'));
  }

  void on(String event, Function(dynamic) callback) {
    _socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void off(String event){
    _socket.off(event);
  }

  void disconnect() {
    _socket.disconnect();
  }
}
