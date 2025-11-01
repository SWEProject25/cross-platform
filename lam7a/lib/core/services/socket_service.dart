import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
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
    socket.connect();
  }else{
    socket.disconnect();
  }
}

class SocketService {
  IO.Socket? _socket;

  final Map<String, List<Function(dynamic)>> _listeners = {};


  final _logger = getLogger(SocketService);

  Future<void> connect() async {
    if (_socket != null) {
      _logger.i('Disposing existing socket');
      try {
        _socket!.disconnect();
      } catch (_) {}
      try {
        _socket!.dispose();
      } catch (_) {}
      _socket = null;
    }

    _logger.i("Connecting to socket service");

    var cookieHeader = await getCookie();

    _socket = IO.io(
      ServerConstant.serverURL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setExtraHeaders({'cookie': cookieHeader})
          .build(),
    );

    _socket!.onError((err) => _logger.e(err.toString()));

    _socket!.onConnect((_) => _logger.i('Connected to socket'));
    _socket!.onDisconnect((_) => _logger.i('Disconnected'));

    _attachStoredListeners();
  }

  Future<String> getCookie() async {
    final directory = await getApplicationDocumentsDirectory();
    final cookiePath = path.join(directory.path, '.cookies');
    await Directory(cookiePath).create(recursive: true);

    final cookieJar = PersistCookieJar(storage: FileStorage(cookiePath));

    final uri = Uri.parse(ServerConstant.serverURL); // ← your API / socket domain
    final cookies = await cookieJar.loadForRequest(uri);

    if (cookies.isEmpty) {
      _logger.w('⚠️ No cookies found in jar for $uri');
      return "";
    }

    final cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');

    return cookieHeader;
  }

  void _attachStoredListeners() {
    if (_socket == null) return;
    _listeners.forEach((event, callbacks) {
      for (final cb in callbacks) {
        try {
          _socket!.on(event, cb);
        } catch (e, st) {
          _logger.w('Failed to attach listener for "$event": $e\n$st');
        }
      }
    });
  }


  void on(String event, Function(dynamic) callback) {
    // store callback
    _listeners.putIfAbsent(event, () => []).add(callback);

    // attach to live socket if exists
    try {
      _socket?.on(event, callback);
    } catch (e) {
      _logger.w('Failed to attach on() for "$event": $e');
    }
  }


  void emit(String event, dynamic data) {
    if (_socket == null) {
      _logger.w('Attempted to emit while socket is null. Event: $event');
      return;
    }
    try {
      _socket!.emit(event, data);
    } catch (e) {
      _logger.e('Failed to emit "$event": $e');
    }
  }


  void off(String event, [Function(dynamic)? callback]) {
    if (callback == null) {
      _listeners.remove(event);
      try {
        _socket?.off(event);
      } catch (e) {
        _logger.w('Failed to off() for "$event": $e');
      }
    } else {
      _listeners[event]?.remove(callback);
      try {
        _socket?.off(event, callback);
      } catch (e) {
        _logger.w('Failed to off(event, callback) for "$event": $e');
      }
    }
  }

  void disconnect() {
    _logger.i("Disconnecting from socket");
    _socket?.disconnect();
  }
}
