import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';
import 'package:lam7a/features/profile_features/profile/model2/profile_model.dart';

class NotificationsAPIServiceMock implements NotificationsAPIService {

  @override
  Future<List<NotificationModel>> getNotifications() async{
    await Future.delayed(Duration(seconds: 5));
    return dummyNotifications;
  }
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