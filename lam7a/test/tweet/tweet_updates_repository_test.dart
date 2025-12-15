import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/features/tweet/dtos/tweets_socket_events_dto.dart';
import 'package:lam7a/features/tweet/repository/tweet_updates_repository.dart';
import 'package:lam7a/features/tweet/services/tweet_socket_service.dart';

class FakeTweetsSocketService implements TweetsSocketService {
  final likeController = StreamController<PostUpdateDto>.broadcast();
  final repostController = StreamController<PostUpdateDto>.broadcast();
  final commentController = StreamController<PostUpdateDto>.broadcast();
  final connectedController = StreamController<void>.broadcast();

  final List<int> joinCalls = [];
  final List<int> leaveCalls = [];

  // Stream getters
  @override
  Stream<PostUpdateDto> get likeUpdates => likeController.stream;

  @override
  Stream<PostUpdateDto> get repostUpdates => repostController.stream;

  @override
  Stream<PostUpdateDto> get commentUpdates => commentController.stream;

  @override
  Stream<void> get onConnected => connectedController.stream;

  // Command methods
  @override
  void joinPost(int postId) {
    joinCalls.add(postId);
  }

  @override
  void leavePost(int postId) {
    leaveCalls.add(postId);
  }

  @override
  void dispose() {
    likeController.close();
    repostController.close();
    commentController.close();
    connectedController.close();
  }

  @override
  void setUpListners() {
    // Not needed for tests
  }

  // Helpers to emit events
  void emitLike(int postId, int count) {
    likeController.add(PostUpdateDto(postId: postId, count: count));
  }

  void emitRepost(int postId, int count) {
    repostController.add(PostUpdateDto(postId: postId, count: count));
  }

  void emitComment(int postId, int count) {
    commentController.add(PostUpdateDto(postId: postId, count: count));
  }

  void emitConnected() {
    connectedController.add(null);
  }
}

void main() {
  group('TweetUpdatesRepository streams', () {
    test('onPostLikeUpdates emits counts from socket like updates', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket, const AuthState());

      final future = repo.onPostLikeUpdates(1).first;

      socket.emitLike(1, 10);

      final count = await future;
      expect(count, 10);
    });

    test('onPostRepostUpdates emits counts from socket repost updates', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket, const AuthState());

      final future = repo.onPostRepostUpdates(2).first;

      socket.emitRepost(2, 4);

      final count = await future;
      expect(count, 4);
    });

    test('onPostCommentUpdates emits counts from socket comment updates',
        () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket, const AuthState());

      final future = repo.onPostCommentUpdates(3).first;

      socket.emitComment(3, 7);

      final count = await future;
      expect(count, 7);
    });
  });

  group('TweetUpdatesRepository lifecycle', () {
    test('joinPost tracks joined posts and rejoins after reconnect', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket, const AuthState());

      repo.joinPost(10);
      repo.joinPost(20);

      expect(socket.joinCalls, [10, 20]);

      // Simulate reconnect event
      socket.emitConnected();
      await Future.delayed(Duration.zero);

      // Should have re-joined each post
      expect(socket.joinCalls, [10, 20, 10, 20]);
    });

    test('dispose closes per-post like count streams', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket, const AuthState());

      final stream = repo.onPostLikeUpdates(1);
      var isDone = false;
      final sub = stream.listen((_) {}, onDone: () => isDone = true);

      await Future.delayed(Duration.zero);
      repo.dispose();
      await Future.delayed(Duration.zero);

      expect(isDone, isTrue);
      await sub.cancel();
    });
  });
}
