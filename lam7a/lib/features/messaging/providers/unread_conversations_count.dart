
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/repository/conversations_repositories.dart';
import 'package:lam7a/features/messaging/services/messages_socket_service.dart';
import 'package:logger/logger.dart';

final unReadConversationsCountProvider = NotifierProvider<UnReadConversationsCount, int>(
  UnReadConversationsCount.new,
);

class UnReadConversationsCount extends Notifier<int> {
  final Logger _logger = getLogger(UnReadConversationsCount);
  StreamSubscription? _sub;
  @override
  int build() {
    ref.keepAlive();
    AuthState auth = ref.watch(authenticationProvider);
    _sub = ref.read(messagesSocketServiceProvider).incomingMessagesNotifications.listen((event) {
      refresh();
    });

    _logger.i("Initialized NewNotificationCount");

    Future.microtask(() async {
      if(auth.user != null){
         refresh();
      }
    });

    ref.onDispose(() {
      _sub?.cancel();
      _logger.i("Disposed NewNotificationCount");
    });

    return 0;
  }
  
  void refresh({bool reset = false, bool increament = false}) async {
    if (reset ) state = 0;
    else if (increament)  state = state+1;
  
    var count = await ref.read(conversationsRepositoryProvider).getAllUnseenConversations();
    _logger.i("Unread conversations count updated: $count from ${state}");
    state = count;
  }
}