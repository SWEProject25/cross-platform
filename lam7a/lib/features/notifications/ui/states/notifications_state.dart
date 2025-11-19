import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';

part 'notifications_state.freezed.dart';

@freezed
abstract class NotificationsState with _$NotificationsState {
  const factory NotificationsState({
    @Default(AsyncValue.loading()) AsyncValue<List<NotificationModel>> notifications,
  }) = _NotificationsState;
}