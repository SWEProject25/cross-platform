  import 'package:lam7a/features/notifications/models/notification_model.dart';

bool isPostViewedNotification(NotificationType type) {
    return switch (type) {
      NotificationType.mention => true,
      NotificationType.reply => true,
      NotificationType.quote => true,
      _ => false,
    };
  }