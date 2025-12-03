import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/utils.dart';

final notificationsViewModelProvider = NotifierProvider<
  NotificationsViewModel, PaginationState<NotificationModel>>(() => NotificationsViewModel());

class NotificationsViewModel extends PaginationNotifier<NotificationModel> {
  late final NotificationsRepository _notificationsRepository;

  @override
  PaginationState<NotificationModel> build() {
    _notificationsRepository = ref.read(notificationsRepositoryProvider);

    Future.microtask(() async {
      await loadInitial();
    });

    return const PaginationState<NotificationModel>();
  }

  @override
  Future<(List<NotificationModel> data, bool hasMore)> fetchPage(int page){
    return _notificationsRepository.fetchNotifications(page, 20);
  }

  @override
  List<NotificationModel> mergeList(List<NotificationModel> a, List<NotificationModel> b){
    return [...a, ...b];
  }

  AsyncValue<List<NotificationModel>> allNotifications() => state.items.isEmpty
    ? const AsyncValue.loading()
    : AsyncValue.data(state.items);

  AsyncValue<List<NotificationModel>> mentionNotifications() =>
    allNotifications().whenData(
      (list) => list.where((n) => isPostViewedNotification(n.type)).toList(),
    );

  void handleNotificationAction(NotificationModel notification) {
    NotificationsReceiver().handleNotificationAction(notification);
  }
}

