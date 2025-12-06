// import 'package:lam7a/features/common/models/tweet_model.dart';
// import 'package:lam7a/features/notifications/models/notification_model.dart';
// import 'package:lam7a/features/notifications/services/notifications_service.dart';
// import 'package:lam7a/features/profile/model/profile_model.dart';

// class NotificationsAPIServiceMock implements NotificationsAPIService {

//   @override
//   Future<List<NotificationModel>> getNotifications() async{
//     await Future.delayed(Duration(seconds: 5));
//     return dummyNotifications;
//   }
// }


import 'dart:async';
import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';

class MockNotificationsAPIService extends NotificationsAPIService {
  @override
  Future<NotificationsResponse> getNotifications([int page = 1, int limit = 20]) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate mock notifications
    final data = List.generate(limit, (index) {
      final num = (page - 1) * limit + index + 1;

      return NotificationDto(
        id: num.toString(),
        type: NotificationTypeDTO.values[num % (NotificationTypeDTO.values.length-1)],
        recipientId: 123,
        actor: ActorDto(
          id: 999,
          username: "mock_user_$num",
          displayName: "Mock User $num",
          avatarUrl: "https://avatar.iran.liara.run/public",
        ),
        isRead: num % 2 == 0,
        createdAt: DateTime.now().subtract(Duration(minutes: num)),
        postId: num,
        replyId: num % 3 == 0 ? num + 1000 : null,
        threadPostId: num % 4 == 0 ? num + 2000 : null,
        postPreviewText: "This is a mock preview text for notification $num.",
      );
    });

    final metadata = MetadataDto(
      totalItems: 200,
      page: page,
      limit: limit,
      totalPages: (200 / limit).ceil(),
      unreadCount: 42,
    );

    return NotificationsResponse(
      data: data,
      metadata: metadata,
    );
  }
  
  @override
  void removeFCMToken(String token) {
    // TODO: implement removeFCMToken
  }
  
  @override
  void sendFCMToken(String token) {
    // TODO: implement sendFCMToken
  }
  
  @override
  Future<int> getUnReadCount() {
    // TODO: implement getUnReadCount
    throw UnimplementedError();
  }
  
  @override
  void markAllAsRead() {
    // TODO: implement markAllAsRead
  }
}


// final dummyNotifications = <NotificationModel>[
//   NotificationModel(
//     notificationId: 'n1',
//     type: NotificationType.like,
//     isRead: false,
//     createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
//     actor: ProfileModel(
//       id: 1,
//       userId: 101,
//       displayName: 'Lina Adams',
//       handle: 'lina_adams',
//       bio: 'Flutter enthusiast and mobile dev 💙',
//       avatarImage: 'https://randomuser.me/api/portraits/women/45.jpg',
//       bannerImage: 'https://picsum.photos/400/153',
//       isVerified: true,
//       location: 'San Francisco, USA',
//       birthday: '1993-11-25',
//       joinedDate: 'Joined February 2018',
//       followersCount: 980,
//       followingCount: 300,
//       stateFollow: ProfileStateOfFollow.following,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     post: TweetModel.empty().copyWith(
//       id: 't1',
//       body: 'Just finished testing my new Flutter layout 🎨',
//       likes: 32,
//       views: 210,
//     ),
//   ),
//   NotificationModel(
//     notificationId: 'n2',
//     type: NotificationType.repost,
//     isRead: false,
//     createdAt: DateTime.now().subtract(const Duration(hours: 1)),
//     actor: ProfileModel(
//       id: 2,
//       userId: 102,
//       displayName: 'James Kim',
//       handle: '@jamesk_dev',
//       bio: 'Full-stack developer | Coffee addict ☕',
//       avatarImage: 'https://randomuser.me/api/portraits/men/61.jpg',
//       bannerImage: 'https://picsum.photos/400/154',
//       isVerified: false,
//       location: 'Seoul, South Korea',
//       birthday: '1988-09-12',
//       joinedDate: 'Joined May 2017',
//       followersCount: 760,
//       followingCount: 410,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     post: TweetModel.empty().copyWith(
//       id: 't2',
//       body: 'Here’s a simple way to improve app startup time 🚀',
//       likes: 54,
//       views: 450,
//     ),
//   ),
//   NotificationModel(
//     notificationId: 'n3',
//     type: NotificationType.follow,
//     isRead: true,
//     createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//     actor: ProfileModel(
//       id: 3,
//       userId: 103,
//       displayName: 'Noah Green',
//       handle: '@noahgrn',
//       bio: 'Open-source contributor 🌍',
//       avatarImage: 'https://randomuser.me/api/portraits/men/76.jpg',
//       bannerImage: 'https://picsum.photos/400/155',
//       isVerified: false,
//       location: 'Berlin, Germany',
//       birthday: '1994-02-28',
//       joinedDate: 'Joined August 2020',
//       followersCount: 320,
//       followingCount: 150,
//       stateFollow: ProfileStateOfFollow.notfollowing,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     post: null,
//   ),
//   NotificationModel(
//     notificationId: 'n4',
//     type: NotificationType.mention,
//     isRead: false,
//     createdAt: DateTime.now().subtract(const Duration(days: 1)),
//     actor: ProfileModel(
//       id: 4,
//       userId: 104,
//       displayName: 'Olivia Parker',
//       handle: '@oliviaux',
//       bio: 'UX designer | Storyteller ✨',
//       avatarImage: 'https://randomuser.me/api/portraits/women/32.jpg',
//       bannerImage: 'https://picsum.photos/400/156',
//       isVerified: true,
//       location: 'Toronto, Canada',
//       birthday: '1991-12-05',
//       joinedDate: 'Joined November 2016',
//       followersCount: 1450,
//       followingCount: 600,
//       stateFollow: ProfileStateOfFollow.following,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     post: TweetModel.empty().copyWith(
//       id: 't3',
//       body: '@you your post about async streams really helped! 💡',
//       likes: 12,
//       views: 180,
//     ),
//   ),
//   NotificationModel
//   (
//     notificationId: 'n5',
//     type: NotificationType.reply,
//     isRead: true,
//     createdAt: DateTime.now().subtract(const Duration(days: 2)),
//     actor: ProfileModel(
//       id: 5,
//       userId: 105,
//       displayName: 'Emma Wilson',
//       handle: '@emmawilson',
//       bio: 'Tech blogger | Gadget lover 📱',
//       avatarImage: 'https://randomuser.me/api/portraits/women/68.jpg',
//       bannerImage: 'https://picsum.photos/400/157',
//       isVerified: false,
//       location: 'London, UK',
//       birthday: '1990-07-19',
//       joinedDate: 'Joined March 2019',
//       followersCount: 890,
//       followingCount: 420,
//       stateFollow: ProfileStateOfFollow.following,
//       stateMute: ProfileStateOfMute.notmuted,
//       stateBlocked: ProfileStateBlocked.notblocked,
//     ),
//     post: TweetModel.empty().copyWith(
//       id: 't4',
//       body: 'That’s a great idea, I might try it in my next project!',
//       likes: 9,
//       views: 95,
//     ),
//   ),
// ];