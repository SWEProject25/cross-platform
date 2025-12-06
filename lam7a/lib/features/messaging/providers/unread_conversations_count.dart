
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';

// @riverpod

final unReadConversationsCountProvider = NotifierProvider<UnReadConversationsCount, int>(
  UnReadConversationsCount.new,
);


class UnReadConversationsCount extends Notifier<int> {
  late NotificationsRepository repository;

  @override
  int build() {
    repository = ref.read(notificationsRepositoryProvider);

    Future.microtask(() async {
      // updateNotificationsCount();
    });

    return 0;
  }
  
  // void updateNotificationsCount() async {
  //   var count = await repository.getUnReadCount();
  //   state = count;
  // }
}