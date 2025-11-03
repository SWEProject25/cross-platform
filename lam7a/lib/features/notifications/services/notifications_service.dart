import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/services/notifications_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_service.g.dart';

@riverpod
NotificationsAPIService notificationsAPIService(Ref ref) {
  return NotificationsAPIServiceMock();
}

abstract class NotificationsAPIService {
  Future<List<NotificationModel>> getNotifications();
}