import 'package:flutter/material.dart';
import 'package:lam7a/core/app_icons.dart';
import 'package:lam7a/core/widgets/app_svg_icon.dart';
import 'package:lam7a/core/widgets/time_ago_text.dart';
import 'package:lam7a/features/messaging/utils.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/utils.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  Widget _notificationTypeToIcon(NotificationType type) {
    return switch (type) {
      NotificationType.like => const AppSvgIcon(
        AppIcons.tweet_like_filled,
        color: Colors.red,
      ),
      NotificationType.repost => const AppSvgIcon(
        AppIcons.tweet_retweet,
        color: Colors.green,
      ),
      NotificationType.follow => const AppSvgIcon(
        AppIcons.person_filled,
        color: Colors.blue,
        size: 20,
      ),
      _ => const Icon(Icons.notification_important, color: Colors.orange),
    };
  }

  String _notificationTypeToString(NotificationType type) {
    return switch (type) {
      NotificationType.like => 'liked your post',
      NotificationType.repost => 'reposted your post',
      NotificationType.follow => 'started following you',
      _ => "Unknown notification (${type.toString()})",
    };
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final actor = notification.actor;
    final post = notification.post;

    return isPostViewedNotification(notification.type)
        ? post != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: TweetSummaryWidget(tweetId: post.id, tweetData: post),
                )
              : Center(
                  child: Text(
                    'No post available ${post?.id ?? -1}',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
        : Padding(
            padding: EdgeInsets.only(left: 32, top: 8, bottom: 8, right: 16),
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
                        radius: 14,
                        backgroundImage: actor.profileImageUrl != null
                            ? NetworkImage(actor.profileImageUrl!)
                            : null,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: actor.displayName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  " ${_notificationTypeToString(notification.type)}",
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        notification.postPreviewText ?? '',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                //Time ago
                TimeAgoText(
                  time: notification.createdAt,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert, size: 18),
                //   onPressed: () {},
                // ),
              ],
            ),
          );
  }
}
