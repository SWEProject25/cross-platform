import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/notifications/models/actor_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class FakeNotificationModel extends Fake implements NotificationModel {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockNotificationsReceiver extends Mock implements NotificationsReceiver {}

// class MockNewNotificationCount extends Mock implements NewNotificationCount {}

class MockNewNotificationCount extends Notifier<int> with Mock implements NewNotificationCount {}


void main() {
  // Ensure Flutter binding is initialized for WidgetsBinding
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AllNotificationsViewModel Tests', () {
    late MockNotificationsRepository mockRepository;
    late MockNotificationsReceiver mockReceiver;
    late MockNewNotificationCount mockNotificationCount;
    late ProviderContainer container;

    setUpAll(() {
      registerFallbackValue(FakeNotificationModel());
    });

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
      type: NotificationType.follow,
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

    final mockNotification3 = NotificationModel(
      notificationId: '3',
      type: NotificationType.reply,
      isRead: true,
      createdAt: DateTime(2025, 1, 3),
      actor: ActorModel(
        id: 3,
        username: 'user3',
        displayName: 'User Three',
        profileImageUrl: null,
      ),
      postPreviewText: 'Test notification 3',
    );

    setUp(() {
      mockRepository = MockNotificationsRepository();
      mockReceiver = MockNotificationsReceiver();
      mockNotificationCount = MockNewNotificationCount();

      // Default stubs
      when(() => mockRepository.fetchAllNotifications(any(), any()))
          .thenAnswer((_) async => (<NotificationModel>[], false));
      when(() => mockRepository.markAllAsRead()).thenAnswer((_) async => {});
      when(() => mockRepository.markAsRead(any())).thenAnswer((_) async => {});
      when(() => mockReceiver.handleNotificationAction(any()))
          .thenReturn(null);
      when(() => mockNotificationCount.updateNotificationsCount(
              reset: any(named: 'reset')))
          .thenAnswer((_) async => {});

      container = ProviderContainer(
        overrides: [
          notificationsRepositoryProvider.overrideWithValue(mockRepository),
          notificationsReceiverProvider.overrideWithValue(mockReceiver),
          unReadNotificationCountProvider.overrideWith(
            () => mockNotificationCount,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('build()', () {
      test('should initialize with empty PaginationState', () {
        final state = container.read(allNotificationsViewModelProvider);

        expect(state, isA<PaginationState<NotificationModel>>());
        expect(state.items, isEmpty);
        expect(state.page, equals(0));
        expect(state.isLoading, isFalse);
        expect(state.hasMore, isTrue);
        expect(state.error, isNull);
      });

      test('should call loadInitial on build', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenAnswer((_) async => ([mockNotification1], true));

        // Trigger build by reading the provider
        container.read(allNotificationsViewModelProvider);

        // Wait for microtask to complete
        await Future.microtask(() {});
        await Future.delayed(Duration.zero);

        // Verify fetchAllNotifications was called
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
      });

      test('should handle loadInitial error gracefully', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenThrow(Exception('Network error'));

        // Trigger build
        container.read(allNotificationsViewModelProvider);

        // Wait for microtask to complete
        await Future.microtask(() {});
        await Future.delayed(Duration.zero);

        // The error should be logged but not crash
        final state = container.read(allNotificationsViewModelProvider);
        expect(state, isA<PaginationState<NotificationModel>>());
      });
    });

    group('fetchPage()', () {
      test('should fetch notifications for given page', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenAnswer((_) async => ([mockNotification1, mockNotification2], true));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items.length, equals(2));
        expect(state.items[0].notificationId, equals('1'));
        expect(state.items[1].notificationId, equals('2'));
        expect(state.hasMore, isTrue);
        expect(state.page, equals(1));
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
      });

      test('should handle empty notifications', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenAnswer((_) async => (<NotificationModel>[], false));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items, isEmpty);
        expect(state.hasMore, isFalse);
      });

      test('should handle fetchPage error', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenThrow(Exception('Failed to fetch'));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items, isEmpty);
        expect(state.error, isNotNull);
      });

      test('should fetch multiple pages correctly', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenAnswer((_) async => ([mockNotification1], true));
        when(() => mockRepository.fetchAllNotifications(2, 20))
            .thenAnswer((_) async => ([mockNotification2], true));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();
        await viewmodel.loadMore();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items.length, equals(2));
        expect(state.page, equals(2));
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
        verify(() => mockRepository.fetchAllNotifications(2, 20)).called(1);
      });
    });

    group('mergeList()', () {
      test('should merge two notification lists', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        final list1 = [mockNotification1, mockNotification2];
        final list2 = [mockNotification3];

        final merged = viewmodel.mergeList(list1, list2);

        expect(merged.length, equals(3));
        expect(merged[0].notificationId, equals('1'));
        expect(merged[1].notificationId, equals('2'));
        expect(merged[2].notificationId, equals('3'));
      });

      test('should handle empty lists', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        final merged = viewmodel.mergeList([], []);
        expect(merged, isEmpty);
      });

      test('should merge empty first list with non-empty second list', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        final merged = viewmodel.mergeList([], [mockNotification1]);

        expect(merged.length, equals(1));
        expect(merged[0].notificationId, equals('1'));
      });
    });

    group('markAllAsRead()', () {
      test('should mark all notifications as read', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([
            mockNotification1,
            mockNotification2,
          ], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        // Mark all as read
        viewmodel.markAllAsRead();


        verify(() => mockRepository.markAllAsRead()).called(1);
        verify(() => mockNotificationCount.updateNotificationsCount(
            reset: true)).called(1);

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items.every((n) => n.isRead), isTrue);
      });

      test('should update notification count after marking all as read', () {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], false),
        );

        final viewmodel =
            container.listen(allNotificationsViewModelProvider.notifier, (_, __) {}).read();

        viewmodel.markAllAsRead();

        // Wait for post frame callback
        WidgetsBinding.instance.handleBeginFrame(Duration.zero);
        WidgetsBinding.instance.handleDrawFrame();

        verify(() => mockNotificationCount.updateNotificationsCount(
            reset: true)).called(1);
      });
    });

    group('markNotAsRead()', () {
      test('should mark specific notification as read', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([
            mockNotification1,
            mockNotification2,
          ], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        viewmodel.markNotAsRead('1');

        final state = container.read(allNotificationsViewModelProvider);

        expect(
          state.items.firstWhere((n) => n.notificationId == '1').isRead,
          isTrue,
        );
        expect(
          state.items.firstWhere((n) => n.notificationId == '2').isRead,
          isFalse,
        );
        verify(() => mockRepository.markAsRead('1')).called(1);
      });

      test('should not affect other notifications when marking one as read',
          () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([
            mockNotification1,
            mockNotification2,
            mockNotification3,
          ], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        viewmodel.markNotAsRead('2');

        final state = container.read(allNotificationsViewModelProvider);

        expect(
          state.items.firstWhere((n) => n.notificationId == '1').isRead,
          isFalse,
        );
        expect(
          state.items.firstWhere((n) => n.notificationId == '2').isRead,
          isTrue,
        );
        expect(
          state.items.firstWhere((n) => n.notificationId == '3').isRead,
          isTrue,
        );
      });

      test('should call repository markAsRead with correct id', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        viewmodel.markNotAsRead('test-id');

        verify(() => mockRepository.markAsRead('test-id')).called(1);
      });

      test('should handle non-existent notification id gracefully', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        // Should not throw
        expect(
          () => viewmodel.markNotAsRead('non-existent'),
          returnsNormally,
        );

        verify(() => mockRepository.markAsRead('non-existent')).called(1);
      });
    });

    group('handleNotificationAction()', () {
      test('should delegate to notifications receiver', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        viewmodel.handleNotificationAction(mockNotification1);

        verify(() => mockReceiver.handleNotificationAction(mockNotification1))
            .called(1);
      });

      test('should handle different notification types', () {
        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        viewmodel.handleNotificationAction(mockNotification1); // like
        viewmodel.handleNotificationAction(mockNotification2); // follow
        viewmodel.handleNotificationAction(mockNotification3); // reply

        verify(() => mockReceiver.handleNotificationAction(mockNotification1))
            .called(1);
        verify(() => mockReceiver.handleNotificationAction(mockNotification2))
            .called(1);
        verify(() => mockReceiver.handleNotificationAction(mockNotification3))
            .called(1);
      });
    });

    group('PaginationNotifier inherited methods', () {
      test('loadInitial should set loading state', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 50));
            return ([mockNotification1], true);
          },
        );

        final viewmodel =
            container.listen(allNotificationsViewModelProvider.notifier, (_, __) {}).read();

        // Start loading
        final loadFuture = viewmodel.loadInitial();

        // State should be loading
        // await Future.delayed(Duration.zero);
        var state = container.read(allNotificationsViewModelProvider);
        expect(state.isLoading, isTrue);

        // Wait for completion
        await loadFuture;

        state = container.read(allNotificationsViewModelProvider);
        expect(state.isLoading, isFalse);
        expect(state.items.length, equals(1));
      });

      test('refresh should set refreshing state', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 50));
            return ([mockNotification2], true);
          },
        );

        final viewmodel =
            container.listen(allNotificationsViewModelProvider.notifier, (_, __) {}).read();

        // Start refresh
        final refreshFuture = viewmodel.refresh();

        // await Future.delayed(Duration.zero);
        var state = container.read(allNotificationsViewModelProvider);
        expect(state.isRefreshing, isTrue);

        await refreshFuture;

        state = container.read(allNotificationsViewModelProvider);
        expect(state.isRefreshing, isFalse);
        expect(state.items.length, equals(1));
      });

      test('loadMore should append new items', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], true),
        );
        when(() => mockRepository.fetchAllNotifications(2, 20)).thenAnswer(
          (_) async => ([mockNotification2], true),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();
        await viewmodel.loadMore();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items.length, equals(2));
        expect(state.items[0].notificationId, equals('1'));
        expect(state.items[1].notificationId, equals('2'));
      });

      test('should not load more when hasMore is false', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();
        await viewmodel.loadMore();

        // Should only call page 1, not page 2
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
        verifyNever(() => mockRepository.fetchAllNotifications(2, 20));
      });

      test('should not load more when already loading', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 100));
            return ([mockNotification1], true);
          },
        );

        final viewmodel =
            container.listen(allNotificationsViewModelProvider.notifier, (_, __) {}).read();

        final future1 = viewmodel.loadInitial();
        final future2 = viewmodel.loadMore();

        await Future.wait([future1, future2]);

        // Should only call page 1 once during initial load
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
      });

      test('refresh should reset page to 1', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], true),
        );
        when(() => mockRepository.fetchAllNotifications(2, 20)).thenAnswer(
          (_) async => ([mockNotification2], true),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();
        await viewmodel.loadMore();

        var state = container.read(allNotificationsViewModelProvider);
        expect(state.page, equals(2));

        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification3], true),
        );

        await viewmodel.refresh();

        state = container.read(allNotificationsViewModelProvider);
        expect(state.page, equals(1));
        expect(state.items.length, equals(1));
        expect(state.items[0].notificationId, equals('3'));
      });
    });

    group('Error handling', () {
      test('should set error state when fetchPage fails', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenThrow(Exception('Network error'));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.error, isNotNull);
        expect(state.isLoading, isFalse);
      });

      test('should clear error on successful refresh', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20))
            .thenThrow(Exception('Network error'));

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        var state = container.read(allNotificationsViewModelProvider);
        expect(state.error, isNotNull);

        // Now succeed on refresh
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([mockNotification1], true),
        );

        await viewmodel.refresh();

        state = container.read(allNotificationsViewModelProvider);
        expect(state.error, isNull);
        expect(state.items.isNotEmpty, isTrue);
      });
    });

    group('Edge cases', () {
      test('should handle rapid consecutive calls', () async {
        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(milliseconds: 50));
            return ([mockNotification1], true);
          },
        );

        final viewmodel =
            container.listen(allNotificationsViewModelProvider.notifier, (_, __) {}).read();

        // Make rapid consecutive calls
        final futures = [
          viewmodel.loadInitial(),
          viewmodel.loadInitial(),
          viewmodel.loadInitial(),
        ];

        await Future.wait(futures);

        // Should only fetch once due to loading guard
        verify(() => mockRepository.fetchAllNotifications(1, 20)).called(1);
      });

      test('should handle notification with null fields', () async {
        final notificationWithNulls = NotificationModel(
          notificationId: 'null-test',
          type: NotificationType.like,
          isRead: false,
          createdAt: DateTime.now(),
          actor: ActorModel(
            id: 999,
            username: 'user',
            displayName: 'User',
            profileImageUrl: null,
          ),
          postPreviewText: null,
          post: null,
        );

        when(() => mockRepository.fetchAllNotifications(1, 20)).thenAnswer(
          (_) async => ([notificationWithNulls], false),
        );

        final viewmodel =
            container.read(allNotificationsViewModelProvider.notifier);

        await viewmodel.loadInitial();

        final state = container.read(allNotificationsViewModelProvider);

        expect(state.items.length, equals(1));
        expect(state.items[0].postPreviewText, isNull);
        expect(state.items[0].post, isNull);
      });
    });
  });
}
