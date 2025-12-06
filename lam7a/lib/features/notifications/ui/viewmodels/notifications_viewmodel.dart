import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/common/providers/pagination_notifier.dart';
import 'package:lam7a/features/common/states/pagination_state.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/proveriders/new_notifications_count.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/utils.dart';
import 'package:logger/logger.dart';

final notificationsViewModelProvider = NotifierProvider<
  NotificationsViewModel, PaginationState<NotificationModel>>(() => NotificationsViewModel());

class NotificationsViewModel extends PaginationNotifier<NotificationModel> {
  late final NotificationsRepository _notificationsRepository;
  late NotificationsReceiver _notificationsReceiver;
  final Logger _logger = getLogger(NotificationsViewModel);
  
  @override
  PaginationState<NotificationModel> build() {
    _logger.i("Init NotificationsViewModel");
    _notificationsRepository = ref.read(notificationsRepositoryProvider);
    _notificationsReceiver = ref.read(notificationsReceiverProvider);

    _notificationsRepository.markAllAsRead();

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

  void markAllAsRead(){
    _logger.i("Marking All notifications As Read");
    _notificationsRepository.markAllAsRead();
    ref.read(unReadNotificationCountProvider.notifier).updateNotificationsCount(reset: true);
  }

  void handleNotificationAction(NotificationModel notification) {
    _notificationsReceiver.handleNotificationAction(notification);
  }
}

