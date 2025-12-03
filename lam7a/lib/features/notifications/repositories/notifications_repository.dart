import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notifications_repository.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(ref.read(notificationsAPIServiceProvider), ref.read(tweetRepositoryProvider));
}

class NotificationsRepository {

  final NotificationsAPIService _apiService;
  final TweetRepository _tweetRepository;

  NotificationsRepository(this._apiService, this._tweetRepository);


  void setFCMToken(String token) {
    removeFCMToken();

    _apiService.sendFCMToken(token);

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('fcm_token', token);
    });
  }

  void removeFCMToken() {
    SharedPreferences.getInstance().then((prefs) {
      String? token = prefs.getString('fcm_token');
      if(token != null){
        _apiService.removeFCMToken(token);
        prefs.remove('fcm_token');
      }
    });
  }

  Future<List<NotificationModel>> fetchNotifications(int page, [int limit = 20]) async {
    var notificationsDto = await _apiService.getNotifications(page, limit);
    
    // Collect all tweet IDs that need to be fetched
    final postIds = notificationsDto.data?.where((n) => n.postId != null)
        .map((n) => n.postId!)
        .toList() ?? [];
    
    // Fetch all tweets concurrently
    final tweets = <String, TweetModel>{};
    if (postIds.isNotEmpty) {
      final tweetFutures = postIds.map((id) => 
        _tweetRepository.fetchTweetById(id.toString()).then((tweet) => MapEntry(id.toString(), tweet))
      );
      
      final results = await Future.wait(tweetFutures);
      tweets.addEntries(results);
    }
    
    // Map notifications and inject tweet data
    final notifications = notificationsDto.data?.map((dto) {
      return NotificationModel.fromDTO(dto, dto.postId != null ? tweets[dto.postId!.toString()] : null);
    }).toList() ?? [];
    
    return notifications;
  }
}