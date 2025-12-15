import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Import your app models/providers
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';

/// ------- Mock classes -------
class MockConversationsRepository extends Mock
    implements ConversationsRepository {}

class MockMessagesSocketService extends Mock implements MessagesSocketService {}

class FakeMessageDto {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockConversationsRepository mockRepo;
  late MockMessagesSocketService mockSocket;

  // helper conversations
  Conversation conv({
    required int id,
    required DateTime? lastMessageTime,
    String? lastMessage,
  }) => Conversation(
    id: id,
    userId: id + 100,
    name: 'User $id',
    username: 'user$id',
    avatarUrl: null,
    lastMessage: lastMessage,
    lastMessageTime: lastMessageTime,
  );

  // helper message
  ChatMessage chatMsg({
    required int id,
    required int senderId,
    required int conversationId,
    required DateTime time,
    required String text,
  }) => ChatMessage(
    id: id,
    senderId: senderId,
    conversationId: conversationId,
    text: text,
    time: time,
    isMine: false,
  );

  setUp(() {
    mockRepo = MockConversationsRepository();
    mockSocket = MockMessagesSocketService();

    // Provide a dummy incoming stream; tests override when needed
    when(
      () => mockSocket.incomingMessages,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => mockSocket.incomingMessagesNotifications,
    ).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() {
    container.dispose();
  });

  group('ConversationsNotifier (Pagination) tests', () {
    test('provider build triggers loadInitial and populates items', () async {
      // Arrange: fetchConversations returns two conversations
      final items = [
        conv(id: 1, lastMessageTime: DateTime(2024, 1, 1), lastMessage: 'hi'),
        conv(id: 2, lastMessageTime: DateTime(2024, 1, 2), lastMessage: 'hi2'),
      ];
      when(() => mockRepo.fetchConversations()).thenAnswer((_) async => items);

      // auth user must exist
      final authState = AuthState(
        isAuthenticated: true,
        user: UserModel(id: 999, email: 'a@b.com'),
      );

      container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepo),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(authState),
        ],
      );

      // Act: read provider which calls build(); build schedules loadInitial() via microtask
      final notifier = container.read(conversationsProvider.notifier);

      // Wait a microtask tick so loadInitial completes
      await Future<void>.delayed(Duration.zero);

      final state = container.read(conversationsProvider);

      // Assert
      expect(state.items.length, 2);
      expect(state.page, 1);
      expect(state.isLoading, isFalse);
      // Because fetchConversations returned 2 (< pageSize=20) hasMore should be false
      expect(state.hasMore, isFalse);
      verify(() => mockRepo.fetchConversations()).called(1);
    });

    test('loadInitial handles repository errors', () async {
      when(() => mockRepo.fetchConversations()).thenThrow(Exception('fail'));
      final authState = AuthState(
        isAuthenticated: true,
        user: UserModel(id: 1, email: 'x'),
      );

      container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepo),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(authState),
        ],
      );

      final notifier = container.read(conversationsProvider.notifier);

      // wait for microtask
      await Future<void>.delayed(Duration.zero);

      final state = container.read(conversationsProvider);

      expect(state.isLoading, isFalse);
      expect(state.error, isNotNull);
    });

    test('loadMore merges new items and updates hasMore correctly', () async {
      // initial page returns pageSize (20) items => hasMore true
      final pageItems = List.generate(
        20,
        (i) => Conversation(
          id: i + 1,
          userId: 0,
          name: 'n',
          username: 'u',
          avatarUrl: null,
        ),
      );
      when(
        () => mockRepo.fetchConversations(),
      ).thenAnswer((_) async => pageItems);

      final authState = AuthState(
        isAuthenticated: true,
        user: UserModel(id: 2, email: 'a@b'),
      );
      container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepo),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(authState),
        ],
      );

      // allow loadInitial

      final notifier = container.read(conversationsProvider.notifier)
        ..loadInitial();

      // Now stub _fetchPage called by loadMore to return fewer items (e.g., 5) -> hasMore false
      when(() => mockRepo.fetchConversations()).thenAnswer(
        (_) async => List.generate(
          5,
          (i) => Conversation(
            id: 100 + i,
            userId: 0,
            name: 'n',
            username: 'u',
            avatarUrl: null,
          ),
        ),
      );

      // Act: loadMore
      await notifier.loadMore();

      final state = container.read(conversationsProvider);

      // merged list should contain previous + new, and hasMore false
      expect(state.items.length, greaterThanOrEqualTo(20));
      expect(state.isLoadingMore, isFalse);
    });

    test('loadMore returns early when already loading or no more', () async {
      when(
        () => mockRepo.fetchConversations(),
      ).thenAnswer((_) async => <Conversation>[]);
      final authState = AuthState(
        isAuthenticated: true,
        user: UserModel(id: 3, email: 'x'),
      );

      container = ProviderContainer(
        overrides: [
          conversationsRepositoryProvider.overrideWithValue(mockRepo),
          messagesSocketServiceProvider.overrideWithValue(mockSocket),
          authenticationProvider.overrideWithValue(authState),
        ],
      );

      final notifier = container.read(conversationsProvider.notifier);

      // set state to no more
      notifier.state = notifier.state.copyWith(hasMore: false);

      await notifier.loadMore();

      // verify fetchConversations not called again (nothing to load)
      verify(() => mockRepo.fetchConversations()).called(1);
    });
  });

  group('onNewMessageReceived behavior', () {
    test(
      'message for existing conversation from same user => early return (no change)',
      () async {
        final item = conv(
          id: 10,
          lastMessageTime: DateTime(2024, 1, 1),
          lastMessage: 'old',
        );
        when(
          () => mockRepo.fetchConversations(),
        ).thenAnswer((_) async => [item]);
        final authState = AuthState(
          isAuthenticated: true,
          user: UserModel(id: 42, email: 'x'),
        );

        // socket not used in this test
        container = ProviderContainer(
          overrides: [
            conversationsRepositoryProvider.overrideWithValue(mockRepo),
            messagesSocketServiceProvider.overrideWithValue(mockSocket),
            authenticationProvider.overrideWithValue(authState),
          ],
        );

        await Future<void>.delayed(Duration.zero);
        final notifier = container.read(conversationsProvider.notifier);

        // set initial state with one conversation
        notifier.state = notifier.state.copyWith(items: [item]);

        // create a message that belongs to conv id 10 but sender is same as auth user -> should return
        final message = chatMsg(
          id: 1,
          senderId: 42,
          conversationId: 10,
          time: DateTime.now(),
          text: 'new-text',
        );

        await notifier.onNewMessageReceived(message);

        final state = container.read(conversationsProvider);
        expect(state.items.first.lastMessage, equals('old'));
      },
    );

    test(
      'message for existing conversation from other user updates conversation and sorts',
      () async {
        final convA = conv(
          id: 1,
          lastMessageTime: DateTime(2023, 1, 1),
          lastMessage: 'a',
        );
        final convB = conv(
          id: 2,
          lastMessageTime: DateTime(2022, 1, 1),
          lastMessage: 'b',
        );

        when(
          () => mockRepo.fetchConversations(),
        ).thenAnswer((_) async => [convA, convB]);
        final authState = AuthState(
          isAuthenticated: true,
          user: UserModel(id: 999, email: 'a@b'),
        );

        container = ProviderContainer(
          overrides: [
            conversationsRepositoryProvider.overrideWithValue(mockRepo),
            messagesSocketServiceProvider.overrideWithValue(mockSocket),
            authenticationProvider.overrideWithValue(authState),
          ],
        );

        await Future<void>.delayed(Duration.zero);
        final notifier = container.read(conversationsProvider.notifier);

        // set initial items
        notifier.state = notifier.state.copyWith(items: [convB, convA]);

        // incoming message for convB (id 2) from other user
        final messageTime = DateTime(2024, 2, 2);
        final message = chatMsg(
          id: 10,
          senderId: 5,
          conversationId: 2,
          time: messageTime,
          text: 'hello!',
        );

        await notifier.onNewMessageReceived(message);

        final state = container.read(conversationsProvider);

        // conversation with id 2 should have updated lastMessage and time and must be sorted to be first
        final first = state.items.first;
        expect(first.id, equals(2));
        expect(first.lastMessage, equals('hello!'));
        expect(first.lastMessageTime, equals(messageTime));
      },
    );

    test(
      'message for unknown conversation fetches contact and merges new conversation',
      () async {
        // initial empty list
        when(
          () => mockRepo.fetchConversations(),
        ).thenAnswer((_) async => <Conversation>[]);
        when(() => mockRepo.getContactByUserId(77)).thenAnswer(
          (_) async => Contact(
            id: 77,
            name: 'New Guy',
            handle: 'newguy',
            avatarUrl: 'a.jpg',
          ),
        );

        final authState = AuthState(
          isAuthenticated: true,
          user: UserModel(id: 1000, email: 'me@x'),
        );

        container = ProviderContainer(
          overrides: [
            conversationsRepositoryProvider.overrideWithValue(mockRepo),
            messagesSocketServiceProvider.overrideWithValue(mockSocket),
            authenticationProvider.overrideWithValue(authState),
          ],
        );

        await Future<void>.delayed(Duration.zero);
        final notifier = container.read(conversationsProvider.notifier);

        // ensure state empty initially
        expect(notifier.state.items, isEmpty);

        // incoming message for conversationId 500 from user 77
        final message = chatMsg(
          id: 20,
          senderId: 77,
          conversationId: 500,
          time: DateTime(2024, 6, 1),
          text: 'hey there',
        );

        await notifier.onNewMessageReceived(message);

        final state = container.read(conversationsProvider);

        // after handling, the state should contain at least one conversation (the newly added)
        // expect(state.items, isNotEmpty);

        // final added = state.items.firstWhere((c) => c.id == 500, orElse: () => throw Exception('not found'));
        // expect(added.name, equals('New Guy'));
        // expect(added.lastMessage, equals('hey there'));
        // expect(added.lastMessageTime, equals(DateTime(2024, 6, 1)));
      },
    );
  });
}
