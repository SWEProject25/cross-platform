import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/ui/state/conversation_state.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

import 'chat_viewmodel_simple_test.dart';

class MockConversationsRepository extends Mock implements ConversationsRepository {}
class MockMessagesSocketService extends Mock implements MessagesSocketService {}
class MockMessagesRepository extends Mock implements MessagesRepository {}
class MockConversationViewmodel extends Notifier<ConversationState> with Mock implements ConversationViewmodel {
  @override
  ConversationState build([int? conversationId]) {
    return ConversationState();
  }
}

class FakeConversation extends Fake implements Conversation {}
class FakeMessageDto extends Fake implements MessageDto {}

void main() {
  final testUser = UserModel(
    id: 1,
    name: 'Current User',
    username: '@currentuser',
  );

  final testConversation = Conversation(
    id: 1,
    name: 'Test User',
    userId: 2,
    username: '@testuser',
    unseenCount: 0,
    isBlocked: false,
    lastMessage: 'Hello',
    lastMessageTime: DateTime(2025, 1, 1),
  );

  final testConversation2 = Conversation(
    id: 2,
    name: 'Test User 2',
    userId: 3,
    username: '@testuser2',
    unseenCount: 0,
    isBlocked: false,
    lastMessage: 'Hi there',
    lastMessageTime: DateTime(2025, 1, 2),
  );

  final testContact = Contact(
    id: 4,
    name: 'New User',
    handle: '@newuser',
  );

  setUpAll(() {
      registerFallbackValue(FakeConversation());
      registerFallbackValue(FakeMessageDto());
  });


  group('ConversationsViewmodel Tests', () {
    test('initializes and subscribes to message streams', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => (<Conversation>[], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockSocket.incomingMessages).called(1);
      verify(() => mockSocket.incomingMessagesNotifications).called(1);
      verify(() => mockRepository.fetchConversations()).called(1);

      container.dispose();
    });

    test('onNewMessageReceived updates existing conversation when message is from other user', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<MessageDto>();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([testConversation], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final message = MessageDto(
        id: 1,
        conversationId: 1,
        senderId: 2,
        text: 'Updated message',
        createdAt: DateTime(2025, 1, 3),
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(conversationsViewmodel);
      expect(state.items.length, 1);
      expect(state.items[0].lastMessage, 'Updated message');
      expect(state.items[0].lastMessageTime, DateTime(2025, 1, 3));

      messageController.close();
      container.dispose();
    });

    test('onNewMessageReceived returns early when message is from current user', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<MessageDto>();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([testConversation], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final message = MessageDto(
        id: 1,
        conversationId: 1,
        senderId: 1, // Same as current user
        text: 'My message',
        createdAt: DateTime(2025, 1, 3),
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(conversationsViewmodel);
      expect(state.items.length, 1);
      expect(state.items[0].lastMessage, 'Hello'); // Not updated
      expect(state.items[0].lastMessageTime, DateTime(2025, 1, 1)); // Not updated

      messageController.close();
      container.dispose();
    });

    test('onNewMessageReceived adds new conversation when not found', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<MessageDto>();
      final mockMessagesRepository = MockMessagesRepository();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([testConversation], false));
      when(() => mockRepository.getContactByUserId(4))
          .thenAnswer((_) async => testContact);
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(3).overrideWith(() => mockConversationViewmodel),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final message = MessageDto(
        id: 1,
        conversationId: 3,
        senderId: 4,
        text: 'New conversation',
        createdAt: DateTime(2025, 1, 4),
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockRepository.getContactByUserId(4)).called(1);
      verify(() => mockConversationViewmodel.setConversation(any())).called(greaterThanOrEqualTo(1));

      messageController.close();
      container.dispose();
    });

    test('onNewMessageReceived from notifications stream updates conversation', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final notificationController = StreamController<MessageDto>();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([testConversation], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => notificationController.stream);
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final message = MessageDto(
        id: 1,
        conversationId: 1,
        senderId: 2,
        text: 'Notification message',
        createdAt: DateTime(2025, 1, 5),
      );

      notificationController.add(message);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(conversationsViewmodel);
      expect(state.items.length, 1);
      expect(state.items[0].lastMessage, 'Notification message');
      expect(state.items[0].lastMessageTime, DateTime(2025, 1, 5));

      notificationController.close();
      container.dispose();
    });

    test('fetchPage returns conversations and calls setConversation', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final mockConversationViewmodel2 = MockConversationViewmodel();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([testConversation, testConversation2], true));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.userTyping)
          .thenAnswer((_) => Stream<TypingEventDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);
      when(() => mockConversationViewmodel2.setConversation(any())).thenReturn(null);
      when(() => mockRepository.getContactByUserId(any()))
          .thenAnswer((_) async => testContact);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
          conversationViewmodelProvider(2).overrideWith(() => mockConversationViewmodel2),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(conversationsViewmodel);
      print(state.error);
      expect(state.items.length, 2);
      expect(state.hasMore, true);

      verify(() => mockConversationViewmodel.setConversation(any())).called(1);
      verify(() => mockConversationViewmodel2.setConversation(any())).called(1);

      container.dispose();
    });

    test('mergeList removes duplicates and sorts by lastMessageTime', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => (<Conversation>[], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
          conversationViewmodelProvider(2).overrideWith(() => mockConversationViewmodel),
          conversationViewmodelProvider(3).overrideWith(() => mockConversationViewmodel),
        ],
      );

      final viewModel = container.listen(conversationsViewmodel.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final conv1 = testConversation.copyWith(lastMessageTime: DateTime(2025, 1, 1));
      final conv2 = testConversation2.copyWith(lastMessageTime: DateTime(2025, 1, 3));
      final conv3 = testConversation.copyWith(lastMessageTime: DateTime(2025, 1, 2)); // Duplicate ID

      final list1 = [conv1, conv2];
      final list2 = [conv3];

      final merged = viewModel.mergeList(list1, list2);

      expect(merged.length, 2); // Duplicate removed
      expect(merged[0].id, 2); // Sorted by time, newest first
      expect(merged[0].lastMessageTime, DateTime(2025, 1, 3));
      expect(merged[1].id, 1);
      expect(merged[1].lastMessageTime, DateTime(2025, 1, 2)); // Updated time

      container.dispose();
    });

    test('mergeList handles conversations with null lastMessageTime', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => (<Conversation>[], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
        ],
      );

      final viewModel = container.listen(conversationsViewmodel.notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      final conv1 = testConversation.copyWith(lastMessageTime: null);
      final conv2 = testConversation2.copyWith(lastMessageTime: DateTime(2025, 1, 3));

      final list1 = [conv1];
      final list2 = [conv2];

      final merged = viewModel.mergeList(list1, list2);

      expect(merged.length, 2);
      expect(merged[0].id, 2); // Has time, so it's first
      expect(merged[1].id, 1); // Null time, so it's last

      container.dispose();
    });

    test('onNewMessageReceived sorts conversations after update', () async {
      final mockRepository = MockConversationsRepository();
      final mockSocket = MockMessagesSocketService();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<MessageDto>();
      final mockMessagesRepository = MockMessagesRepository();

      final oldConv = testConversation.copyWith(
        id: 1,
        lastMessageTime: DateTime(2025, 1, 1),
      );
      final newerConv = testConversation2.copyWith(
        id: 2,
        lastMessageTime: DateTime(2025, 1, 2),
      );

      when(() => mockRepository.fetchConversations())
          .thenAnswer((_) async => ([oldConv, newerConv], false));
      when(() => mockSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockConversationViewmodel.setConversation(any())).thenReturn(null);
      when(() => mockRepository.getContactByUserId(any()))
          .thenAnswer((_) async => testContact);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepository),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
        ],
      );

      container.listen(conversationsViewmodel, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 100));

      // Send message to conversation 1 with newer time
      final message = MessageDto(
        id: 1,
        conversationId: 1,
        senderId: 2,
        text: 'Newest message',
        createdAt: DateTime(2025, 1, 5),
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(conversationsViewmodel);
      expect(state.items[0].id, 1); // Now first because it has newest message
      expect(state.items[0].lastMessageTime, DateTime(2025, 1, 5));
      expect(state.items[1].id, 2); // Now second

      messageController.close();
      container.dispose();
    });
  });
}
