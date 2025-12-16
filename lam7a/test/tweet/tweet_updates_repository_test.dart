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
      final repo = TweetUpdatesRepository(socket);

      final future = repo.onPostLikeUpdates(1).first;

      socket.emitLike(1, 10);

      final count = await future;
      expect(count, 10);
    });

    test('onPostRepostUpdates emits counts from socket repost updates', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final future = repo.onPostRepostUpdates(2).first;

      socket.emitRepost(2, 4);

      final count = await future;
      expect(count, 4);
    });

    test('onPostCommentUpdates emits counts from socket comment updates',
        () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final future = repo.onPostCommentUpdates(3).first;

      socket.emitComment(3, 7);

      final count = await future;
      expect(count, 7);
    });

    test('_onLikeUpdate creates controller and emits count for new post',
        () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      // Listen to the stream (this triggers controller creation if not exists)
      final streamFuture = repo.onPostLikeUpdates(100).take(2).toList();

      // Emit multiple like updates for the same post
      socket.emitLike(100, 5);
      await Future.delayed(Duration.zero);
      socket.emitLike(100, 8);
      await Future.delayed(Duration.zero);

      final counts = await streamFuture;
      expect(counts, [5, 8]);
    });

    test('_onRepostUpdate creates controller and emits count for new post',
        () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final streamFuture = repo.onPostRepostUpdates(200).take(2).toList();

      socket.emitRepost(200, 3);
      await Future.delayed(Duration.zero);
      socket.emitRepost(200, 6);
      await Future.delayed(Duration.zero);

      final counts = await streamFuture;
      expect(counts, [3, 6]);
    });

    test('_onCommentUpdate creates controller and emits count for new post',
        () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final streamFuture = repo.onPostCommentUpdates(300).take(2).toList();

      socket.emitComment(300, 12);
      await Future.delayed(Duration.zero);
      socket.emitComment(300, 15);
      await Future.delayed(Duration.zero);

      final counts = await streamFuture;
      expect(counts, [12, 15]);
    });

    test('multiple posts can have independent like streams', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final stream1 = repo.onPostLikeUpdates(1).first;
      final stream2 = repo.onPostLikeUpdates(2).first;

      socket.emitLike(1, 10);
      socket.emitLike(2, 20);

      final count1 = await stream1;
      final count2 = await stream2;

      expect(count1, 10);
      expect(count2, 20);
    });
  });

  group('TweetUpdatesRepository lifecycle', () {
    test('joinPost tracks joined posts and rejoins after reconnect', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      repo.joinPost(10);
      repo.joinPost(20);

      expect(socket.joinCalls, [10, 20]);

      // Simulate reconnect event - triggers _onReconnected
      socket.emitConnected();
      await Future.delayed(Duration.zero);

      // Should have re-joined each post
      expect(socket.joinCalls, [10, 20, 10, 20]);
    });

    test('_onReconnected rejoins all previously joined posts', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      repo.joinPost(1);
      repo.joinPost(2);
      repo.joinPost(3);
      repo.leavePost(2); // Leave one

      expect(socket.joinCalls, [1, 2, 3]);
      socket.joinCalls.clear();

      // Simulate reconnection
      socket.emitConnected();
      await Future.delayed(Duration.zero);

      // Should rejoin only posts 1 and 3 (not 2, which was left)
      expect(socket.joinCalls.length, 2);
      expect(socket.joinCalls, containsAll([1, 3]));
    });

    test('dispose closes per-post like count streams', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final stream = repo.onPostLikeUpdates(1);
      var isDone = false;
      final sub = stream.listen((_) {}, onDone: () => isDone = true);

      await Future.delayed(Duration.zero);
      repo.dispose();
      await Future.delayed(Duration.zero);

      expect(isDone, isTrue);
      await sub.cancel();
    });

    test('dispose closes per-post repost count streams', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final stream = repo.onPostRepostUpdates(1);
      var isDone = false;
      final sub = stream.listen((_) {}, onDone: () => isDone = true);

      await Future.delayed(Duration.zero);
      repo.dispose();
      await Future.delayed(Duration.zero);

      expect(isDone, isTrue);
      await sub.cancel();
    });

    test('dispose closes per-post comment count streams', () async {
      final socket = FakeTweetsSocketService();
      final repo = TweetUpdatesRepository(socket);

      final stream = repo.onPostCommentUpdates(1);
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
