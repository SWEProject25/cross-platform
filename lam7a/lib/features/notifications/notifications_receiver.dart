import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifiactions_calls.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/firebase_options.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_receiver.g.dart';

@Riverpod(keepAlive: true)
void fcmTokenUpdater(Ref ref) {
  AuthState authState = ref.watch(authenticationProvider);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  var subscription = messaging.onTokenRefresh.listen((newToken) {
    handleFCMTokenUpdate(messaging, authState, ref);
  });

  ref.onDispose(() {
    subscription.cancel();
  });

  handleFCMTokenUpdate(messaging, authState, ref);
}

void handleFCMTokenUpdate(
  FirebaseMessaging messaging,
  AuthState authState,
  Ref ref,
) {
  var logger = getLogger(NotificationsReceiver);
  if (authState.user != null) {
    messaging.getToken().then((String? token) {
      if (token != null) {
        ref.read(notificationsRepositoryProvider).setFCMToken(token);
        logger.i("FCM Token sent to server: $token");
      }
    });
  } else {
    ref.read(notificationsRepositoryProvider).removeFCMToken();
    logger.i("FCM Token removed from server");
  }
}

@riverpod
NotificationsReceiver notificationsReceiver(Ref ref){
  return NotificationsReceiver(ref.read(unReadNotificationCountProvider.notifier));
}

class NotificationsReceiver {
  Logger logger = getLogger(NotificationsReceiver);
  NewNotificationCount _newNotificationCount;

  NotificationsReceiver(this._newNotificationCount);

  RemoteMessage? _initialMessage;


  Future<void> initialize() async {
    logger.i("NotificationsReceiver initialized");

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    _initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    logger.i("Initial message: $_initialMessage");

    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(
      _onNotificationTapped,
    );

    requestPermission();
  }

  void handleInitialMessageIfAny() {
    if (_initialMessage != null) {
      _onNotificationTapped(_initialMessage!);
      _initialMessage = null;
    }
  }


  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logger.i('User granted permission: ${settings.authorizationStatus}');

    String? token = await messaging.getToken();
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
    await Firebase.initializeApp();

    logger.i("Handling a background message: ${message.messageId}");
    logger.i('Message data: ${message.data.toString()} ${message.data.runtimeType.toString()}');
    NotificationModel notifiacation = NotificationModel.fromJson(message.data);


    handleNotificationAction(notifiacation);
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
        if (notifiacation.post != null) {
          handleLikeNotificationAction(notifiacation.post!.id);
        }
        break;
      case NotificationType.follow:
        handleFollowNotificationAction(notifiacation.actor.username);
        break;

      case NotificationType.repost:
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
