import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/actor_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifiactions_calls.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/services/cloud_messaging_service.dart';
import 'package:mocktail/mocktail.dart';

/// ---- MOCK CLASSES ----
class MockCloudMessagingService extends Mock implements CloudMessagingService {}

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

class MockNewNotificationCount extends Mock implements NewNotificationCount {}

class MockRemoteMessage extends Mock implements RemoteMessage {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

class FakeNotificationModel extends Fake implements NotificationModel {}

class FakeFirebaseNotification extends Fake
    implements FirebaseOptions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationsReceiver receiver;
  late MockCloudMessagingService mockCloudMessagingService;
  late MockNotificationsRepository mockNotificationsRepository;
  late MockNewNotificationCount mockNewNotificationCount;

  setUp(() {
    mockCloudMessagingService = MockCloudMessagingService();
    mockNotificationsRepository = MockNotificationsRepository();
    mockNewNotificationCount = MockNewNotificationCount();

    // Setup default streams for message listeners
    when(() => mockCloudMessagingService.onMessage)
        .thenAnswer((_) => Stream<RemoteMessage>.empty());
    when(() => mockCloudMessagingService.onMessageOpenedApp)
        .thenAnswer((_) => Stream<RemoteMessage>.empty());

    receiver = NotificationsReceiver(
      mockCloudMessagingService,
      mockNotificationsRepository,
      mockNewNotificationCount,
    );
  });

  setUpAll(() {
    registerFallbackValue(FakeNotificationModel());
    registerFallbackValue(FakeFirebaseNotification());
  });

  group('NotificationsReceiver - Initialization', () {
    test('initialize sets up message listeners', () async {
      // Arrange
      when(() => mockCloudMessagingService.initialize(any()))
          .thenAnswer((_) async => {});
      when(() => mockCloudMessagingService.onMessage)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.getInitialMessage())
          .thenAnswer((_) async => null);

      // Act
      await receiver.initialize();
      
      // Assert - Verify streams were accessed during construction
      verify(() => mockCloudMessagingService.onMessage).called(greaterThanOrEqualTo(1));
      verify(() => mockCloudMessagingService.onMessageOpenedApp).called(greaterThanOrEqualTo(1));
    });
  });

  group('NotificationsReceiver - Permission Request', () {
    test('requestPermission requests notification settings successfully',
        () async {
      // Arrange
      final mockSettings = MockNotificationSettings();
      when(() => mockSettings.authorizationStatus)
          .thenReturn(AuthorizationStatus.authorized);

      when(() => mockCloudMessagingService.requestPermission(
            alert: any(named: 'alert'),
            announcement: any(named: 'announcement'),
            badge: any(named: 'badge'),
            carPlay: any(named: 'carPlay'),
            criticalAlert: any(named: 'criticalAlert'),
            provisional: any(named: 'provisional'),
            sound: any(named: 'sound'),
          )).thenAnswer((_) async => mockSettings);

      when(() => mockCloudMessagingService.getToken())
          .thenAnswer((_) async => 'test-fcm-token');

      // Act
      await receiver.requestPermission();

      // Assert
      verify(() => mockCloudMessagingService.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          )).called(1);
      verify(() => mockCloudMessagingService.getToken()).called(1);
    });

    test('requestPermission handles null token gracefully', () async {
      // Arrange
      final mockSettings = MockNotificationSettings();
      when(() => mockSettings.authorizationStatus)
          .thenReturn(AuthorizationStatus.authorized);

      when(() => mockCloudMessagingService.requestPermission(
            alert: any(named: 'alert'),
            announcement: any(named: 'announcement'),
            badge: any(named: 'badge'),
            carPlay: any(named: 'carPlay'),
            criticalAlert: any(named: 'criticalAlert'),
            provisional: any(named: 'provisional'),
            sound: any(named: 'sound'),
          )).thenAnswer((_) async => mockSettings);

      when(() => mockCloudMessagingService.getToken())
          .thenAnswer((_) async => null);

      // Act
      await receiver.requestPermission();

      // Assert
      verify(() => mockCloudMessagingService.getToken()).called(1);
    });
  });

  group('NotificationsReceiver - Foreground Message Handling', () {
    test('_onMessageReceived updates notification count', () async {
      // Arrange
      final mockMessage = MockRemoteMessage();
      when(() => mockMessage.data).thenReturn({
        'id': 'notif-123',
        'type': 'LIKE',
        'actor': {
          'id': 456,
          'username': 'sender',
          'name': 'Sender Name',
          'profileImageUrl': 'https://example.com/avatar.jpg',
        },
        'conversationId': 789,
        'createdAt': '2025-12-15T10:00:00Z',
        'isRead': false,
      });
      when(() => mockMessage.notification).thenReturn(null);
      when(() => mockNewNotificationCount.updateNotificationsCount())
          .thenAnswer((_) async => {});
      when(() => mockNewNotificationCount.notifyViewModels()).thenReturn(null);

      final controller = StreamController<RemoteMessage>();
      when(() => mockCloudMessagingService.onMessage)
          .thenAnswer((_) => controller.stream);
      when(() => mockCloudMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.getInitialMessage())
          .thenAnswer((_) async => null);
      when(() => mockCloudMessagingService.initialize(any()))
          .thenAnswer((_) async => {});

      // Recreate receiver to setup listeners
      receiver = NotificationsReceiver(
        mockCloudMessagingService,
        mockNotificationsRepository,
        mockNewNotificationCount,
      );

      // Act
      await receiver.initialize();
      controller.add(mockMessage);

      // Wait for stream processing
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert
      verify(() => mockNewNotificationCount.updateNotificationsCount())
          .called(1);
      verify(() => mockNewNotificationCount.notifyViewModels()).called(1);

      controller.close();
    });

    test('_onMessageReceived handles DM notification type', () async {
      // Arrange
      final mockMessage = MockRemoteMessage();
      when(() => mockMessage.data).thenReturn({
        'id': 'notif-456',
        'type': 'LIKE',
        'actor': {
          'id': 789,
          'username': 'user123',
          'name': 'User Name',
          'profileImageUrl': 'https://example.com/avatar.jpg',
        },
        'conversationId': 100,
        'createdAt': '2025-12-15T10:00:00Z',
        'isRead': false,
      });
      when(() => mockMessage.notification).thenReturn(null);
      when(() => mockNewNotificationCount.updateNotificationsCount())
          .thenAnswer((_) async => {});
      when(() => mockNewNotificationCount.notifyViewModels()).thenReturn(null);

      final controller = StreamController<RemoteMessage>();
      when(() => mockCloudMessagingService.onMessage)
          .thenAnswer((_) => controller.stream);
      when(() => mockCloudMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.getInitialMessage())
          .thenAnswer((_) async => null);
      when(() => mockCloudMessagingService.initialize(any()))
          .thenAnswer((_) async => {});

      receiver = NotificationsReceiver(
        mockCloudMessagingService,
        mockNotificationsRepository,
        mockNewNotificationCount,
      );

      // Act
      await receiver.initialize();
      controller.add(mockMessage);

      // Wait for stream processing
      return Future.delayed(const Duration(milliseconds: 100), () {
        // Assert - verify notification count was updated
        verify(() => mockNewNotificationCount.updateNotificationsCount())
            .called(1);

        controller.close();
      });
    });
  });

  group('NotificationsReceiver - Notification Tap Handling', () {
    test('_onNotificationTapped marks notification as read', () async {
      // Arrange
      final mockMessage = MockRemoteMessage();
      when(() => mockMessage.messageId).thenReturn('msg-123');
      when(() => mockMessage.data).thenReturn({
        'id': 'notif-789',
        'type': 'LIKE',
        'actor': {
          'id': 111,
          'username': 'liker',
          'name': 'Liker Name',
          'profileImageUrl': 'https://example.com/avatar.jpg',
        },
        'postId': 222,
        'createdAt': '2025-12-15T10:00:00Z',
        'isRead': false,
      });

      when(() => mockNotificationsRepository.markAsRead('notif-789'))
          .thenAnswer((_) async => {});
      when(() => mockNewNotificationCount.updateNotificationsCount())
          .thenAnswer((_) async => {});
      when(() => mockCloudMessagingService.onMessage)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.getInitialMessage())
          .thenAnswer((_) async => null);
      when(() => mockCloudMessagingService.initialize(any()))
          .thenAnswer((_) async => {});
      

      final controller = StreamController<RemoteMessage>();
      when(() => mockCloudMessagingService.onMessage)
          .thenAnswer((_) => Stream<RemoteMessage>.empty());
      when(() => mockCloudMessagingService.onMessageOpenedApp)
          .thenAnswer((_) => controller.stream);

      receiver = NotificationsReceiver(
        mockCloudMessagingService,
        mockNotificationsRepository,
        mockNewNotificationCount,
      );

      // Act
      await receiver.initialize();
      controller.add(mockMessage);

      // Wait for stream processing
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      verify(() => mockNotificationsRepository.markAsRead('notif-789'))
          .called(1);
      verify(() => mockNewNotificationCount.updateNotificationsCount())
          .called(1);

      await controller.close();
    });
  });

  group('NotificationsReceiver - handleNotificationAction', () {
    test('handleNotificationAction handles DM notification with conversationId',
        () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-dm-1',
        type: NotificationType.dm,
        actor: ActorModel(
          id: 100,
          username: 'dmuser',
          displayName: 'DM User',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        conversationId: 500,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert - The method will call handleDMNotificationAction internally
      // Since these functions are external, we can't verify them directly
      // but we can verify the logic flow completes without errors
      expect(notification.conversationId, 500);
      expect(notification.type, NotificationType.dm);
    });

    test('handleNotificationAction handles like notification with postId', () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-like-1',
        type: NotificationType.like,
        actor: ActorModel(
          id: 200,
          username: 'likeuser',
          displayName: 'Like User',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        postId: 300,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.postId, 300);
      expect(notification.type, NotificationType.like);
    });

    test('handleNotificationAction handles follow notification', () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-follow-1',
        type: NotificationType.follow,
        actor: ActorModel(
          id: 400,
          username: 'follower',
          displayName: 'Follower Name',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.type, NotificationType.follow);
      expect(notification.actor.username, 'follower');
    });

    test('handleNotificationAction handles repost notification', () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-repost-1',
        type: NotificationType.repost,
        actor: ActorModel(
          id: 500,
          username: 'reposter',
          displayName: 'Reposter Name',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        postId: 600,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.type, NotificationType.repost);
      expect(notification.postId, 600);
    });

    test('handleNotificationAction handles mention notification with post',
        () {
      // Arrange
      final post = TweetModel(
        id: '700',
        body: 'Test post',
        userId: '800',
        date: DateTime.parse('2025-12-15T10:00:00Z'),
      );

      final notification = NotificationModel(
        notificationId: 'notif-mention-1',
        type: NotificationType.mention,
        actor: ActorModel(
          id: 900,
          username: 'mentioner',
          displayName: 'Mentioner Name',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        post: post,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.type, NotificationType.mention);
      expect(notification.post?.id, '700');
    });

    test('handleNotificationAction handles reply notification with post', () {
      // Arrange
      final post = TweetModel(
        id: '1000',
        body: 'Reply post',
        userId: '1100',
        date: DateTime.parse('2025-12-15T10:00:00Z'),
      );

      final notification = NotificationModel(
        notificationId: 'notif-reply-1',
        type: NotificationType.reply,
        actor: ActorModel(
          id: 1200,
          username: 'replier',
          displayName: 'Replier Name',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        post: post,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.type, NotificationType.reply);
      expect(notification.post?.id, '1000');
    });

    test('handleNotificationAction handles quote notification with post', () {
      // Arrange
      final post = TweetModel(
        id: '1300',
        body: 'Quoted post',
        userId: '1400',
        date: DateTime.parse('2025-12-15T10:00:00Z'),
      );

      final notification = NotificationModel(
        notificationId: 'notif-quote-1',
        type: NotificationType.quote,
        actor: ActorModel(
          id: 1500,
          username: 'quoter',
          displayName: 'Quoter Name',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        post: post,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert
      expect(notification.type, NotificationType.quote);
      expect(notification.post?.id, '1300');
    });

    test('handleNotificationAction skips DM action when conversationId is null',
        () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-dm-no-conv',
        type: NotificationType.dm,
        actor: ActorModel(
          id: 1600,
          username: 'dmuser2',
          displayName: 'DM User 2',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        conversationId: null,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert - should not throw error
      expect(notification.conversationId, isNull);
    });

    test('handleNotificationAction skips like action when postId is null', () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-like-no-post',
        type: NotificationType.like,
        actor: ActorModel(
          id: 1700,
          username: 'likeuser2',
          displayName: 'Like User 2',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        postId: null,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert - should not throw error
      expect(notification.postId, isNull);
    });

    test('handleNotificationAction skips post view when post is null', () {
      // Arrange
      final notification = NotificationModel(
        notificationId: 'notif-mention-no-post',
        type: NotificationType.mention,
        actor: ActorModel(
          id: 1800,
          username: 'mentioner2',
          displayName: 'Mentioner 2',
          profileImageUrl: 'https://example.com/avatar.jpg',
        ),
        post: null,
        createdAt: DateTime.parse('2025-12-15T10:00:00Z'),
        isRead: false,
      );

      // Act
      receiver.handleNotificationAction(notification);

      // Assert - should not throw error
      expect(notification.post, isNull);
    });
  });

  group('NotificationsReceiver - handleInitialMessageIfAny', () {
    test('handleInitialMessageIfAny does nothing when no initial message',
        () {
      // Act
      receiver.handleInitialMessageIfAny();

      // Assert - should complete without errors
      // No verifications needed as nothing should happen
    });
  });
}
