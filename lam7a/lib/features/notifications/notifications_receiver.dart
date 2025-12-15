import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifiactions_calls.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/services/cloud_messaging_service.dart';
import 'package:lam7a/firebase_options.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_receiver.g.dart';

@riverpod
NotificationsReceiver notificationsReceiver(Ref ref){
  ref.keepAlive();
  return NotificationsReceiver(ref.read(cloudMessagingServiceProvider), ref.read(notificationsRepositoryProvider), ref.read(unReadNotificationCountProvider.notifier));
}

class NotificationsReceiver {
  Logger logger = getLogger(NotificationsReceiver);

  final CloudMessagingService _cloudMessagingService;
  final NotificationsRepository _notificationsRepository;
  final NewNotificationCount _newNotificationCount;
  
  NotificationsReceiver(this._cloudMessagingService, this._notificationsRepository, this._newNotificationCount);

  RemoteMessage? _initialMessage;


  Future<void> initialize() async {
    logger.i("NotificationsReceiver initialized");

    await _cloudMessagingService.initialize(DefaultFirebaseOptions.currentPlatform);

    _initialMessage = await _cloudMessagingService.getInitialMessage();
    logger.i("Initial message: $_initialMessage");

    _cloudMessagingService.onMessage.listen(_onMessageReceived);
    _cloudMessagingService.onMessageOpenedApp.listen(_onNotificationTapped);

  }

  void handleInitialMessageIfAny() {
    logger.i("Handling initial message if any.");
    if (_initialMessage != null) {
      logger.i("Handling initial message: $_initialMessage");
      _onNotificationTapped(_initialMessage!);
      _initialMessage = null;
    }
  }


  Future<void> requestPermission() async {
    NotificationSettings settings = await _cloudMessagingService.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.i('User granted permission: ${settings.authorizationStatus}');

    String? token = await _cloudMessagingService.getToken();
    logger.i("FCM Token: $token");
  }

  void _onMessageReceived(RemoteMessage message) {
    _newNotificationCount.updateNotificationsCount();
    _newNotificationCount.notifyViewModels();

    logger.i('Got a message whilst in the foreground!');
    logger.i('Message data: ${message.data.toString()}');
    logger.i('Message data: ${message.data.toString()} ${message.data.runtimeType.toString()}');


    if (message.notification != null) {
      logger.i(
        'Message also contained a notification: ${message.notification?.toMap().toString()}',
      );
    } 

    NotificationModel notifiacation = NotificationModel.fromJson(message.data);

    switch (notifiacation.type) {
      case NotificationType.dm:
        showDMNotification(notifiacation);
        break;
      default:
        logger.i("Unhandled notification type in foreground");
    }
  }

  Future<void> _onNotificationTapped(
    RemoteMessage message,
  ) async {
    logger.i("Initializing Firebase in background message handler");
    await _cloudMessagingService.initialize(DefaultFirebaseOptions.currentPlatform);

    logger.i("Handling a background message: ${message.messageId}");
    logger.i('Message data: ${message.data.toString()} ${message.data.runtimeType.toString()}');
    NotificationModel notifiacation = NotificationModel.fromJson(message.data);

    handleNotificationAction(notifiacation);

    _notificationsRepository.markAsRead(notifiacation.notificationId);
    _newNotificationCount.updateNotificationsCount();
  }

  void handleNotificationAction(NotificationModel notifiacation) {
    switch (notifiacation.type) {
      case NotificationType.dm:
        if (notifiacation.conversationId != null) {
          handleDMNotificationAction(notifiacation.conversationId!, notifiacation.actor.id);
        }
        break;
      case NotificationType.like:
        if (notifiacation.postId != null) {
          handleLikeNotificationAction(notifiacation.postId?.toString() ?? "");
        }
        break;
      case NotificationType.follow:
        handleFollowNotificationAction(notifiacation.actor.username);
        break;

      case NotificationType.repost:
        handleRetweetedNotificationAction(notifiacation.postId?.toString() ?? "");
        break;
      case NotificationType.mention:
      case NotificationType.reply:
      case NotificationType.quote:
        if (notifiacation.post != null) {
          handlePostViewNotificationAction(notifiacation.post!.id);
        }
        break;
      default:
        print("Unknown notification type");
    }
  }
}
