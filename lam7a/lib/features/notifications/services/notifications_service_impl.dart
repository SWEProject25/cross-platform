import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/notifications/dtos/notification_dtos.dart';
import 'package:lam7a/features/notifications/services/notifications_service.dart';

class NotificationsAPIServiceImpl implements NotificationsAPIService {

  ApiService _apiService;

  NotificationsAPIServiceImpl(this._apiService);

  @override
  Future<NotificationsResponse> getNotifications([int page = 1, int limit = 20]) async{
    var response = await _apiService.get<NotificationsResponse>(endpoint: "/notifications", queryParameters: {"page": page, "limit": limit}, fromJson: (json) => NotificationsResponse.fromJson(json));
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
    var response = await _apiService.get(endpoint: "/notifications/unread-count");

    return response["unreadCount"];
  }

  void markAllAsRead() async {
    var response = await _apiService.patch(endpoint: "/notifications/read-all");
  }
}