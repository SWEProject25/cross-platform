import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/services/socket_service.dart';
import 'package:lam7a/features/messaging/active_chat_screens.dart';
import 'package:lam7a/features/messaging/model/chat_message.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/state/chat_state.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/chat_viewmodel.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';
import 'package:mocktail/mocktail.dart';

class MockChatViewModel extends ChatViewModel with Mock {  
  final ChatState initialState;
  int refreshCallCount = 0;
  int loadMoreMessagesCallCount = 0;
  int sendMessageCallCount = 0;
  String? lastDraftMessage;
  int updateDraftMessageCallCount = 0;

  MockChatViewModel(this.initialState);

  @override
  ChatState build({required int conversationId, required int userId}) {
    return initialState;
  }

  @override
  Future<void> refresh() async {
    refreshCallCount++;
  }

  @override
  Future<void> loadMoreMessages() async {
    loadMoreMessagesCallCount++;
  }

  @override
  Future<void> sendMessage() async {
    sendMessageCallCount++;
  }

  @override
  void updateDraftMessage(String message) {
    lastDraftMessage = message;
    updateDraftMessageCallCount++;
  }
}


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testContact = Contact(
    id: 2,
    name: 'Test User',
    handle: '@testuser',
    bio: 'Test bio',
    totalFollowers: 1000,
  );

  final testConversation = Conversation(
    id: 1,
    name: 'Test User',
    userId: 2,
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
      senderId: 2,
    ),
    ChatMessage(
      id: 2,
      text: 'Hi there',
      time: DateTime(2025, 1, 1, 10),
      isMine: true,
      senderId: 1,
    ),
  ];

  Widget makeTestWidget(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        initialRoute: ChatScreen.routeName,
        onGenerateRoute: (settings) {
          if (settings.name == ChatScreen.routeName) {
            return MaterialPageRoute(
              settings: RouteSettings(
                name: ChatScreen.routeName,
                arguments: {'userId': 2, 'conversationId': 1},
              ),
              builder: (_) => ChatScreen(),
            );
          }
          return null;
        },
      ),
    );
  }

  group('ChatScreen Tests', () {
    setUp(() {
      // Clear active chat screens before each test
      ActiveChatScreens.setInactive(1);
    });

    testWidgets('initializes and sets active chat screen', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(ActiveChatScreens.isActive(1), true);

      container.dispose();
    });

    testWidgets('disposes and sets inactive chat screen', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(ActiveChatScreens.isActive(1), true);

      // Navigate away
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(ActiveChatScreens.isActive(1), false);

      container.dispose();
    });

    testWidgets('displays loading state', (tester) async {
      final state = ChatState(
        contact: const AsyncLoading(),
        conversation: const AsyncLoading(),
        messages: const AsyncLoading(),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays error state', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncError('Test error', StackTrace.current),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.textContaining('Error'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays messages list', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byKey(Key(MessagingUIKeys.messagesListView)), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays typing indicator when user is typing', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
        isTyping: true,
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump(); // Use pump() instead of pumpAndSettle() for continuous animations

      expect(find.byKey(Key(MessagingUIKeys.chatScreenTypingIndicator)), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays chat input bar when not blocked', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byKey(Key(MessagingUIKeys.chatInputBar)), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays blocked message when conversation is blocked', (tester) async {
      final blockedConversation = testConversation.copyWith(isBlocked: true);
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(blockedConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('This user is not available.'), findsOneWidget);
      expect(find.byKey(Key(MessagingUIKeys.chatInputBar)), findsNothing);

      container.dispose();
    });

    testWidgets('displays profile info when no more messages to load', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
        hasMoreMessages: false,
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Test User'), findsWidgets);
      expect(find.text('Test bio'), findsOneWidget);
      expect(find.text('1K Followers'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays offline indicator when not connected', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(false)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byIcon(Icons.signal_wifi_statusbar_connected_no_internet_4), findsOneWidget);

      container.dispose();
    });

    testWidgets('does not display offline indicator when connected', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byIcon(Icons.signal_wifi_statusbar_connected_no_internet_4), findsNothing);

      container.dispose();
    });

    testWidgets('displays skeleton loading for contact', (tester) async {
      final state = ChatState(
        contact: const AsyncLoading(),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
        hasMoreMessages: false,
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump(const Duration(seconds: 5));

      expect(find.text('Ask PlayStation'), findsWidgets);

      container.dispose();
    });

    // testWidgets('pulls to refresh calls refresh method', (tester) async {
    //   final state = ChatState(
    //     contact: AsyncData(testContact),
    //     conversation: AsyncData(testConversation),
    //     messages: AsyncData(testMessages),
    //   );

    //   final mockViewModel = MockChatViewModel(state);

    //   final container = ProviderContainer(
    //     overrides: [
    //       chatViewModelProvider(conversationId: 1, userId: 2)
    //           .overrideWith(() => mockViewModel),
    //       socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
    //     ],
    //   );

    //   await tester.pumpWidget(makeTestWidget(container));
    //   await tester.pumpAndSettle(const Duration(seconds: 5));

    //   await tester.drag(
    //     find.byKey(Key(MessagingUIKeys.chatScreenRefreshIndicator)),
    //     const Offset(0, -500),
    //   );
    //   await tester.pumpAndSettle(const Duration(seconds: 5));

    //   expect(mockViewModel.refreshCallCount, 1);

    //   container.dispose();
    // });

    testWidgets('tap on scaffold dismisses keyboard', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Find the GestureDetector
      final gestureDetector = find.byKey(Key('chatScreenGestureDetector'));
      expect(gestureDetector, findsOneWidget);

      await tester.tap(gestureDetector);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      container.dispose();
    });

    testWidgets('displays correct contact name in app bar when loaded', (tester) async {
      final state = ChatState(
        contact: AsyncData(testContact),
        conversation: AsyncData(testConversation),
        messages: AsyncData(testMessages),
      );

      final mockViewModel = MockChatViewModel(state);

      final container = ProviderContainer(
        overrides: [
          chatViewModelProvider(conversationId: 1, userId: 2)
              .overrideWith(() => mockViewModel),
          socketConnectionProvider.overrideWith((ref) => Stream.value(true)),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.text('Test User'), findsWidgets);

      container.dispose();
    });
  });
}
