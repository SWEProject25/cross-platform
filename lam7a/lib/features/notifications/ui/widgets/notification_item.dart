import 'package:flutter/material.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  Icon _notificationTypeToIcon(NotificationType type) {
    return switch (type) {
      NotificationType.like => const Icon(Icons.favorite, color: Colors.red),
      NotificationType.repost => const Icon(Icons.repeat, color: Colors.green),
      NotificationType.follow => const Icon(
        Icons.person_add,
        color: Colors.blue,
      ),
      NotificationType.mention => const Icon(
        Icons.alternate_email,
        color: Colors.purple,
      ),
      NotificationType.reply => const Icon(
        Icons.chat_bubble_outline,
        color: Colors.orange,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final actor = notification.actor;
    final post = notification.post;

    return Padding(
      padding: EdgeInsets.only(left: 32, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _notificationTypeToIcon(notification.type),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(actor.imageUrl),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Recent post from ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: actor.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  post?.body ?? '',
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 18),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}