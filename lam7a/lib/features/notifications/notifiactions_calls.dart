import 'package:flutter/material.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/notifications/ui/widgets/notification_overlay.dart';
import 'package:lam7a/main.dart';
import 'package:overlay_support/overlay_support.dart';

void showDMNotification({
    required String sender,
    required String message,
    required String avatarUrl,
    required VoidCallback onTap,
  }) {
    late OverlaySupportEntry entry;

    entry = showOverlayNotification(
      (context) => SafeArea(
        child: SlideDismissible(
          key: UniqueKey(), // required for SlideDismissible
          direction: DismissDirection.up,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TwitterDMNotification.DMNotificationOverlay(
              sender: sender,
              message: message,
              avatarUrl: avatarUrl,
              onTap: () {
                print("Notification tapped");

                onTap();

                entry.dismiss();
              },
            ),
          ),
        ),
      ),
      duration: Duration(seconds: 3), // auto-dismiss after this duration
    );
  }