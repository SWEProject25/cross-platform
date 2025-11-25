import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';//model instead of model2 

enum NotificationType { like, repost, follow, mention, reply }

class NotificationModel {
  final String notificationId;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final ProfileModel actor;
  final TweetModel? post;

  const NotificationModel({
    required this.notificationId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actor,
    this.post,
  });
}
