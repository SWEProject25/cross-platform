import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/notifications/notifiactions_calls.dart';
import 'package:lam7a/firebase_options.dart';
import 'package:lam7a/main.dart';

class NotificationsReceiver {
  NotificationsReceiver._privateConstructor();
  static final NotificationsReceiver _instance =
      NotificationsReceiver._privateConstructor();
  factory NotificationsReceiver() {
    return _instance;
  }

  void receiveNotification(String message) {
    // Logic to handle the received notification
    print("Notification received: $message");
  }

  void initialize() async {
    print("NotificationsReceiver initialized");

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    requestPermission();

    FirebaseMessaging.onMessage.listen(_onMessageReceived);
    FirebaseMessaging.onMessageOpenedApp.listen(
      _firebaseMessagingBackgroundHandler,
    );
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

    print('User granted permission: ${settings.authorizationStatus}');

    String? token = await messaging.getToken();
    print("FCM Token: $token");
  }

  void _onMessageReceived(RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
        'Message also contained a notification: ${message.notification?.toMap().toString()}',
      );
    }

    switch (message.data['type']) {
      case 'dm':
        showDMNotification(
          sender: message.data['sender'] ?? 'Unknown',
          message: message.notification?.body ?? '',
          avatarUrl: message.data['avatarUrl'] ?? '',
          onTap: () {
            handleDMNotificationTap(
              userId: int.tryParse(message.data['userId'] ?? ''),
              conversationId: int.tryParse(
                message.data['conversationId'] ?? '',
              ),
            );
          },
        );
        break;
      default:
        print("Unknown notification type");
    }
  }

  Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");

    switch (message.data['type']) {
      case 'dm':
        handleDMNotificationTap(
          userId: int.tryParse(message.data['userId'] ?? ''),
          conversationId: int.tryParse(message.data['conversationId'] ?? ''),
        );
        break;
      default:
        print("Unknown notification type");
    }
  }

  void handleDMNotificationTap({int? userId, int? conversationId}) {
    navigatorKey.currentState?.pushNamed(
      ChatScreen.routeName,
      arguments: {'conversationId': conversationId, 'userId': userId},
    );
  }
}
