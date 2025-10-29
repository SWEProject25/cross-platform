import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';

part 'notifications_state.freezed.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const NotificationsState._();

  const factory NotificationsState({
    @Default(AsyncValue.loading()) AsyncValue<List<NotificationModel>> notifications,
  }) = _NotificationsState;

  AsyncValue<List<NotificationModel>> get allNotifications => notifications;

  AsyncValue<List<NotificationModel>> get mentionNotifications =>
      notifications.whenData(
        (list) => list.where((n) => n.type == NotificationType.mention).toList(),
      );
}