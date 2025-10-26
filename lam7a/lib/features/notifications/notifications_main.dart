import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/theme.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/ui/views/notifications_screen.dart';
import 'package:lam7a/features/profile_summary/model/profile_model.dart';
import 'package:lam7a/features/tweet/ui/widgets/tweet_summary_widget.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final dummyNotifications = <NotificationModel>[
  NotificationModel(
    notificationId: 'n1',
    type: NotificationType.like,
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
    actor: ProfileModel(
      name: 'Lina Adams',
      username: '@lina_adams',
      bio: 'Flutter enthusiast and mobile dev 💙',
      imageUrl: 'https://randomuser.me/api/portraits/women/45.jpg',
      isVerified: true,
      stateFollow: ProfileStateOfFollow.following,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    post: TweetModel.empty().copyWith(
      id: 't1',
      body: 'Just finished testing my new Flutter layout 🎨',
      likes: 32,
      views: 210,
    ),
  ),
  NotificationModel(
    notificationId: 'n2',
    type: NotificationType.repost,
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    actor: ProfileModel(
      name: 'James Kim',
      username: '@jamesk_dev',
      bio: 'Full-stack developer | Coffee addict ☕',
      imageUrl: 'https://randomuser.me/api/portraits/men/61.jpg',
      isVerified: false,
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    post: TweetModel.empty().copyWith(
      id: 't2',
      body: 'Here’s a simple way to improve app startup time 🚀',
      likes: 54,
      views: 450,
    ),
  ),
  NotificationModel(
    notificationId: 'n3',
    type: NotificationType.follow,
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    actor: ProfileModel(
      name: 'Noah Green',
      username: '@noahgrn',
      bio: 'Open-source contributor 🌍',
      imageUrl: 'https://randomuser.me/api/portraits/men/76.jpg',
      isVerified: false,
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    post: null,
  ),
  NotificationModel(
    notificationId: 'n4',
    type: NotificationType.mention,
    isRead: false,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    actor: ProfileModel(
      name: 'Olivia Parker',
      username: '@oliviaux',
      bio: 'UX designer | Storyteller ✨',
      imageUrl: 'https://randomuser.me/api/portraits/women/32.jpg',
      isVerified: true,
      stateFollow: ProfileStateOfFollow.following,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    post: TweetModel.empty().copyWith(
      id: 't3',
      body: '@you your post about async streams really helped! 💡',
      likes: 12,
      views: 180,
    ),
  ),
  NotificationModel
  (
    notificationId: 'n5',
    type: NotificationType.reply,
    isRead: true,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    actor: ProfileModel(
      name: 'Emma Brown',
      username: '@emma_br',
      bio: 'Product manager | Always learning 📚',
      imageUrl: 'https://randomuser.me/api/portraits/women/50.jpg',
      isVerified: false,
      stateFollow: ProfileStateOfFollow.following,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    post: TweetModel.empty().copyWith(
      id: 't4',
      body: 'That’s a great idea, I might try it in my next project!',
      likes: 9,
      views: 95,
    ),
  ),
];


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'lam7a',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      home: NotificationsScreen(notifications: dummyNotifications),
    );
  }
}