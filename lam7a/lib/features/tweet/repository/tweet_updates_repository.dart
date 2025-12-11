import 'dart:async';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/tweet/dtos/tweets_socket_events_dto.dart';
import 'package:lam7a/features/tweet/services/tweet_socket_service.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_updates_repository.g.dart';

@Riverpod(keepAlive: true)
TweetUpdatesRepository tweetUpdatesRepository(Ref ref) {
  var repo = TweetUpdatesRepository(
    ref.read(tweetsSocketServiceProvider),
    ref.watch(authenticationProvider),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
}

class TweetUpdatesRepository {
  final Logger _logger = getLogger(TweetUpdatesRepository);

  final TweetsSocketService _socket;
  final AuthState _authState;

  final Map<int, StreamController<void>> _notifier = {};
  StreamSubscription<PostUpdateDto>? _likeUpdateSub;
  StreamSubscription<PostUpdateDto>? _repostUpdateSub;
  StreamSubscription<PostUpdateDto>? _commentUpdateSub;
  StreamSubscription<void>? _reconnectedSub;

  final Set<int> _joinedPosts = {};

  final Map<int, StreamController<int>> _postCommentCounts = {};
  final Map<int, StreamController<int>> _postLikeCounts = {};
  final Map<int, StreamController<int>> _postRepostCounts = {};

  TweetUpdatesRepository(this._socket, this._authState) {

    _logger.w("Create MessagesRepository");
    _likeUpdateSub = _socket.likeUpdates.listen(_onLikeUpdate);
    _repostUpdateSub = _socket.repostUpdates.listen(_onRepostUpdate);
    _commentUpdateSub = _socket.commentUpdates.listen(_onCommentUpdate);
    _reconnectedSub = _socket.onConnected.listen((_) => _onReconnected());
  }

  void dispose() {
    _logger.i("Disposing MessagesRepository");
      _likeUpdateSub?.cancel();
      _repostUpdateSub?.cancel();
      _commentUpdateSub?.cancel();

      _reconnectedSub?.cancel();

      for (final ctrl in _notifier.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
      _notifier.clear();

      for (final ctrl in _postCommentCounts.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
      _postCommentCounts.clear();

      for (final ctrl in _postLikeCounts.values) {
        if (!ctrl.isClosed) ctrl.close();
      }
  }


  void _onReconnected() {
    _logger.i("Socket reconnected, rejoining conversations");
    for (var postId in _joinedPosts) {
      _socket.joinPost(postId);
    }

    // for (var conversationId in _joinedConversations) {
    //   _reSyncMessageHistory(conversationId);
    // }
  }

  void _onLikeUpdate(PostUpdateDto data) {
    _logger.d("Received like update on socket: ${data.toString()}");

    var controller = _postLikeCounts.putIfAbsent(
      data.postId,
      () => StreamController<int>.broadcast(),
    );

    controller.add(data.count);
  }

  void _onRepostUpdate(PostUpdateDto data) {
    _logger.d("Received repost update on socket: ${data.toString()}");

    var controller = _postRepostCounts.putIfAbsent(
      data.postId,
      () => StreamController<int>.broadcast(),
    );

    controller.add(data.count);
  }

  void _onCommentUpdate(PostUpdateDto data) {
    _logger.d("Received comment update on socket: ${data.toString()}");

    var controller = _postCommentCounts.putIfAbsent(
      data.postId,
      () => StreamController<int>.broadcast(),
    );

    controller.add(data.count);
  }

  Stream<void> onMessageRecieved(int conversationId) =>
      _getNotifier(conversationId).stream;
  StreamController<void> _getNotifier(int conversationId) => _notifier
      .putIfAbsent(conversationId, () => StreamController<void>.broadcast());

  Stream<int> onPostLikeUpdates(int postId) {
    return _postLikeCounts
        .putIfAbsent(postId, () => StreamController<int>.broadcast())
        .stream;
  }

  Stream<int> onPostRepostUpdates(int postId) {
    return _postRepostCounts
        .putIfAbsent(postId, () => StreamController<int>.broadcast())
        .stream;
  }

  Stream<int> onPostCommentUpdates(int postId) {
    return _postCommentCounts
        .putIfAbsent(postId, () => StreamController<int>.broadcast())
        .stream;
  }

  Stream<void> onConnected() => _socket.onConnected;


  void joinPost(int postId) {
    _logger.i("Joining post $postId");
    _socket.joinPost(postId);
    _joinedPosts.add(postId);
  }

  void leavePost(int postId) {
    _logger.i("Leaving post $postId");
    _socket.leavePost(postId);
    _joinedPosts.remove(postId);
  }

}
