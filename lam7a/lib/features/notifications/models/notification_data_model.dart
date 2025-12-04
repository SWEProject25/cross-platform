import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationData {
  final String? title;
  final String? body;
  final String? route;
  final Map<String, dynamic> data;

  NotificationData({
    this.title,
    this.body,
    this.route,
    this.data = const {},
  });

  /// Create DTO from RemoteMessage
  factory NotificationData.fromRemoteMessage(RemoteMessage message) {
    return NotificationData(
      title: message.notification?.title,
      body: message.notification?.body,
      route: message.data['route'],
      data: message.data,
    );
  }

  /// Create DTO from Firebase data-only message map
  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      title: map['title'],
      body: map['body'],
      route: map['route'],
      data: map,
    );
  }

  /// Convert back to JSON (useful for local persistence)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'route': route,
      'data': data,
    };
  }

  @override
  String toString() {
    return 'NotificationData(title: $title, body: $body, route: $route, data: $data)';
  }
}
