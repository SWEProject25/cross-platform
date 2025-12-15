import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:logger/logger.dart';

final mentionNotificationsViewModelProvider =
    NotifierProvider<
      MentionNotificationsViewmodel,
      PaginationState<NotificationModel>
    >(() => MentionNotificationsViewmodel());

class MentionNotificationsViewmodel
    extends PaginationNotifier<NotificationModel> {
  late final NotificationsRepository _notificationsRepository;
  late NotificationsReceiver _notificationsReceiver;
  final Logger _logger = getLogger(MentionNotificationsViewmodel);

  @override
  PaginationState<NotificationModel> build() {
    _logger.i("Init MentionNotificationsViewmodel");
    _notificationsRepository = ref.read(notificationsRepositoryProvider);
    _notificationsReceiver = ref.read(notificationsReceiverProvider);

    // _notificationsRepository.markAllAsRead();

    Future.microtask(() async {
      try {
        await loadInitial();
      } catch (e) {
        _logger.e("Error loading initial mention notifications: $e");
      }
    });

    return const PaginationState<NotificationModel>();
  }

  @override
  Future<(List<NotificationModel> data, bool hasMore)> fetchPage(
    int page,
  ) async {
    try {
      _logger.i("Fetching page $page of mention notifications");
      return _notificationsRepository.fetchMentionNotifications(page, 20);
    } catch (e) {
      _logger.e("Error logging fetch page: $e");
    }
    return ([] as List<NotificationModel>, false);
  }

  @override
  List<NotificationModel> mergeList(
    List<NotificationModel> a,
    List<NotificationModel> b,
  ) {
    return [...a, ...b];
  }

  void markAllAsRead() {
    _logger.i("Marking All Mention notifications As Read");
    _notificationsRepository.markAllAsRead();
    ref
        .read(unReadNotificationCountProvider.notifier)
        .updateNotificationsCount(reset: true);

    state = state.copyWith(
      items: state.items.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }
    void markNotAsRead(String id) {
      var newState = state.copyWith(
        items: state.items.map((n) {
          if (n.notificationId == id) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList(),
      );
      state = newState;
      _notificationsRepository.markAsRead(id);
  }

  void handleNotificationAction(NotificationModel notification) {
    _notificationsReceiver.handleNotificationAction(notification);
  }
}
