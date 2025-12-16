// coverage:ignore-file

import 'dart:io';
import 'dart:async';

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

/// A Riverpod stream provider that emits the socket connection state.
/// Emits the current `isConnected` state immediately, then subsequent changes.
final socketConnectionProvider = StreamProvider<bool>((ref) {
  final socketService = ref.watch(socketServiceProvider);

  // Create a controller to emit the current state immediately and then follow changes.
  final controller = StreamController<bool>();

  // Emit current state right away.
  try {
    controller.add(socketService.isConnected);
  } catch (_) {}

  final sub = socketService.connectionChanges.listen((connected) {
    try {
      controller.add(connected);
    } catch (_) {}
  });

  ref.onDispose(() {
    try {
      sub.cancel();
    } catch (_) {}
    try {
      controller.close();
    } catch (_) {}
  });

  return controller.stream;
});

/// Convenience provider to get the immediate connection state (non-reactive).
final socketIsConnectedProvider = Provider<bool>((ref) => ref.read(socketServiceProvider).isConnected);

class SocketService {
  IO.Socket? _socket;

  final Map<String, List<Function(dynamic)>> _listeners = {};

  // Broadcast stream to watch connection state changes
  final _connectionController = StreamController<bool>.broadcast();


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

    _socket!.onConnect((_) {
      _logger.i('Connected to socket');
      try {
        _connectionController.add(true);
      } catch (_) {}
    });

    _socket!.onDisconnect((_) {
      _logger.i('Disconnected');
      try {
        _connectionController.add(false);
      } catch (_) {}
    });

    _attachStoredListeners();
  }

  /// Whether the socket is currently connected.
  bool get isConnected => _socket?.connected ?? false;

  /// A broadcast stream that emits `true` when connected and `false` when disconnected.
  Stream<bool> get connectionChanges => _connectionController.stream;

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

  /// Emit an event and wait for server acknowledgement.
  ///
  /// Uses the underlying socket client's `emitWithAck` when available.
  /// Returns the ack response or throws on timeout/error.
  Future<dynamic> emitWithAck(String event, dynamic data, {Duration timeout = const Duration(seconds: 5)}) async {
    if (_socket == null) {
      _logger.w('Attempted to emitWithAck while socket is null. Event: $event');
      throw StateError('Socket is not connected');
    }
    try {

      final ack = await _socket!.emitWithAckAsync(event, data);
      _logger.i('emitWithAck for "$event" received ack: $ack');
      return ack;
    } catch (e) {
      _logger.e('emitWithAck failed for "$event": $e');
      rethrow;
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
    try {
      _socket?.disconnect();
    } finally {
      try {
        _connectionController.add(false);
      } catch (_) {}
    }
  }

  /// Close internal controllers and dispose socket.
  /// Call this if you want to fully cleanup the service.
  Future<void> dispose() async {
    try {
      _socket?.disconnect();
    } catch (_) {}
    try {
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
    try {
      await _connectionController.close();
    } catch (_) {}
  }
}
