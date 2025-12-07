import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';

class NotificationsAPIServiceImpl implements NotificationsAPIService {

  ApiService _apiService;

  NotificationsAPIServiceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> getNotifications([List<String>? includeTypes, List<String>? excludeTypes, int page = 1, int limit = 20]) async{
    String? exclude = excludeTypes != null && excludeTypes.isNotEmpty ? excludeTypes.join(",") : null;
    String? include = includeTypes != null && includeTypes.isNotEmpty ? includeTypes.join(",") : null;
    print("Fetching notifications with include: $include , exclude: $exclude");
    var response = await _apiService.get<Map<String, dynamic>>(endpoint: "/notifications", queryParameters: {"page": page, "limit": limit, "include": include, "exclude": exclude}, fromJson: (json) => json);
    return response;
  }

  @override
  void sendFCMToken(String token) {
    _apiService.post(endpoint: "/notifications/device", data: {"token": token, "platform": "ANDROID"});
  }

  @override
  void removeFCMToken(String token) {
    _apiService.delete(endpoint: "/notifications/device", data: {"token": token});
  }

  @override
  Future<int> getUnReadCount() async{
    var response = await _apiService.get(endpoint: "/notifications/unread-count", queryParameters: {"exclude" : "DM"});

    return response["unreadCount"];
  }

  @override
  void markAllAsRead() async {
    var response = await _apiService.patch(endpoint: "/notifications/read-all");
  }
}