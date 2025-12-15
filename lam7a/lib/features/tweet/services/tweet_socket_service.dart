// coverage:ignore-file
import 'dart:async';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/tweet/dtos/tweets_socket_events_dto.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'tweet_socket_service.g.dart';


@Riverpod(keepAlive: true)
TweetsSocketService tweetsSocketService(Ref ref) {
  final socket = ref.read(socketServiceProvider); 
  return TweetsSocketService(socket);
}

  class TweetsSocketService {
  final Logger _logger = getLogger(TweetsSocketService);
  final SocketService _socket;

  final StreamController<PostUpdateDto> _likeUpdateController = StreamController<PostUpdateDto>.broadcast();
  final StreamController<PostUpdateDto> _repostUpdateController = StreamController<PostUpdateDto>.broadcast();
  final StreamController<PostUpdateDto> _commentUpdateController = StreamController<PostUpdateDto>.broadcast();
  final StreamController<void> _connectedController = StreamController<void>.broadcast();

  TweetsSocketService(this._socket){
    _logger.w("Create TweetsSocketService");
  }

  void setUpListners(){
    _listenLikeUpdates();
    _listenRepostUpdates();
    _listenCommentUpdates();
    _listenForReconnected();
  }

  void _listenForReconnected() {
    _socket.on("connect", (_) {
      _connectedController.add(null);
    });
  }

  void _listenLikeUpdates() {
    _socket.on("likeUpdate", (data) {
      try {
        _logger.i("Recieved like update on socket: $data");
        final update = PostUpdateDto.fromJson(Map<String, dynamic>.from(data));
        _likeUpdateController.add(update);
      } catch (e) {
        _logger.e("Error parsing like update: $e");
      }
    });
  }

  void _listenRepostUpdates() {
    _socket.on("repostUpdate", (data) {
      try {
        _logger.i("Recieved repost update on socket: $data");
        final update = PostUpdateDto.fromJson(Map<String, dynamic>.from(data));
        _repostUpdateController.add(update);
      } catch (e) {
        _logger.e("Error parsing repost update: $e");
      }
    });
  }

  void _listenCommentUpdates() {
    _socket.on("commentUpdate", (data) {
      try {
        _logger.i("Recieved comment update on socket: $data");
        final update = PostUpdateDto.fromJson(Map<String, dynamic>.from(data));
        _commentUpdateController.add(update);
      } catch (e) {
        _logger.e("Error parsing comment update: $e");
      }
    });
  }

  Stream<PostUpdateDto> get likeUpdates => _likeUpdateController.stream;
  Stream<PostUpdateDto> get repostUpdates => _repostUpdateController.stream;
  Stream<PostUpdateDto> get commentUpdates => _commentUpdateController.stream;

  Stream<void> get onConnected => _connectedController.stream;

  void joinPost(int postId) {
    _socket.emit("joinPost", postId);
  }
  
  void leavePost(int postId) {
    _socket.emit("leavePost", postId);
  }

  void dispose() {
    // Remove all attached listeners we registered

    _socket.off("likeUpdate");
    _socket.off("repostUpdate");
    _socket.off("commentUpdate");

    // Close controllers
    try {
      _likeUpdateController.close();
    } catch (_) {}
    try {
      _repostUpdateController.close();
    } catch (_) {}
    try {
      _commentUpdateController.close();
    } catch (_) {}
  }
}
