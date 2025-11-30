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
}