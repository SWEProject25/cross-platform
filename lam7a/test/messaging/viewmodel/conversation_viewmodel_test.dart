import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/providers/conversations_provider.dart';
import 'package:lam7a/features/messaging/repository/messages_repository.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversation_viewmodel.dart';

/// ---- MOCK CLASSES ----
// class MockMessagesRepository extends Mock implements MessagesRepository {}

class MockMessagesRepository extends Mock implements MessagesRepository {}

// class MockMessagesRepository extends MessagesRepository {
//   @override
//   void sendMessage(int senderId, int conversationId, String message) {
//     // Do nothing or record for test
//   }

//   @override
//   List<ChatMessage> fetchMessage(int chatId) {
//     return [
//       ChatMessage(
//         id: 1,
//         text: "Mock message",
//         time: DateTime.now(),
//         isMine: true,
//         isDelivered: true,
//         isSeen: true,
//         senderId: 123,
//         conversationId: chatId,
//       ),
//     ];
//   }
// }


class MockConversationsNotifier extends Mock
    implements ConversationsNotifier {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockMessagesRepository mockMessagesRepository;
  late MockConversationsNotifier mockConversationsNotifier;

  final testConversation = Conversation(
    id: 1,
    userId: 101,
    name: 'John Doe',
    username: 'johndoe',
    avatarUrl: 'https://example.com/avatar.jpg',
    lastMessage: 'Hello there!',
    lastMessageTime: DateTime(2025, 1, 15, 10, 30),
  );

  final testConversation2 = Conversation(
    id: 2,
    userId: 102,
    name: 'Jane Smith',
    username: 'janesmith',
    avatarUrl: 'https://example.com/avatar2.jpg',
    lastMessage: 'How are you?',
    lastMessageTime: DateTime(2025, 1, 15, 11, 45),
  );

  setUp(() {
    mockMessagesRepository = MockMessagesRepository();
    mockConversationsNotifier = MockConversationsNotifier();
  });

  tearDown(() {
    container.dispose();
  });

  group('ConversationViewmodel - Initialization', () {
    test('should build with valid conversation', () {
      // Setup conversations provider with test data
      final paginationState = PaginationState<Conversation>(
        items: [testConversation, testConversation2],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      // Setup typing stream mock
      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      
      // Act
      final state = container.listen(conversationViewmodelProvider(1), (_, __) {}).read();

      // Assert
      expect(state.conversation.id, equals(1));
      expect(state.conversation.name, equals('John Doe'));
      expect(state.conversation.username, equals('johndoe'));
      expect(state.isTyping, false);
    });

    test('should throw exception when conversation not found', () {
      // Setup with empty conversations
      final paginationState = PaginationState<Conversation>(
        items: [],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(999),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act & Assert
      expect(
        () => container.read(conversationViewmodelProvider(999)),
        throwsException,
      );
    });

    test('should initialize with correct conversation data', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation, testConversation2],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(2),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state = container.listen(conversationViewmodelProvider(2), (_, __) {}).read();

      // Assert
      expect(state.conversation.id, equals(2));
      expect(state.conversation.userId, equals(102));
      expect(state.conversation.name, equals('Jane Smith'));
      expect(state.conversation.username, equals('janesmith'));
      expect(state.conversation.lastMessage, equals('How are you?'));
    });
  });

  group('ConversationViewmodel - Typing Status', () {
    test('should initialize with isTyping false', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state = container.read(conversationViewmodelProvider(1));

      // Assert
      expect(state.isTyping, false);
    });

    test('should subscribe to typing events on build', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      container.read(conversationViewmodelProvider(1));

      // Assert - verify typing stream was subscribed to
      verify(
        () => mockMessagesRepository.onUserTyping(1),
      ).called(greaterThan(0));
    });

    test('should handle typing stream errors gracefully', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      // Setup typing stream to throw error
      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.error(Exception('Stream error')));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act & Assert - should not crash
      expect(
        () => container.read(conversationViewmodelProvider(1)),
        returnsNormally,
      );
    });
  });

  group('ConversationViewmodel - Conversation Data', () {
    test('should maintain correct conversation information', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation, testConversation2],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));
      when(
        () => mockMessagesRepository.onUserTyping(2),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state1 = container.read(conversationViewmodelProvider(1));
      final state2 = container.read(conversationViewmodelProvider(2));

      // Assert
      expect(state1.conversation.id, equals(1));
      expect(state1.conversation.name, equals('John Doe'));

      expect(state2.conversation.id, equals(2));
      expect(state2.conversation.name, equals('Jane Smith'));

      // Verify they are different conversations
      expect(state1.conversation.id, isNot(equals(state2.conversation.id)));
    });

    test('should have correct conversation avatar URL', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state = container.read(conversationViewmodelProvider(1));

      // Assert
      expect(
        state.conversation.avatarUrl,
        equals('https://example.com/avatar.jpg'),
      );
    });

    test('should have correct last message information', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state = container.read(conversationViewmodelProvider(1));

      // Assert
      expect(state.conversation.lastMessage, equals('Hello there!'));
      expect(
        state.conversation.lastMessageTime,
        equals(DateTime(2025, 1, 15, 10, 30)),
      );
    });
  });
  
  group('ConversationViewmodel - State Consistency', () {
    test('should maintain state across multiple reads', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act - read multiple times
      final state1 = container.read(conversationViewmodelProvider(1));
      final state2 = container.read(conversationViewmodelProvider(1));
      final state3 = container.read(conversationViewmodelProvider(1));

      // Assert
      expect(state1.conversation.id, equals(state2.conversation.id));
      expect(state2.conversation.id, equals(state3.conversation.id));
      expect(state1.conversation.name, equals(state2.conversation.name));
      expect(state2.conversation.name, equals(state3.conversation.name));
    });

    test('should have consistent typing status on multiple reads', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state1 = container.read(conversationViewmodelProvider(1));
      final state2 = container.read(conversationViewmodelProvider(1));

      // Assert
      expect(state1.isTyping, equals(state2.isTyping));
    });
  });

  group('ConversationViewmodel - Error Handling', () {
    test('should handle missing conversation gracefully', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(999),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act & Assert
      expect(
        () => container.read(conversationViewmodelProvider(999)),
        throwsException,
      );
    });

    test('should handle typing stream emission correctly', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: true,
        error: null,
      );

      // Create a stream that emits values
      final typingStream = Stream<bool>.fromIterable([false, true, false]);

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => typingStream);

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final state = container.read(conversationViewmodelProvider(1));

      // Assert - initial state should be loaded
      expect(state.conversation.id, equals(1));
      // Typing status updates are handled asynchronously
      verify(
        () => mockMessagesRepository.onUserTyping(1),
      ).called(greaterThan(0));
    });
  });

  group('ConversationViewmodel - Provider Factory Pattern', () {
    test('should create unique instances for different conversation IDs', () {
      final paginationState = PaginationState<Conversation>(
        items: [testConversation, testConversation2],
        page: 1,

        isLoading: false,
        isLoadingMore: false,
        hasMore: false,
        error: null,
      );

      when(
        () => mockMessagesRepository.onUserTyping(1),
      ).thenAnswer((_) => Stream.value(false));
      when(
        () => mockMessagesRepository.onUserTyping(2),
      ).thenAnswer((_) => Stream.value(false));

      container = ProviderContainer(
        overrides: [
          messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
          conversationsProvider.overrideWithBuild((ref, _) => paginationState),
        ],
      );

      // Act
      final provider1 = conversationViewmodelProvider(1);
      final provider2 = conversationViewmodelProvider(2);

      // Assert - providers should be different
      expect(provider1, isNot(equals(provider2)));

      final state1 = container.read(provider1);
      final state2 = container.read(provider2);

      expect(state1.conversation.id, equals(1));
      expect(state2.conversation.id, equals(2));
    });
  });

  test('should update isTyping when typing stream emits new value', () async {
  final paginationState = PaginationState<Conversation>(
    items: [testConversation],
    page: 1,
    isLoading: false,
    isLoadingMore: false,
    hasMore: true,
    error: null,
  );

  final controller = StreamController<bool>();

  when(() => mockMessagesRepository.onUserTyping(1))
      .thenAnswer((_) => controller.stream);

  container = ProviderContainer(
    overrides: [
      messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
      conversationsProvider.overrideWithBuild((ref, _) => paginationState),
    ],
  );

  final listener = container.listen(
    conversationViewmodelProvider(1),
    (_, __) {},
  );

  // Initial state
  expect(listener.read().isTyping, false);

  // Emit true
  controller.add(true);
  await Future.delayed(Duration.zero);
  expect(listener.read().isTyping, true);

  // Emit false
  controller.add(false);
  await Future.delayed(Duration.zero);
  expect(listener.read().isTyping, false);

  await controller.close();
});
test('should catch exception when subscribing to typing stream fails', () {
  final paginationState = PaginationState<Conversation>(
    items: [testConversation],
    page: 1,
    isLoading: false,
    isLoadingMore: false,
    hasMore: true,
    error: null,
  );

  when(() => mockMessagesRepository.onUserTyping(1))
      .thenThrow(Exception('Subscription error'));

  container = ProviderContainer(
    overrides: [
      messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
      conversationsProvider.overrideWithBuild((ref, _) => paginationState),
    ],
  );

  expect(
    () => container.read(conversationViewmodelProvider(1)),
    returnsNormally,
  );
});
// test('should cancel typing subscription on dispose', () async {
//   final paginationState = PaginationState<Conversation>(
//     items: [testConversation],
//     page: 1,
//     isLoading: false,
//     isLoadingMore: false,
//     hasMore: true,
//     error: null,
//   );

//   final controller = StreamController<bool>();

//   when(() => mockMessagesRepository.onUserTyping(1))
//       .thenAnswer((_) => controller.stream);

//   container = ProviderContainer(
//     overrides: [
//       messagesRepositoryProvider.overrideWithValue(mockMessagesRepository),
//       conversationsProvider.overrideWithBuild((ref, _) => paginationState),
//     ],
//   );

//   container.read(conversationViewmodelProvider(1));

//   // Get the subscription
//   final viewmodel = container.read(conversationViewmodelProvider(1).notifier);
//   final subscription = viewmodel._typingSubscription!;

//   // Dispose the provider container
//   container.dispose();

//   // The subscription should be cancelled
//   expect(subscription.isPaused, isTrue);
// });

}
