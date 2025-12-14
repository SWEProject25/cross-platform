import 'package:flutter/material.dart';
import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/messaging/active_chat_screens.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/notifications_receiver.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_overlay.dart';
import 'package:lam7a/main.dart';
import 'package:overlay_support/overlay_support.dart';

void showDMNotification(NotificationModel notifiacation) {
  int conversationId = notifiacation.conversationId!;
  int userId = notifiacation.actor.id;

  if(ActiveChatScreens.isActive(conversationId)) {
    getLogger(NotificationsReceiver).i("Chat screen for conversationId: $conversationId is already active. Skipping DM notification overlay.");
    return;
  }

  late OverlaySupportEntry entry;
  entry = showOverlayNotification(
    (context) => SafeArea(
      child: SlideDismissible(
        key: UniqueKey(), // required for SlideDismissible
        direction: DismissDirection.up,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TwitterDMNotification.DMNotificationOverlay(
            sender: notifiacation.actor.displayName,
            message: notifiacation.textMessage ?? 'Unknown message',
            avatarUrl: notifiacation.actor.profileImageUrl ?? '',
            onTap: () {
              print("Notification tapped");

              handleDMNotificationAction(
                conversationId,
                userId,
              );

              entry.dismiss();
            },
          ),
        ),
      ),
    ),
    duration: Duration(seconds: 3), // auto-dismiss after this duration
  );
}

void handleDMNotificationAction(int conversationId, int userId) {
  getLogger(
    NotificationsReceiver,
  ).i("Handling DM notification action for conversationId: $conversationId");
  if (navigatorKey.currentState == null) {
    getLogger(
      NotificationsReceiver,
    ).e("Navigator state is null. Cannot navigate to ChatScreen.");
    return;
  }

  navigatorKey.currentState?.pushNamed(
    ChatScreen.routeName,
    arguments: {'conversationId': conversationId, 'userId': userId},
  );
}

void handleLikeNotificationAction(String postId) {
  getLogger(
    NotificationsReceiver,
  ).i("Handling Like notification action for postId: $postId");
  navigatorKey.currentState?.pushNamed("/tweet", arguments: {'tweetId': postId});
}

void handleRetweetedNotificationAction(String postId) {
  getLogger(
    NotificationsReceiver,
  ).i("Handling Retweeted notification action for postId: $postId");
  navigatorKey.currentState?.pushNamed("/tweet", arguments: {'tweetId': postId});
}

void handleFollowNotificationAction(String username) {
  getLogger(
    NotificationsReceiver,
  ).i("Handling Follow notification action for username: $username");
  navigatorKey.currentState?.pushNamed(
    "/profile",
    arguments: {'username': username},
  );
}

void handlePostViewNotificationAction(String postId) {
  getLogger(
    NotificationsReceiver,
  ).i("Handling Post View notification action for postId: $postId");
  navigatorKey.currentState?.pushNamed("/tweet", arguments: {'tweetId': postId});

}
