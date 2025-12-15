import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/tweet/dtos/tweets_socket_events_dto.dart';
import 'package:lam7a/features/tweet/services/tweet_socket_service.dart';

class MockSocketService extends Mock implements SocketService {}

void main() {
  late MockSocketService mockSocket;
  late TweetsSocketService service;

  setUp(() {
    mockSocket = MockSocketService();
    service = TweetsSocketService(mockSocket);
    service.setUpListners();
  });

  group('TweetsSocketService listeners', () {
    test('likeUpdates emits PostUpdateDto when likeUpdate event is received',
        () async {
      // Capture the callback registered for likeUpdate
      final captured = verify(
        () => mockSocket.on('likeUpdate', captureAny()),
      ).captured;

      final callback = captured.single as Function(dynamic);

      final future = service.likeUpdates.first;

      callback(<String, dynamic>{'postId': 1, 'count': 7});

      final dto = await future;
      expect(dto.postId, 1);
      expect(dto.count, 7);
    });

    test('repostUpdates emits PostUpdateDto when repostUpdate event is received',
        () async {
      final captured = verify(
        () => mockSocket.on('repostUpdate', captureAny()),
      ).captured;

      final callback = captured.single as Function(dynamic);

      final future = service.repostUpdates.first;

      callback(<String, dynamic>{'postId': 2, 'count': 3});

      final dto = await future;
      expect(dto.postId, 2);
      expect(dto.count, 3);
    });

    test('commentUpdates emits PostUpdateDto when commentUpdate event is received',
        () async {
      final captured = verify(
        () => mockSocket.on('commentUpdate', captureAny()),
      ).captured;

      final callback = captured.single as Function(dynamic);

      final future = service.commentUpdates.first;

      callback(<String, dynamic>{'postId': 5, 'count': 9});

      final dto = await future;
      expect(dto.postId, 5);
      expect(dto.count, 9);
    });

    test('onConnected emits when connect event is received', () async {
      final captured = verify(
        () => mockSocket.on('connect', captureAny()),
      ).captured;

      final callback = captured.single as Function(dynamic);

      final future = service.onConnected.first;

      callback(null);

      await future;
    });
  });

  group('TweetsSocketService commands', () {
    test('joinPost emits joinPost event on socket', () {
      service.joinPost(42);

      verify(() => mockSocket.emit('joinPost', 42)).called(1);
    });

    test('leavePost emits leavePost event on socket', () {
      service.leavePost(99);

      verify(() => mockSocket.emit('leavePost', 99)).called(1);
    });

    test('dispose removes listeners via off()', () {
      service.dispose();

      verify(() => mockSocket.off('likeUpdate')).called(1);
      verify(() => mockSocket.off('repostUpdate')).called(1);
      verify(() => mockSocket.off('commentUpdate')).called(1);
    });
  });
}
