import 'package:lam7a/core/utils/logger.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/notifications/models/notification_model.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'notifications_repository.g.dart';

@riverpod
NotificationsRepository notificationsRepository(Ref ref) {
  return NotificationsRepository(ref.read(notificationsAPIServiceProvider), ref.read(tweetRepositoryProvider));
}

class NotificationsRepository {
  final Logger logger = getLogger(NotificationsRepository);
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

  Future<(List<NotificationModel>, bool)> fetchAllNotifications(int page, [int limit = 20]) async {
    return _fetchNotifications(page: page, limit: limit, excludeTypes: ["DM"]);
  }

  Future<(List<NotificationModel>, bool)> fetchMentionNotifications(int page, [int limit = 20]) async {
    return _fetchNotifications(page: page, limit: limit, includeTypes: ["MENTION", "REPLY"]);
  }

  Future<(List<NotificationModel>, bool)> _fetchNotifications({int page = 1, int limit = 20, List<String>? includeTypes, List<String>? excludeTypes}) async {
    var notificationsDto = await _apiService.getNotifications(includeTypes, excludeTypes, page, limit);
    

    


    final notifications = (notificationsDto["data"] as List<dynamic>?)?.map((dto) {
      return NotificationModel.fromJson(dto);
    }).toList() ?? [];

    logger.i("Fetched ${notifications.length} notifications from API");
    logger.i("Metadata: ${notificationsDto["metadata"]}");
    logger.i("Total Pages: ${(notificationsDto["metadata"]?["totalPages"] ?? 0)} , Current Page: ${(notificationsDto["metadata"]?["page"] ?? 0)}");
    
    return (notifications, (notificationsDto["metadata"]?["totalPages"] ?? 0) != (notificationsDto["metadata"]?["page"] ?? 0));
  }

  Future<int> getUnReadCount(){
    return _apiService.getUnReadCount();
  }

  void markAllAsRead(){
    _apiService.markAllAsRead();
  }
}