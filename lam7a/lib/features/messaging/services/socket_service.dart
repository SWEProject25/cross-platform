import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:path/path.dart' as path;

part 'socket_service.g.dart';


final socketServiceProvider = Provider<SocketService>((ref) => SocketService());

@Riverpod(keepAlive: true)
void socketInitializer(Ref ref) {
  final auth = ref.watch(authenticationProvider);
  final socket = ref.read(socketServiceProvider);

  if(auth.user != null){
    print("SOCKET: Connecting");
    socket.connect();
  }else{
    print("SOCKET: Disconnecting");
    socket.disconnect();
  }
}

class SocketService {
  late final IO.Socket _socket;

  Future<void> connect() async {
    var cookieHeader = await getCookie();

    _socket = IO.io(
      ServerConstant.serverURL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setExtraHeaders({'cookie': cookieHeader})
          .build(),
    );

    _socket.onError((err) => print(err.toString()));

    _socket.onConnect((_) => print('Connected to socket'));
    _socket.onDisconnect((_) => print('Disconnected'));
  }

  Future<String> getCookie() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookiePath = path.join(directory.path, '.cookies');
    await Directory(cookiePath).create(recursive: true);

    final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    final uri = Uri.parse(ServerConstant.serverURL); // ← your API / socket domain
    final cookies = await cookieJar.loadForRequest(uri);

    if (cookies.isEmpty) {
      print('⚠️ No cookies found in jar for $uri');
    }

    final cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');

    return cookieHeader;
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
