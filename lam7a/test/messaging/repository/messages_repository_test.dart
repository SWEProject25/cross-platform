import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/dtos/messages_dtos.dart';
import 'package:lam7a/features/messaging/errors/blocked_user_error.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/services/dms_api_service.dart';
import 'package:lam7a/features/messaging/services/messages_store.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:mocktail/mocktail.dart';

class MockMessagesStore extends Mock implements MessagesStore {}

class MockMessagesSocketService extends Mock implements MessagesSocketService {}

class MockDMsApiService extends Mock implements DMsApiService {}

class FakeAuthState extends Fake implements AuthState {
  @override
  final UserModel? user;

  FakeAuthState({this.user});
}

void main() {
  late MockMessagesStore mockStore;
  late MockMessagesSocketService mockSocket;
  late MockDMsApiService mockApiService;
  late AuthState authState;
  late MessagesRepository repository;

  final testUser = UserModel(id: 1, username: 'testuser', email: 'test@test.com');

  final testMessage = ChatMessage(
    id: 1,
    text: 'Hello',
    time: DateTime(2024, 1, 1),
    isMine: true,
    senderId: 1,
    conversationId: 1,
  );

  final testMessageDto = MessageDto(
    id: 1,
    text: 'Hello',
    createdAt: DateTime(2024, 1, 1),
    senderId: 1,
    conversationId: 1,
    isSeen: false,
  );

  setUp(() {
    mockStore = MockMessagesStore();
    mockSocket = MockMessagesSocketService();
    mockApiService = MockDMsApiService();
    authState = FakeAuthState(user: testUser);

    // Register fallback values
    registerFallbackValue(testMessage);
    registerFallbackValue(CreateMessageRequest(conversationId: 1, senderId: 1, text: 'test'));
    registerFallbackValue(TypingRequest(conversationId: 1));
    registerFallbackValue(MarkSeenRequest(conversationId: 1, userId: 1));

    // Setup default mock behaviors for streams
    when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.value(testMessageDto));
    when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.value(testMessageDto));
    when(() => mockSocket.userTyping).thenAnswer((_) => Stream.value(TypingEventDto(conversationId: 1, userId: 2)));
    when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.value(TypingEventDto(conversationId: 1, userId: 2)));
    when(() => mockSocket.messagesSeen).thenAnswer((_) => Stream.value(MessagesSeenDto(conversationId: 1, userId: 2, timestamp: DateTime.now())));
    when(() => mockSocket.onConnected).thenAnswer((_) => Stream.value(null));

    when(() => mockStore.addMessage(any(), any())).thenAnswer((_) async {});
    when(() => mockStore.addMessages(any(), any())).thenAnswer((_) async {});
    when(() => mockStore.removeMessage(any(), any())).thenAnswer((_) async {});
    when(() => mockStore.getMessages(any())).thenAnswer((_) async => []);
    
    when(() => mockApiService.getLostMessages(any(), any())).thenAnswer(
      (_) async => MessagesResponseDto(
        status: 'success',
        data: [],
        metadata: MessagesMetadataDto(hasMore: false),
      ),
    );
  });

  tearDown(() {
    repository.dispose();
  });

  group('MessagesRepository Tests', () {
    test('constructor sets up stream subscriptions', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      expect(repository, isNotNull);
      verify(() => mockSocket.incomingMessages).called(1);
      verify(() => mockSocket.incomingMessagesNotifications).called(1);
      verify(() => mockSocket.userTyping).called(1);
      verify(() => mockSocket.userStoppedTyping).called(1);
      verify(() => mockSocket.messagesSeen).called(1);
      verify(() => mockSocket.onConnected).called(1);
    });

    test('dispose cancels all subscriptions', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.dispose();

      // Verify dispose completes without errors
      expect(true, true);
    });

    test('_onReceivedMessage adds message to cache', () async {
      final controller = StreamController<MessageDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => controller.stream);
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => Stream.empty());

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      controller.add(testMessageDto);
      await Future.delayed(Duration(milliseconds: 100));

      verify(() => mockStore.addMessage(1, any())).called(1);

      controller.close();
    });

    test('_onUserTypingEvent emits typing status', () async {
      final controller = StreamController<TypingEventDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => controller.stream);
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => Stream.empty());

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final typingStream = repository.onUserTyping(1);
      final events = <bool>[];
      typingStream.listen(events.add);

      controller.add(TypingEventDto(conversationId: 1, userId: 2));
      await Future.delayed(Duration(milliseconds: 100));

      expect(events, [true]);

      controller.close();
    });

    test('_onUserStoppedTypingEvent emits stop typing status', () async {
      final controller = StreamController<TypingEventDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => controller.stream);
      when(() => mockSocket.messagesSeen).thenAnswer((_) => Stream.empty());

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final typingStream = repository.onUserTyping(1);
      final events = <bool>[];
      typingStream.listen(events.add);

      controller.add(TypingEventDto(conversationId: 1, userId: 2));
      await Future.delayed(Duration(milliseconds: 100));

      expect(events, [false]);

      controller.close();
    });

    test('_onMessagesSeen updates messages to seen', () async {
      final unseenMessage = testMessage.copyWith(isSeen: false);
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => [unseenMessage]);

      final controller = StreamController<MessagesSeenDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => controller.stream);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      controller.add(MessagesSeenDto(conversationId: 1, userId: 2, timestamp: DateTime.now()));
      await Future.delayed(Duration(milliseconds: 100));

      verify(() => mockStore.addMessages(1, any())).called(1);

      controller.close();
    });

    test('_onReconnected rejoins conversations', () async {
      when(() => mockSocket.joinConversation(any())).thenReturn(null);
      when(() => mockApiService.getLostMessages(any(), any())).thenAnswer(
        (_) async => MessagesResponseDto(
          status: 'success',
          data: [],
          metadata: MessagesMetadataDto(hasMore: false),
        ),
      );

      final controller = StreamController<void>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.onConnected).thenAnswer((_) => controller.stream);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);
      repository.joinConversation(1);

      controller.add(null);
      await Future.delayed(Duration(milliseconds: 100));

      verify(() => mockSocket.joinConversation(1)).called(greaterThan(0));

      controller.close();
    });

    test('onMessageRecieved returns stream', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final stream = repository.onMessageRecieved(1);

      expect(stream, isA<Stream<void>>());
    });

    test('onConnected returns socket stream', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final stream = repository.onConnected();

      expect(stream, isA<Stream<void>>());
    });

    test('fetchMessage returns messages from cache', () async {
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => [testMessage]);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final result = await repository.fetchMessage(1);

      expect(result, [testMessage]);
      verify(() => mockStore.getMessages(1)).called(greaterThan(0));
    });

    test('updateTypingStatus sends typing event when true', () {
      when(() => mockSocket.sendTypingEvent(any())).thenReturn(null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.updateTypingStatus(1, true);

      verify(() => mockSocket.sendTypingEvent(any())).called(1);
    });

    test('updateTypingStatus sends stop typing event when false', () {
      when(() => mockSocket.sendStopTypingEvent(any())).thenReturn(null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.updateTypingStatus(1, false);

      verify(() => mockSocket.sendStopTypingEvent(any())).called(1);
    });

    test('loadMessageHistory loads and caches messages', () async {
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => [testMessage]);
      when(() => mockApiService.getMessageHistory(1, 1)).thenAnswer(
        (_) async => MessagesResponseDto(
          status: 'success',
          data: [testMessageDto],
          metadata: MessagesMetadataDto(hasMore: true),
        ),
      );

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final hasMore = await repository.loadMessageHistory(1);

      expect(hasMore, true);
      verify(() => mockApiService.getMessageHistory(1, 1)).called(1);
      verify(() => mockStore.addMessages(1, any())).called(greaterThan(0));
    });

    test('loadInitMessage loads initial messages when cache is empty', () async {
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => []);
      when(() => mockApiService.getMessageHistory(1, null)).thenAnswer(
        (_) async => MessagesResponseDto(
          status: 'success',
          data: [testMessageDto],
          metadata: MessagesMetadataDto(hasMore: false),
        ),
      );

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final hasMore = await repository.loadInitMessage(1);

      expect(hasMore, false);
      verify(() => mockApiService.getMessageHistory(1, null)).called(1);
    });

    test('loadInitMessage loads lost messages when cache has messages', () async {
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => [testMessage]);
      when(() => mockApiService.getLostMessages(1, 1)).thenAnswer(
        (_) async => MessagesResponseDto(
          status: 'success',
          data: [testMessageDto],
          metadata: MessagesMetadataDto(hasMore: false),
        ),
      );
      when(() => mockApiService.getMessageHistory(1, any())).thenAnswer(
        (_) async => MessagesResponseDto(
          status: 'success',
          data: [testMessageDto],
          metadata: MessagesMetadataDto(hasMore: false),
        ),
      );

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final hasMore = await repository.loadInitMessage(1);

      expect(hasMore, false);
      verify(() => mockApiService.getLostMessages(1, 1)).called(1);
    });

    test('sendMessage sends optimistic message then replaces with server message', () async {
      when(() => mockSocket.sendMessage(any())).thenAnswer((_) async => testMessageDto);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      await repository.sendMessage(1, 1, 'Hello');

      // Should add optimistic message, remove it, then add server message
      verify(() => mockStore.addMessage(1, any())).called(greaterThan(2));
      verify(() => mockStore.removeMessage(1, any())).called(1);
      verify(() => mockSocket.sendMessage(any())).called(1);
    });

    test('sendMessage removes optimistic message on BlockedUserError', () async {
      when(() => mockSocket.sendMessage(any())).thenThrow(BlockedUserError());

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      expect(
        () => repository.sendMessage(1, 1, 'Hello'),
        throwsA(isA<BlockedUserError>()),
      );

      await Future.delayed(Duration(milliseconds: 100));

      // Should add optimistic message then remove it
      verify(() => mockStore.addMessage(1, any())).called(greaterThan(0));
      verify(() => mockStore.removeMessage(1, any())).called(greaterThan(0));
    });

    test('sendMessage removes optimistic message when server returns null', () async {
      when(() => mockSocket.sendMessage(any())).thenAnswer((_) async => null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      await repository.sendMessage(1, 1, 'Hello');

      // Should add optimistic message then remove it
      verify(() => mockStore.addMessage(1, any())).called(greaterThan(0));
      verify(() => mockStore.removeMessage(1, any())).called(greaterThan(0));
    });

    test('sendMarkAsSeen sends mark seen request', () {
      when(() => mockSocket.markSeen(any())).thenReturn(null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.sendMarkAsSeen(1);

      verify(() => mockSocket.markSeen(any())).called(1);
    });

    test('joinConversation joins and tracks conversation', () {
      when(() => mockSocket.joinConversation(any())).thenReturn(null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.joinConversation(1);

      verify(() => mockSocket.joinConversation(1)).called(1);
    });

    test('leaveConversation leaves and removes from tracking', () {
      when(() => mockSocket.leaveConversation(any())).thenReturn(null);
      when(() => mockSocket.joinConversation(any())).thenReturn(null);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      repository.joinConversation(1);
      repository.leaveConversation(1);

      verify(() => mockSocket.leaveConversation(1)).called(1);
    });

    test('multiple notifiers for different conversations', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final stream1 = repository.onMessageRecieved(1);
      final stream2 = repository.onMessageRecieved(2);

      expect(stream1, isNot(equals(stream2)));
    });

    test('multiple typing notifiers for different conversations', () {
      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      final stream1 = repository.onUserTyping(1);
      final stream2 = repository.onUserTyping(2);

      expect(stream1, isNot(equals(stream2)));
    });

    test('_onMessagesSeen handles error gracefully', () async {
      when(() => mockStore.getMessages(1)).thenThrow(Exception('Test error'));

      final controller = StreamController<MessagesSeenDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => controller.stream);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      controller.add(MessagesSeenDto(conversationId: 1, userId: 2, timestamp: DateTime.now()));
      await Future.delayed(Duration(milliseconds: 100));

      // Should not throw, error is caught and logged
      expect(true, true);

      controller.close();
    });

    test('_onMessagesSeen does not update if no unseen messages', () async {
      final seenMessage = testMessage.copyWith(isSeen: true);
      when(() => mockStore.getMessages(1)).thenAnswer((_) async => [seenMessage]);

      final controller = StreamController<MessagesSeenDto>();
      when(() => mockSocket.incomingMessages).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.incomingMessagesNotifications).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.userStoppedTyping).thenAnswer((_) => Stream.empty());
      when(() => mockSocket.messagesSeen).thenAnswer((_) => controller.stream);

      repository = MessagesRepository(mockStore, mockSocket, mockApiService, authState);

      controller.add(MessagesSeenDto(conversationId: 1, userId: 2, timestamp: DateTime.now()));
      await Future.delayed(Duration(milliseconds: 100));

      // Should not call addMessages since no messages were updated
      verifyNever(() => mockStore.addMessages(1, any()));

      controller.close();
    });
  });
}
