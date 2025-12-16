import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/dtos/message_socket_dtos.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/providers/unread_conversations_count.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockMessagesRepository extends Mock implements MessagesRepository {}
class MockMessagesSocketService extends Mock implements MessagesSocketService {}
class MockUnReadConversationsCount extends Notifier<int> with Mock implements UnReadConversationsCount {
  @override
  int build() => 0;
}

void main() {
  final testConversation = Conversation(
    id: 1,
    name: 'Test User',
    userId: 1,
    username: '@testuser',
    unseenCount: 5,
    isBlocked: false,
  );

  group('ConversationViewmodel Tests', () {
    test('initializes and subscribes to streams', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final state = container.read(conversationViewmodelProvider(1));
      
      expect(state.isTyping, false);
      expect(state.conversation, null);

      verify(() => mockMessagesRepository.onUserTyping(1)).called(1);
      verify(() => mockMessagesSocket.incomingMessages).called(1);
      verify(() => mockMessagesSocket.incomingMessagesNotifications).called(1);

      container.dispose();
    });

    test('handles error when subscribing to typing events', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenThrow(Exception('Subscription error'));
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final state = container.read(conversationViewmodelProvider(1));
      
      expect(state.isTyping, false);

      container.dispose();
    });

    test('onNewMessagesArrive updates state when message matches conversation', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final messageController = StreamController<MessageDto>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      final message = MessageDto(
        id: 1,
        conversationId: 1,
        text: 'Hello',
        createdAt: DateTime(2025, 1, 1),
        unseenCount: 3,
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.lastMessage, 'Hello');
      expect(state.lastMessageTime, DateTime(2025, 1, 1));
      expect(state.unseenCount, 3);

      messageController.close();
      container.dispose();
    });

    test('onNewMessagesArrive ignores message from different conversation', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final messageController = StreamController<MessageDto>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      final message = MessageDto(
        id: 1,
        conversationId: 2,
        text: 'Hello',
        createdAt: DateTime(2025, 1, 1),
        unseenCount: 3,
      );

      messageController.add(message);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.lastMessage, null);
      expect(state.lastMessageTime, null);
      expect(state.unseenCount, null);

      messageController.close();
      container.dispose();
    });

    test('onNewMessagesArrive from notifications stream updates state', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final notificationController = StreamController<MessageDto>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => notificationController.stream);

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      final message = MessageDto(
        id: 1,
        conversationId: 1,
        text: 'Notification message',
        createdAt: DateTime(2025, 1, 2),
        unseenCount: 2,
      );

      notificationController.add(message);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.lastMessage, 'Notification message');
      expect(state.lastMessageTime, DateTime(2025, 1, 2));
      expect(state.unseenCount, 2);

      notificationController.close();
      container.dispose();
    });

    test('onUserTypingChanged sets isTyping to true', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, true);

      typingController.close();
      container.dispose();
    });

    test('onUserTypingChanged sets isTyping to false', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));
      typingController.add(false);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('typing timer expires after 3 seconds', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, true);

      await Future.delayed(const Duration(seconds: 4));

      state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('typing timer is cancelled when typing again', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));
      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));

      var state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, true);

      typingController.close();
      container.dispose();
    });

    test('typing ignored when conversation is blocked', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      viewModel.setConversation(testConversation.copyWith(isBlocked: true));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('setConversation updates conversation state', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      viewModel.setConversation(testConversation);

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.conversation, testConversation);

      container.dispose();
    });

    test('markConversationAsSeen sends mark and refreshes count', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockUnreadCount.refresh()).thenAnswer((_) async => null);

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      viewModel.markConversationAsSeen();

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.unseenCount, 0);

      verify(() => mockMessagesRepository.sendMarkAsSeen(1)).called(1);
      verify(() => mockUnreadCount.refresh()).called(1);

      container.dispose();
    });

    test('setConversationBlocked updates conversation blocked status', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      viewModel.setConversation(testConversation);
      viewModel.setConversationBlocked(true);

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.conversation?.isBlocked, true);

      container.dispose();
    });

    test('setConversationBlocked does nothing when conversation is null', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      viewModel.setConversationBlocked(true);

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.conversation, null);

      container.dispose();
    });

    test('handles typing stream error', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => typingController.stream);
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => Stream<MessageDto>.empty());
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      container.read(conversationViewmodelProvider(1));

      typingController.addError(Exception('Stream error'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('onNewMessagesArrive preserves existing values when message fields are null', () async {
      final mockMessagesRepository = MockMessagesRepository();
      final mockMessagesSocket = MockMessagesSocketService();
      final mockUnreadCount = MockUnReadConversationsCount();
      final messageController = StreamController<MessageDto>();

      when(() => mockMessagesRepository.onUserTyping(any()))
          .thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesSocket.incomingMessages)
          .thenAnswer((_) => messageController.stream);
      when(() => mockMessagesSocket.incomingMessagesNotifications)
          .thenAnswer((_) => Stream<MessageDto>.empty());

      final container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          messagesSocketServiceProvider.overrideWithValue(mockMessagesSocket),
          unReadConversationsCountProvider.overrideWith(() => mockUnreadCount),
        ],
      );

      final viewModel = container.read(conversationViewmodelProvider(1).notifier);
      
      // Set initial state
      final initialMessage = MessageDto(
        id: 1,
        conversationId: 1,
        text: 'Initial message',
        createdAt: DateTime(2025, 1, 1),
        unseenCount: 5,
      );
      messageController.add(initialMessage);
      await Future.delayed(const Duration(milliseconds: 50));

      // Send message with null values
      final nullMessage = MessageDto(
        id: 2,
        conversationId: 1,
        text: null,
        createdAt: null,
        unseenCount: null,
      );
      messageController.add(nullMessage);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(conversationViewmodelProvider(1));
      expect(state.lastMessage, 'Initial message');
      expect(state.lastMessageTime, DateTime(2025, 1, 1));
      expect(state.unseenCount, 5);

      messageController.close();
      container.dispose();
    });
  });
}
