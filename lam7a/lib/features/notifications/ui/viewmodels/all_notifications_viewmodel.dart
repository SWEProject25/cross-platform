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

final allNotificationsViewModelProvider =
    NotifierProvider.autoDispose<
      AllNotificationsViewModel,
      PaginationState<NotificationModel>
    >(() => AllNotificationsViewModel());

class AllNotificationsViewModel extends PaginationNotifier<NotificationModel> {
  late final NotificationsRepository _notificationsRepository;
  late NotificationsReceiver _notificationsReceiver;
  final Logger _logger = getLogger(AllNotificationsViewModel);

  @override
  PaginationState<NotificationModel> build() {
    _logger.i("Init AllNotificationsViewModel");
    _notificationsRepository = ref.read(notificationsRepositoryProvider);
    _notificationsReceiver = ref.read(notificationsReceiverProvider);

    _notificationsRepository.markAllAsRead();

    Future.microtask(() async {
      try {
        await loadInitial();
      } catch (e) {
        _logger.e("Error loading initial notifications: $e");
      }
    });

    return const PaginationState<NotificationModel>();
  }

  @override
  Future<(List<NotificationModel> data, bool hasMore)> fetchPage(
    int page,
  ) async {
    try {
      _logger.i("Fetching page $page of all notifications");
      var res = await _notificationsRepository.fetchAllNotifications(page, 20);
      _logger.i(
        "Fetched ${res.$1.length} notifications on page $page, hasMore: ${res.$2}",
      );
      return res;
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
    _logger.i("Marking All notifications As Read");
    _notificationsRepository.markAllAsRead();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(unReadNotificationCountProvider.notifier)
          .updateNotificationsCount(reset: true);

      var newState = state.copyWith(
        items: state.items.map((n) => n.copyWith(isRead: true)).toList(),
      );
      state = newState;
    });
  }

  void handleNotificationAction(NotificationModel notification) {
    _notificationsReceiver.handleNotificationAction(notification);
  }
}
