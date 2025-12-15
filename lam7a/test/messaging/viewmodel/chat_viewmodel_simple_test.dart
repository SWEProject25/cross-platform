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
class MockConversationViewmodel extends Notifier<ConversationState> with Mock implements ConversationViewmodel {
  ConversationState initState;
  MockConversationViewmodel({this.initState = const ConversationState()});
  @override
  ConversationState build([int? conversationId]) {
    // Return a default or mock ConversationState as needed for your tests
    return initState;
  }


  void setState(ConversationState newState) {
    state = newState;
  }
}

void main() {
  final testContact = Contact(
    id: 1,
    name: 'Test User',
    handle: '@testuser',
  );

  final testConversation = Conversation(
    id: 1,
    name: 'Test User',
    userId: 1,
    username: '@testuser',
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
  ];

  final testUser = UserModel(
    id: 2,
    name: 'Current User',
    username: '@currentuser',
  );

  group('ChatViewModel Basic Tests', () {
    test('throws exception when user not authenticated', () {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWith(() => Authentication()),
        ],
      );

      expect(
        () => container.read(chatViewModelProvider(userId: 1, conversationId: 1)),
        throwsException,
      );

      container.dispose();
    });

    test('updates draft message', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('Hello world');
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, 'Hello world');

      container.dispose();
    });

    test('truncates long draft message', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockConversationsRepository.getAllUnseenConversations()).thenAnswer((_) async => 1);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      final longMessage = 'a' * 1500;
      viewModel.updateDraftMessage(longMessage);
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage.length, 1000);

      container.dispose();
    });

    test('sends message successfully', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any())).thenAnswer((_) async => {});
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('Test message');
      await Future.delayed(const Duration(milliseconds: 50));
      await viewModel.sendMessage();
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, '');

      verify(() => mockMessagesRepository.sendMessage(2, 1, 'Test message')).called(1);

      container.dispose();
    });

    test('handles blocked user error', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any())).thenThrow(BlockedUserError());
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('Test message');
      await Future.delayed(const Duration(milliseconds: 50));
      await viewModel.sendMessage();
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.conversation.value?.isBlocked, true);

      container.dispose();
    });

    test('handles typing status changes', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => typingController.stream);
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, true);

      typingController.add(false);
      await Future.delayed(const Duration(milliseconds: 50));

      state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('uses existing conversation from conversationViewmodel', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel(initState: ConversationState(conversation: testConversation));


      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);
      // when(() => mockConversationViewmodel.state).thenReturn(ConversationState(conversation: testConversation));

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.conversation.value, testConversation);
      verifyNever(() => mockConversationsRepository.getConversationById(any()));

      container.dispose();
    });

    test('handles error when loading contact', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenThrow(Exception('Contact not found'));
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.contact.hasError, true);
      expect(state.contact.error.toString(), contains('Contact not found'));

      container.dispose();
    });

    test('handles new messages arrival', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<void>();

      final newMessages = [
        ChatMessage(id: 1, text: 'Hello', time: DateTime(2025, 1, 1), isMine: false, senderId: 1),
        ChatMessage(id: 2, text: 'New message', time: DateTime(2025, 1, 2), isMine: false, senderId: 1),
      ];

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => messageController.stream);
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => newMessages);
      messageController.add(null);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockMessagesRepository.sendMarkAsSeen(1)).called(greaterThanOrEqualTo(2));
      verify(() => mockConversationViewmodel.markConversationAsSeen()).called(greaterThanOrEqualTo(2));

      messageController.close();
      container.dispose();
    });

    test('cancels typing timer when typing again', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('First');
      await Future.delayed(const Duration(milliseconds: 100));
      viewModel.updateDraftMessage('First update');
      await Future.delayed(const Duration(milliseconds: 100));

      verify(() => mockMessagesRepository.updateTypingStatus(1, true)).called(greaterThanOrEqualTo(2));

      container.dispose();
    });

    test('typing timer expires after 3 seconds', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('Test');
      await Future.delayed(const Duration(seconds: 4));

      verify(() => mockMessagesRepository.updateTypingStatus(1, false)).called(1);

      container.dispose();
    });

    test('other user typing timer expires after 5 seconds', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => typingController.stream);
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 50));

      var state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, true);

      await Future.delayed(const Duration(seconds: 6));

      state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, false);

      typingController.close();
      container.dispose();
    });

    test('cancels other typing timer when typing again', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();
      final typingController = StreamController<bool>();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => typingController.stream);
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));
      typingController.add(true);
      await Future.delayed(const Duration(milliseconds: 100));

      var state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.isTyping, true);

      typingController.close();
      container.dispose();
    });

    test('handles error when initially loading messages', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenThrow(Exception('Failed to load messages'));
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.messages.hasError, true);
      expect(state.messages.error.toString(), contains('Failed to load messages'));

      container.dispose();
    });

    test('handles error when refreshing messages', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();
      final messageController = StreamController<void>();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => messageController.stream);
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      when(() => mockMessagesRepository.fetchMessage(any())).thenThrow(Exception('Network error'));
      messageController.add(null);
      await Future.delayed(const Duration(milliseconds: 100));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.messages.hasError, true);
      expect(state.messages.error.toString(), contains('Network error'));

      messageController.close();
      container.dispose();
    });

    test('handles generic error when sending message', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.updateTypingStatus(any(), any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMessage(any(), any(), any())).thenThrow(Exception('Send failed'));
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.updateDraftMessage('Test message');
      await Future.delayed(const Duration(milliseconds: 50));
      await viewModel.sendMessage();
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.draftMessage, '');

      container.dispose();
    });

    test('loadMoreMessages returns early when already loading', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.loadMessageHistory(any())).thenAnswer((_) async {
        await Future.delayed(const Duration(milliseconds: 500));
        return true;
      });
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      viewModel.loadMoreMessages();
      await Future.delayed(const Duration(milliseconds: 50));
      await viewModel.loadMoreMessages();

      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockMessagesRepository.loadMessageHistory(1)).called(1);

      container.dispose();
    });

    test('loadMoreMessages returns early when no more messages', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => false);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      await viewModel.loadMoreMessages();

      verifyNever(() => mockMessagesRepository.loadMessageHistory(any()));

      container.dispose();
    });

    test('loadMoreMessages loads messages successfully', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockMessagesRepository.loadMessageHistory(any())).thenAnswer((_) async => false);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      await viewModel.loadMoreMessages();
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.loadingMoreMessages, false);
      expect(state.hasMoreMessages, false);

      verify(() => mockMessagesRepository.loadMessageHistory(1)).called(1);

      container.dispose();
    });

    test('refresh calls _loadMessages', () async {
      final mockConversationsRepository = MockConversationsRepository();
      final mockMessagesRepository = MockMessagesRepository();
      final mockConversationViewmodel = MockConversationViewmodel();

      when(() => mockMessagesRepository.onMessageRecieved(any())).thenAnswer((_) => Stream<void>.empty());
      when(() => mockMessagesRepository.onUserTyping(any())).thenAnswer((_) => Stream<bool>.empty());
      when(() => mockMessagesRepository.joinConversation(any())).thenReturn(null);
      when(() => mockMessagesRepository.sendMarkAsSeen(any())).thenReturn(null);
      when(() => mockMessagesRepository.leaveConversation(any())).thenReturn(null);
      when(() => mockConversationsRepository.getContactByUserId(any())).thenAnswer((_) async => testContact);
      when(() => mockConversationsRepository.getConversationById(any())).thenAnswer((_) async => testConversation);
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => testMessages);
      when(() => mockMessagesRepository.loadInitMessage(any())).thenAnswer((_) async => true);
      when(() => mockConversationViewmodel.markConversationAsSeen()).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationViewmodelProvider(1).overrideWith(() => mockConversationViewmodel,),
          authenticationProvider.overrideWithValue(AuthState(user: testUser, isAuthenticated: true)),
        ],
      );

      final viewModel = container.listen(chatViewModelProvider(userId: 1, conversationId: 1).notifier, (_, __) {}).read();
      await Future.delayed(const Duration(milliseconds: 200));

      final newMessages = [
        ChatMessage(id: 3, text: 'Refreshed', time: DateTime(2025, 1, 3), isMine: false, senderId: 1),
      ];
      when(() => mockMessagesRepository.fetchMessage(any())).thenAnswer((_) async => newMessages);

      await viewModel.refresh();
      await Future.delayed(const Duration(milliseconds: 50));

      final state = container.read(chatViewModelProvider(userId: 1, conversationId: 1));
      expect(state.messages.value, newMessages);

      container.dispose();
    });
  });
}
