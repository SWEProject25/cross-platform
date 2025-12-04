import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';
import 'package:lam7a/features/notifications/services/notifications_service_impl.dart';
import 'package:lam7a/features/notifications/services/notifications_service_mock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_service.g.dart';

@riverpod
NotificationsAPIService notificationsAPIService(Ref ref) {
  return NotificationsAPIServiceImpl(ref.read(apiServiceProvider));
  // return MockNotificationsAPIService();
}

abstract class NotificationsAPIService {
  Future<NotificationsResponse> getNotifications([int page = 1, int limit = 20]);
  void sendFCMToken(String token);
  void removeFCMToken(String token);
}