import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';

/// ---- MOCKS ----
class MockMessagesRepository extends Mock implements MessagesRepository {}

class MockConversationsRepository extends Mock implements ConversationsRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockMessagesRepository mockMessagesRepository;
  late MockConversationsRepository mockConversationsRepository;

  setUp(() {
    mockMessagesRepository = MockMessagesRepository();
    mockConversationsRepository = MockConversationsRepository();

    // default stubs that most tests will reuse
    when(() => mockMessagesRepository.onMessageRecieved(any()))
        .thenAnswer((_) => Stream<void>.value(null));
    when(() => mockMessagesRepository.onUserTyping(any()))
        .thenAnswer((_) => Stream<bool>.value(false));
    when(() => mockMessagesRepository.fetchMessage(any()))
        .thenAnswer((_) => <ChatMessage>[]);
    when(() => mockMessagesRepository.joinConversation(any()))
        .thenReturn(null);
    when(() => mockMessagesRepository.sendMarkAsSeen(any()))
        .thenReturn(null);
    when(() => mockMessagesRepository.updateTypingStatus(any(), any()))
        .thenReturn(null);
    when(() => mockMessagesRepository.sendMessage(any(), any(), any()))
        .thenReturn(null);
    when(() => mockMessagesRepository.loadMessageHistory(any()))
        .thenAnswer((_) async => false);


    when(() => mockConversationsRepository.getConversationIdByUserId(any()))
        .thenAnswer((_) async => 1);
    when(() => mockConversationsRepository.getContactByUserId(any()))
        .thenAnswer((_) async => Contact(name: "dsf", id: 10, handle: "Test User", avatarUrl: null));



    // Provide mocks to the provider container
    container = ProviderContainer(
      overrides: [
        messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
        conversationsRepositoryProvider
            .overrideWithValue(mockConversationsRepository),
        // keep authenticationProvider default if available; if tests need
        // specific user id, override it here with a simple AuthState:
        authenticationProvider.overrideWithValue(
          const AuthState(
            isAuthenticated: true,
            user: null, // leave null unless testing sendMessage which needs user
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('build sets conversationId when provided and loads messages/contact streams', () async {
    // Arrange: provide explicit conversationId so build won't call getConversationIdByUserId
    final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

    // Wait a tick for microtasks triggered by build to run
    await Future<void>.delayed(const Duration(milliseconds: 10));

    // Act: read state
    final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));

    // Assert: basic state fields set (conversationId and messages)
    expect(state.conversationId, equals(1));
    expect(state.messages, isA<AsyncValue>());
  });

  test('updateDraftMessage updates draft and calls updateTypingStatus', () async {
    final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

    // Act
    notifier.updateDraftMessage('hello world');

    // Assert state updated
    final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));
    
    expect(state.draftMessage, equals('hello world'));

    // verify updateTypingStatus called with conversationId and true at least once
    verify(() => mockMessagesRepository.updateTypingStatus(1, true)).called(greaterThanOrEqualTo(1));
    print(  "zsdfsd");

  });

  test('loadMoreMessages calls repository and updates hasMoreMessages', () async {
    when(() => mockMessagesRepository.loadMessageHistory(1))
        .thenAnswer((_) async => true);

    final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

    // Act
    await notifier.loadMoreMessages();
    await Future<void>.delayed(const Duration(milliseconds: 10));
    
    // Assert
    final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));
    expect(state.loadingMoreMessages, isFalse);
    expect(state.hasMoreMessages, isTrue);
    verify(() => mockMessagesRepository.loadMessageHistory(1)).called(2);
  });

  test('refresh calls _loadMessages and sets messages AsyncData on success', () async {
    ChatMessage m1 = ChatMessage(id: 1, conversationId: 1, senderId: 10, text: 'Hello', time: DateTime.now(), isMine: false);
    ChatMessage m2 = ChatMessage(id: 2, conversationId: 1, senderId: 11, text: 'Hi', time: DateTime.now(), isMine: true);

    when(() => mockMessagesRepository.fetchMessage(1))
        .thenAnswer((_) => <ChatMessage>[m1, m2]);

    final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

    await notifier.refresh();

    final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));
    expect(state.messages, isA<AsyncData>());
    expect((state.messages as AsyncData).value.length, equals(2));
    verify(() => mockMessagesRepository.fetchMessage(1)).called(greaterThanOrEqualTo(1));
  });

  test('_getConvId sets state when conversationId is null', () async {
  when(() => mockConversationsRepository.getConversationIdByUserId(101))
      .thenAnswer((_) async => 5);

  final notifier = container.listen(chatViewModelProvider(userId: 101).notifier, (_, __) {}).read();

  await Future.delayed(const Duration(milliseconds: 10));
  final state = container.read(chatViewModelProvider(userId: 101));

  expect(state.conversationId, 5);
});
test('_getConvId handles convId = -1', () async {
  when(() => mockConversationsRepository.getConversationIdByUserId(101))
      .thenAnswer((_) async => -1);

  final notifier = container.listen(chatViewModelProvider(userId: 101).notifier, (_, __) {}).read();

  await Future.delayed(const Duration(milliseconds: 10));
  final state = container.read(chatViewModelProvider(userId: 101));

  // conversationId remains default
  expect(state.conversationId, -1);
});
test('_loadContact sets AsyncError on failure', () async {
  when(() => mockConversationsRepository.getContactByUserId(any()))
      .thenThrow(Exception("fail"));

  final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

  await Future.delayed(const Duration(milliseconds: 20));
  final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));

  expect(state.contact, isA<AsyncError>());
});
test('_loadMessages sets AsyncError on failure', () async {
  when(() => mockMessagesRepository.fetchMessage(1))
      .thenThrow(Exception("load error"));

  final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

  await notifier.refresh();
  final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));

  expect(state.messages, isA<AsyncError>());
});

test('_refreshMessages updates messages', () async {
  when(() => mockMessagesRepository.fetchMessage(1))
      .thenAnswer((_) => []);

  final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

  notifier.updateDraftMessage("test");
  notifier.refresh();

  final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));
  expect(state.messages, isA<AsyncData>());
});
test('_refreshMessages handles exceptions', () async {
  when(() => mockMessagesRepository.fetchMessage(1))
      .thenThrow(Exception("refresh fail"));

  final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

  notifier.refresh();
  final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));

  expect(state.messages, isA<AsyncError>());
});
test('_onNewMessagesArrive refreshes messages and marks seen', () async {
  StreamController<void> messageController = StreamController<void>();

  when(() => mockMessagesRepository.onMessageRecieved(1))
      .thenAnswer((_) => messageController.stream);

  final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();
      
  // act
  messageController.add(null);
  await Future<void>.delayed(const Duration(milliseconds: 10));

  verify(() => mockMessagesRepository.sendMarkAsSeen(1)).called(2);
});
test('_onOtherTyping updates isTyping', () async {
  StreamController<bool> typingController = StreamController<bool>();

  when(() => mockMessagesRepository.onUserTyping(1))
      .thenAnswer((_) => typingController.stream);

  //act
  final notifier = container.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read( );
  typingController.add(true);
  await Future<void>.delayed(const Duration(milliseconds: 10));

  final state = container.read(chatViewModelProvider(userId: 101, conversationId: 1));

  expect(state.isTyping, isTrue);
});
test('sendMessage sends message and clears draft', () async {
  final container2 = ProviderContainer(
    overrides: [
      messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
      conversationsRepositoryProvider.overrideWithValue(mockConversationsRepository),
      authenticationProvider.overrideWithValue(const AuthState(
        isAuthenticated: true,
        user: UserModel(
          id: 99,
          name: "Test User",
        )
      )),
    ],
  );

  final notifier = container2.listen(chatViewModelProvider(userId: 101, conversationId: 1).notifier, (_, __) {}).read();

  notifier.updateDraftMessage("  hi  ");
  await notifier.sendMessage();

  verify(() => mockMessagesRepository.sendMessage(99, 1, "hi")).called(1);
  verify(() => mockMessagesRepository.updateTypingStatus(1, false)).called(1);

  final state = container2.read(chatViewModelProvider(userId: 101, conversationId: 1));
  expect(state.draftMessage, "");
});
test('updateDraftMessage sets typing false after 3 seconds', () async {
  final notifier = container.listen(
    chatViewModelProvider(userId: 101, conversationId: 1).notifier,
    (_, __) {},
  ).read(
  );

  notifier.updateDraftMessage("test");

  verify(() => mockMessagesRepository.updateTypingStatus(1, true)).called(1);

  // Wait for the timer/delayed future inside updateDraftMessage
  await Future.delayed(const Duration(seconds: 3));

  verify(() => mockMessagesRepository.updateTypingStatus(1, false)).called(1);
});

test('loadMoreMessages returns early if already loading', () async {
  final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

  container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier)
    .state = container.read(chatViewModelProvider(userId: 101, conversationId: 1))
      .copyWith(loadingMoreMessages: true);

  await notifier.loadMoreMessages();

  verifyNever(() => mockMessagesRepository.loadMessageHistory(any()));
});
test('loadMoreMessages returns early if no more messages', () async {
  final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

  notifier.state = notifier.state.copyWith(hasMoreMessages: false);

  await notifier.loadMoreMessages();

  verifyNever(() => mockMessagesRepository.loadMessageHistory(any()));
});
// test('dispose cancels subscriptions and sets disposed', () async {
//   final notifier = container.read(chatViewModelProvider(userId: 101, conversationId: 1).notifier);

//   notifier.updateDraftMessage("test");
//   container.dispose();

//   expect(notifier._disposed, true);
//   expect(notifier._newMessagesSub, null);
//   expect(notifier._userTypingSub, null);
// });

}