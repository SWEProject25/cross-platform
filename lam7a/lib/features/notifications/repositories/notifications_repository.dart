import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_repository.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(ref.read(notificationsAPIServiceProvider));
}

class NotificationsRepository {

  final NotificationsAPIService _apiService;

  NotificationsRepository(this._apiService);

  Future<List<NotificationModel>> fetchNotifications() async {
    return await _apiService.getNotifications();
  }
}