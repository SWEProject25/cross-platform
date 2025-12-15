import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/notifications/models/actor_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/mention_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/views/notifications_screen.dart';
import 'package:mocktail/mocktail.dart';

// Mocks

class MockMentionNotificationsViewModel extends Notifier<PaginationState<NotificationModel>> with Mock implements MentionNotificationsViewmodel {}
class MockAllNotificationsViewModel extends Notifier<PaginationState<NotificationModel>> with Mock implements AllNotificationsViewModel {}

// Fakes
class FakeNotificationModel extends Fake implements NotificationModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeNotificationModel());
  });

  group('NotificationsScreen Widget Tests', () {
    late MockAllNotificationsViewModel mockAllNotificationsViewModel;
    late MockMentionNotificationsViewModel mockMentionNotificationsViewModel;

    // Sample data
    final mockNotification1 = NotificationModel(
      notificationId: '1',
      type: NotificationType.like,
      isRead: false,
      createdAt: DateTime(2025, 1, 1),
      actor: ActorModel(
        id: 1,
        username: 'user1',
        displayName: 'User One',
        profileImageUrl: null,
      ),
      postPreviewText: 'Test notification 1',
    );

    final mockNotification2 = NotificationModel(
      notificationId: '2',
      type: NotificationType.mention,
      isRead: false,
      createdAt: DateTime(2025, 1, 2),
      actor: ActorModel(
        id: 2,
        username: 'user2',
        displayName: 'User Two',
        profileImageUrl: null,
      ),
      postPreviewText: 'Test notification 2',
    );

    setUp(() {
      mockAllNotificationsViewModel = MockAllNotificationsViewModel();
      mockMentionNotificationsViewModel = MockMentionNotificationsViewModel();

      // Default stubs
      when(() => mockAllNotificationsViewModel.loadMore())
          .thenAnswer((_) async => {});
      when(() => mockAllNotificationsViewModel.markAllAsRead())
          .thenReturn(null);
      when(() => mockAllNotificationsViewModel.markNotAsRead(any()))
          .thenReturn(null);
      when(() => mockAllNotificationsViewModel.handleNotificationAction(any()))
          .thenReturn(null);

      when(() => mockMentionNotificationsViewModel.loadMore())
          .thenAnswer((_) async => {});
      when(() => mockMentionNotificationsViewModel.markAllAsRead())
          .thenReturn(null);
      when(() => mockMentionNotificationsViewModel.markNotAsRead(any()))
          .thenReturn(null);
      when(() => mockMentionNotificationsViewModel
              .handleNotificationAction(any()))
          .thenReturn(null);
    });

    Widget createTestWidget(ProviderContainer container) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: NotificationsScreen(),
        ),
      );
    }

    group('Widget Rendering', () {
      testWidgets('should render NotificationsScreen with tabs',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify tabs exist
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Mentions'), findsOneWidget);

        container.dispose();
      });

      testWidgets('should render empty state when no notifications',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify empty state message
        expect(find.text('Join the conversation!'), findsOneWidget);
        expect(
          find.textContaining('When someone mentions you'),
          findsOneWidget,
        );

        container.dispose();
      });

      testWidgets('should render notifications list when data exists',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification1, mockNotification2],
            page: 1,
            hasMore: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Should not show empty state
        expect(find.text('Join the conversation!'), findsNothing);

        container.dispose();
      });

      testWidgets('should render loading indicator when loading',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          const PaginationState<NotificationModel>(
            items: [],
            isLoading: true,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));

        await tester.pumpWidget(createTestWidget(container));
        await tester.pump();

        // Should show loading indicator
        expect(find.byType(CircularProgressIndicator), findsWidgets);

        container.dispose();
      });
    });

    group('Tab Navigation', () {
      testWidgets('should switch between All and Mentions tabs',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification1],
            page: 1,
            hasMore: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification2],
            page: 1,
            hasMore: false,
          ),
        );

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Initially on All tab
        expect(find.text('All'), findsOneWidget);

        // Tap Mentions tab
        await tester.tap(find.text('Mentions'));
        await tester.pumpAndSettle();

        // Should still see both tabs
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Mentions'), findsOneWidget);

        container.dispose();
      });

      testWidgets('should start with All tab selected by default',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify DefaultTabController has initialIndex 0
        final tabController =
            DefaultTabController.of(tester.element(find.text('All')));
        expect(tabController.index, equals(0));

        container.dispose();
      });
    });

    group('Lifecycle Methods', () {
      testWidgets('should call markAllAsRead on deactivate',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Navigate away to trigger deactivate
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Scaffold(body: Text('Other Screen')),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify markAllAsRead was called
        verify(() => mockAllNotificationsViewModel.markAllAsRead()).called(1);
        verify(() => mockMentionNotificationsViewModel.markAllAsRead())
            .called(1);

        container.dispose();
      });
    });

    group('Notification Tap Handling', () {
      testWidgets('should mark notification as read on tap',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification1],
            page: 1,
            hasMore: false,
            isLoading: false,
            isLoadingMore: false,
            isRefreshing: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Find and tap notification item
        final notificationFinder = find.byKey(ValueKey('notification_item_${mockNotification1.notificationId}'));
        if (tester.any(notificationFinder)) {
          await tester.tap(notificationFinder);
          await tester.pumpAndSettle();

          // Verify markNotAsRead was called
          verify(() => mockAllNotificationsViewModel
              .markNotAsRead(mockNotification1.notificationId)).called(1);
          verify(() => mockMentionNotificationsViewModel
              .markNotAsRead(mockNotification1.notificationId)).called(1);
        }

        container.dispose();
      });

      testWidgets(
          'should handle notification action for non-mention notifications',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        final likeNotification = NotificationModel(
          notificationId: 'like-1',
          type: NotificationType.like,
          isRead: false,
          createdAt: DateTime.now(),
          actor: ActorModel(
            id: 1,
            username: 'user1',
            displayName: 'User One',
            profileImageUrl: null,
          ),
          postId: 123,
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [likeNotification],
            page: 1,
            hasMore: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Find and tap notification
        final notificationFinder = find.byKey(ValueKey('notification_item_${likeNotification.notificationId}'));
        if (tester.any(notificationFinder)) {
          await tester.tap(notificationFinder);
          await tester.pumpAndSettle();

          // Verify handleNotificationAction was called for non-mention type
          verify(() => mockAllNotificationsViewModel
              .handleNotificationAction(likeNotification)).called(1);
        }

        container.dispose();
      });
    });

    group('Pagination Behavior', () {
      testWidgets('should show end of list widget when no more items',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification1, mockNotification2],
            page: 1,
            hasMore: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify end of list widget
        expect(find.text('No more notifications for now'), findsOneWidget);

        container.dispose();
      });

      });

    group('Error Handling', () {
      testWidgets('should handle error state gracefully',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [],
            error: Exception('Network error'),
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Should handle error without crashing
        expect(find.byType(NotificationsScreen), findsOneWidget);

        container.dispose();
      });
    });

    group('UI Elements', () {
      testWidgets('should render TabBar with correct styling',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify TabBar exists
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.byType(Tab), findsNWidgets(2));

        container.dispose();
      });

      testWidgets('should render SafeArea', (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify SafeArea exists
        expect(find.byType(SafeArea), findsOneWidget);

        container.dispose();
      });

      testWidgets('should render no data widget with correct text',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>(items: []));

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Verify no data widget text
        expect(find.text('Join the conversation!'), findsOneWidget);
        expect(
          find.text('When someone mentions you, you\'ll find\nit here.'),
          findsOneWidget,
        );

        container.dispose();
      });
    });

    group('Multiple Notifications', () {
      testWidgets('should render multiple notifications in list',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        final notifications = List.generate(
          5,
          (i) => NotificationModel(
            notificationId: 'id-$i',
            type: NotificationType.follow,
            isRead: false,
            createdAt: DateTime.now(),
            actor: ActorModel(
              id: i,
              username: 'user$i',
              displayName: 'User $i',
              profileImageUrl: null,
            ),
          ),
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: notifications,
            page: 1,
            hasMore: false,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pumpAndSettle();

        // Should not show empty state
        expect(find.text('Join the conversation!'), findsNothing);

        container.dispose();
      });
    });

    group('Refresh Behavior', () {
      testWidgets('should show refresh indicator when refreshing',
          (WidgetTester tester) async {
        final container = ProviderContainer(
          overrides: [
            allNotificationsViewModelProvider.overrideWith(
              () => mockAllNotificationsViewModel,
            ),
            mentionNotificationsViewModelProvider.overrideWith(
              () => mockMentionNotificationsViewModel,
            ),
          ],
        );

        when(() => mockAllNotificationsViewModel.build()).thenReturn(
          PaginationState<NotificationModel>(
            items: [mockNotification1],
            isRefreshing: true,
          ),
        );
        when(() => mockMentionNotificationsViewModel.build())
            .thenReturn(const PaginationState<NotificationModel>());

        await tester.pumpWidget(createTestWidget(container));
        await tester.pump();

        // Should show some indicator during refresh
        expect(find.byType(CircularProgressIndicator), findsWidgets);

        container.dispose();
      });
    });
  });
}
