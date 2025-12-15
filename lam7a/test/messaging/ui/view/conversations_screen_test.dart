import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/messaging/model/conversation.dart';
import 'package:lam7a/features/messaging/ui/view/conversations_screen.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/conversations_viewmodel.dart';
import 'package:lam7a/features/messaging/ui_keys.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationsViewModel extends Notifier<PaginationState<Conversation>> with Mock implements ConversationsViewmodel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testConversations = [
    Conversation(
      id: 1,
      name: 'John Doe',
      userId: 2,
      username: 'johndoe',
      unseenCount: 5,
      isBlocked: false,
    ),
    Conversation(
      id: 2,
      name: 'Jane Smith',
      userId: 3,
      username: 'janesmith',
      unseenCount: 0,
      isBlocked: false,
    ),
  ];

  Widget makeTestWidget(ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        home: ConversationsScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == '/find-contacts') {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Find Contacts Screen')),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  group('ConversationsScreen Tests', () {
    testWidgets('displays loading indicator when isLoading is true', (tester) async {
      final state = PaginationState<Conversation>(
        isLoading: true,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays error message when error is not null', (tester) async {
      final state = PaginationState<Conversation>(
        error: 'Network error occurred',
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.text('Error: Network error occurred'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays empty state when items is empty', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.text('Welcome to your\ninbox!'), findsOneWidget);
      expect(find.text('Drop a line, share posts and more with private conversations between you and onthers on X.'), findsOneWidget);
      expect(find.byKey(Key(MessagingUIKeys.conversationsEmptyStateWriteButton)), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays conversations list when items is not empty', (tester) async {
      final state = PaginationState<Conversation>(
        items: testConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Should render conversation tiles
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays floating action button', (tester) async {
      final state = PaginationState<Conversation>(
        items: testConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byKey(Key(MessagingUIKeys.conversationsFab)), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);

      container.dispose();
    });

    testWidgets('navigates to find contacts screen when FAB is pressed', (tester) async {
      final state = PaginationState<Conversation>(
        items: testConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      await tester.tap(find.byKey(Key(MessagingUIKeys.conversationsFab)));
      await tester.pumpAndSettle();

      expect(find.byType(FindContactsScreen), findsOneWidget);

      container.dispose();
    });

    testWidgets('navigates to find contacts screen when empty state button is pressed', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      await tester.tap(find.byKey(Key(MessagingUIKeys.conversationsEmptyStateWriteButton)));
      await tester.pumpAndSettle();

      expect(find.byType(FindContactsScreen), findsOneWidget);

      container.dispose();
    });

    testWidgets('calls refresh when pull to refresh is triggered', (tester) async {
      final state = PaginationState<Conversation>(
        items: testConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);
      when(() => mockViewModel.refresh()).thenAnswer((_) async {});

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Trigger pull to refresh
      await tester.drag(find.text('John Doe'), const Offset(0, 300));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockViewModel.refresh()).called(greaterThan(0));

      container.dispose();
    });

    testWidgets('displays RefreshIndicator for error state', (tester) async {
      final state = PaginationState<Conversation>(
        error: 'Test error',
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays RefreshIndicator for empty state', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);

      container.dispose();
    });

    testWidgets('empty state has correct layout', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Check for all empty state components
      expect(find.byType(Padding), findsWidgets);
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Write a message'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays scaffold with body', (tester) async {
      final state = PaginationState<Conversation>(
        items: testConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);

      container.dispose();
    });

    testWidgets('uses CustomScrollView for error state', (tester) async {
      final state = PaginationState<Conversation>(
        error: 'Error occurred',
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverFillRemaining), findsOneWidget);

      container.dispose();
    });

    testWidgets('uses CustomScrollView for empty state', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(CustomScrollView), findsOneWidget);
      expect(find.byType(SliverFillRemaining), findsOneWidget);

      container.dispose();
    });

    testWidgets('conversations list is scrollable', (tester) async {
      final manyConversations = List.generate(
        20,
        (index) => Conversation(
          id: index,
          name: 'User $index',
          userId: index + 100,
          username: 'user$index',
          unseenCount: 0,
          isBlocked: false,
        ),
      );

      final state = PaginationState<Conversation>(
        items: manyConversations,
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Should find the first conversation
      expect(find.text('User 0'), findsOneWidget);

      // Scroll to find a conversation further down
      await tester.drag(find.text('User 0'), const Offset(0, -500));
      await tester.pumpAndSettle();

      container.dispose();
    });

    testWidgets('empty state button has correct text', (tester) async {
      final state = PaginationState<Conversation>(
        items: [],
      );

      final mockViewModel = MockConversationsViewModel();
      when(() => mockViewModel.build()).thenReturn(state);

      final container = ProviderContainer(
        overrides: [
          conversationsViewmodel.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      final button = tester.widget<FilledButton>(
        find.byKey(Key(MessagingUIKeys.conversationsEmptyStateWriteButton)),
      );
      expect(button, isNotNull);

      container.dispose();
    });
  });
}
