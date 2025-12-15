
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/all_notifications_viewmodel.dart';
import 'package:lam7a/features/notifications/ui/viewmodels/mention_notifications_viewmodel.dart';
import 'package:logger/logger.dart';

// @riverpod

final unReadNotificationCountProvider = NotifierProvider<NewNotificationCount, int>(
  NewNotificationCount.new,
);


class NewNotificationCount extends Notifier<int> {
  final Logger _logger = getLogger(NewNotificationCount);
  @override
  int build() {
    ref.keepAlive();
    AuthState auth = ref.watch(authenticationProvider);

    _logger.i("Initialized NewNotificationCount");
    Future.microtask(() async {
      if(auth.user != null){
         updateNotificationsCount();
      }
    });

    return 0;
  }

  void notifyViewModels() {
    ref.read(allNotificationsViewModelProvider.notifier).refresh();
    ref.read(mentionNotificationsViewModelProvider.notifier).refresh();
  }
  
  void updateNotificationsCount({bool reset = false, bool increament = false}) async {
    if (reset ) state = 0;
    else if (increament)  state = state+1;
  
    _logger.i("Updating Notification Unread Count");
    var count = await ref.read(notificationsRepositoryProvider).getUnReadCount();
    _logger.i("Updated Count With $count");

    state = count;
  }
}