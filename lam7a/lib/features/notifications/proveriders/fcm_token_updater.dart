import 'dart:async';

import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/repositories/notifications_repository.dart';
import 'package:lam7a/features/notifications/services/cloud_messaging_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fcm_token_updater.g.dart';

@riverpod
class FCMTokenUpdater extends _$FCMTokenUpdater {

  StreamSubscription<String>? _tokenSub;

  @override
  void build() {
    ref.watch(authenticationProvider);
    var messaging = ref.read(cloudMessagingServiceProvider);

    _tokenSub ??= messaging.onTokenRefresh.listen((_) {
      _updateToken();
    });


    ref.onDispose(() {
      _tokenSub?.cancel();
    });

    _updateToken();
  }

  Future<void> _updateToken() async {
    if (ref.read(authenticationProvider).user == null) {
      getLogger(NotificationsReceiver).i("FCM Token removed from server");

      ref.read(notificationsRepositoryProvider).removeFCMToken();
      return;
    }

    await ref.read(notificationsReceiverProvider).requestPermission();

    var token = await ref.read(cloudMessagingServiceProvider).getToken();
    if (token == null) {
      getLogger(NotificationsReceiver).e("Failed to get FCM token");
      return;
    }

    ref.read(notificationsRepositoryProvider).setFCMToken(token);
  }
}
