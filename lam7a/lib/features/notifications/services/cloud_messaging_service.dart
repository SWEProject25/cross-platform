// coverage:ignore-file

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cloudMessagingServiceProvider = Provider<CloudMessagingService>(
  (ref) {
    ref.keepAlive();
    return CloudMessagingService();
  },
);

class CloudMessagingService {
  late FirebaseMessaging _messaging;

  Future<void> initialize(FirebaseOptions options) async {
    await Firebase.initializeApp(options: options);
    _messaging = FirebaseMessaging.instance;
  }

  Future<RemoteMessage?> getInitialMessage() async {
    return await _messaging.getInitialMessage();
  }

  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) async {
    return await _messaging.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}
