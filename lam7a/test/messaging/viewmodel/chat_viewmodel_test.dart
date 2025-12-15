import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/errors/blocked_user_error.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/state/conversation_state.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationsRepository extends Mock implements ConversationsRepository {}
class MockMessagesRepository extends Mock implements MessagesRepository {}
class MockConversationViewmodel extends Mock implements ConversationViewmodel {}

void main() {
  late MockConversationsRepository mockConversationsRepository;
  late MockMessagesRepository mockMessagesRepository;
  late ProviderContainer container;

  final testContact = Contact(
    id: 1,
    name: 'Test User',
    handle: '@testuser',
    avatarUrl: 'https://example.com/avatar.jpg',
  );

  final testConversation = Conversation(
    id: 1,
    name: 'Test User',
    userId: 1,
    username: '@testuser',
    avatarUrl: 'https://example.com/avatar.jpg',
    lastMessage: 'Hello',
    lastMessageTime: DateTime(2025, 1, 1),
    unseenCount: 0,
    isBlocked: false,
  );

  final testMessages = [
    ChatMessage(
      id: 1,
      text: 'Hello',
      time: DateTime(2025, 1, 1),
      isMine: false,
      senderId: 1,
    ),
    ChatMessage(
      id: 2,
      text: 'Hi there',
      time: DateTime(2025, 1, 1, 0, 1),
      isMine: true,
      senderId: 2,
    ),
  ];

  final testUser = UserModel(
    id: 2,
    name: 'Current User',
    username: '@currentuser',
    email: 'test@example.com',
    birthDate: '2000-01-01',
  );

  setUp(() {
    mockConversationsRepository = MockConversationsRepository();
    mockMessagesRepository = MockMessagesRepository();

    // Setup default mocks
    when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer(
      (_) => Stream<void>.empty(),
    );
    when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer(
      (_) => Stream<bool>.empty(),
    );
    when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
    when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
    when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
    when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer(
      (_) async => testContact,
    );
    when(() => mockConversationsRepository.getConversationById(any())).thenAnswer(
      (_) async => testConversation,
    );
    when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer(
      (_) async => testMessages,
    );
    when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer(
      (_) async => true,
    );

    container = ProviderContainer(
      overrides: [
        conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
        messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
        authenticationProvider.overrideWith(() {
          return Authentication()..state = AuthState(user: testUser, isAuthenticated: true);
        }),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ChatViewModel', () {
    test('initializes successfully with authenticated user', () async {
      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));

      expect(state, isNotNull);
      expect(viewModel, isNotNull);
    });

    test('throws exception when user not authenticated', () {
      final unauthContainer = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          authenticationProvider.overrideWith(() {
            return Authentication()..state = const AuthState(user: null, isAuthenticated: false);
          }),
        ],
      );

      expect(
        () => unauthContainer.read(chatViewModelProvider(userId: 1, conversationId: 1)),
        throwsException,
      );

      unauthContainer.dispose();
    });

    test('loads contact, conversation, and messages on init', () async {
      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));

      expect(state.contact.hasValue, true);
      expect(state.contact.value, testContact);
      expect(state.conversation.hasValue, true);
      expect(state.messages.hasValue, true);
      expect(state.messages.value, testMessages);

      verify(() => mockConversationsRepository.getContactByUserId(1)).called(1);
      verify(() => mockMessagesRepository.fetchMessage(1)).called(1);
    });

    test('handles contact loading error', () async {
      when(() => mockConversationsRepository.getContactByUserId(any()))
          .thenThrow(Exception('Failed to load contact'));

      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));

      expect(state.contact.hasError, true);
    });

    test('handles messages loading error', () async {
      when(() => mockMessagesRepository.fetchMessage(any()))
          .thenThrow(Exception('Failed to load messages'));

      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));

      expect(state.messages.hasError, true);
    });

    test('updates draft message and triggers typing status', () async {
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      viewModel.updateDraftMessage('Hello world');

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, 'Hello world');

      verify(() => mockMessagesRepository.updateTypingStatus(1, true)).called(1);
    });

    test('truncates draft message to 1000 characters', () async {
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      final longMessage = 'a' * 1500;
      viewModel.updateDraftMessage(longMessage);

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage.length, 1000);
    });

    test('sends message successfully', () async {
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any())).thenAnswer((_) async => {});

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      viewModel.updateDraftMessage('Test message');
      await viewModel.sendMessage();

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, '');

      verify(() => mockMessagesRepository.sendMessage(2, 1, 'Test message')).called(1);
      verify(() => mockMessagesRepository.updateTypingStatus(1, false)).called(1);
    });

    test('handles blocked user error when sending message', () async {
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any()))
          .thenThrow(BlockedUserError());

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      viewModel.updateDraftMessage('Test message');
      await viewModel.sendMessage();

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.conversation.value?.isBlocked, true);
    });

    test('handles generic error when sending message', () async {
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any()))
          .thenThrow(Exception('Network error'));

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      viewModel.updateDraftMessage('Test message');
      await viewModel.sendMessage();

      // Should complete without throwing
      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, '');
    });

    test('handles new messages arriving', () async {
      final messageController = StreamController<void>();
      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer(
        (_) => messageController.stream,
      );

      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      messageController.add(null);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockMessagesRepository.fetchMessage(1)).called(greaterThan(1));
      verify(() => mockMessagesRepository.sendMarkAsSeen(1)).called(greaterThan(1));

      messageController.close();
    });

    test('handles user typing status', () async {
      final typingController = StreamController<bool>();
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer(
        (_) => typingController.stream,
      );

      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));

      var state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, true);

      typingController.add(false);
      await Future.delayed(const Duration(milliseconds: 100));

      state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, false);

      typingController.close();
    });

    test('ignores typing status when conversation is blocked', () async {
      final blockedConversation = testConversation.copyWith(isBlocked: true);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer(
        (_) async => blockedConversation,
      );

      final typingController = StreamController<bool>();
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer(
        (_) => typingController.stream,
      );

      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, false);

      typingController.close();
    });

    test('loads initial messages successfully', () async {
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.requestInitMessages();

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.hasMoreMessages, true);
      expect(state.loadingMoreMessages, false);

      verify(() => mockMessagesRepository.loadInitMessage(1)).called(greaterThan(0));
    });

    test('loads more messages successfully', () async {
      when(() => mockMessagesRepository.loadMessageHistory(any())).thenAnswer((_) async => false);

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.loadMoreMessages();

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.hasMoreMessages, false);

      verify(() => mockMessagesRepository.loadMessageHistory(1)).called(1);
    });

    test('does not load more messages when already loading', () async {
      when(() => mockMessagesRepository.loadMessageHistory(any())).thenAnswer(
        (_) async {
          await Future.delayed(const Duration(milliseconds: 500));
          return false;
        },
      );

      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      // Start loading
      viewModel.loadMoreMessages();
      await Future.delayed(const Duration(milliseconds: 50));

      // Try to load again while already loading
      await viewModel.loadMoreMessages();

      verify(() => mockMessagesRepository.loadMessageHistory(1)).called(1);
    });

    test('does not load more messages when no more available', () async {
      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      // Set hasMoreMessages to false
      await viewModel.loadMoreMessages();
      await viewModel.loadMoreMessages();

      verify(() => mockMessagesRepository.loadMessageHistory(1)).called(1);
    });

    test('refreshes messages', () async {
      final viewModel = container.read(chatViewModelProvider(userId: 1, conversationId: 1).notifier);
      await Future.delayed(const Duration(milliseconds: 100));

      await viewModel.refresh();

      verify(() => mockMessagesRepository.fetchMessage(1)).called(greaterThan(1));
    });

    test('disposes resources properly', () async {
      container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      container.dispose();

      verify(() => mockMessagesRepository.leaveConversation(1)).called(1);
    });

    test('uses existing conversation from conversation viewmodel', () async {
      final mockConvViewmodel = MockConversationViewmodel();
      when(() => mockConvViewmodel.state).thenReturn(
        ConversationState(conversation: testConversation),
      );
      when(() => mockConvViewmodel.markConversationAsSeen()).thenReturn(null);
      when(() => mockConvViewmodel.setConversation(any())).thenReturn(null);

      final convContainer = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          authenticationProvider.overrideWith(() {
            return Authentication()..state = AuthState(user: testUser, isAuthenticated: true);
          }),
          conversationViewmodelProvider(1).overrideWith(() => mockConvViewmodel),
        ],
      );

      convContainer.read(chatViewModelProvider(userId: 1, conversationId: 1));
      await Future.delayed(const Duration(milliseconds: 100));

      final state = convContainer.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.conversation.hasValue, true);

      convContainer.dispose();
    });
  });
}
