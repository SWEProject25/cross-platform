import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';
import 'package:lam7a/features/notifications/models/actor_model.dart';

enum NotificationType {like, repost, quote, follow, mention, reply, dm, unknown}

class NotificationModel {
  final String notificationId;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final TweetModel? post;
  final String? postPreviewText;

  final ActorModel actor;

  const NotificationModel({
    required this.notificationId,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.actor,
    this.post,
    this.postPreviewText,
  });

  factory NotificationModel.fromDTO(NotificationDto dto, TweetModel? post) {
    NotificationType mapType(NotificationTypeDTO? type) {
      return switch (type) {
        NotificationTypeDTO.like =>
          NotificationType.like,
        NotificationTypeDTO.repost =>
          NotificationType.repost,
        NotificationTypeDTO.follow =>
          NotificationType.follow,
        NotificationTypeDTO.mention =>
          NotificationType.mention,
        NotificationTypeDTO.reply =>
          NotificationType.reply,
        NotificationTypeDTO.quote =>
          NotificationType.quote,
        NotificationTypeDTO.directMessage =>
          NotificationType.dm,

        _ =>
          NotificationType.unknown,
      };
    }

    return NotificationModel(
      notificationId: dto.id ?? '',
      type: mapType(dto.type),
      isRead: dto.isRead ?? false,
      createdAt: dto.createdAt ?? DateTime.now(),
      actor: ActorModel.fromDTO(dto.actor!),
      post: post,
      postPreviewText: dto.postPreviewText,
    );
  }
}
