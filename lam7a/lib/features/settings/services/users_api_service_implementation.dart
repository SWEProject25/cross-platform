// coverage:ignore-file

import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/constants/server_constant.dart';
import 'users_api_service.dart';

/// Real API implementation using ApiService (Dio)
class UsersApiServiceImpl implements UsersApiService {
  final ApiService _api;

  UsersApiServiceImpl(this._api);

  @override
  Future<List<UserModel>> getMutedUsers() async {
    try {
      final response = await _api.get<List<UserModel>>(
        endpoint: ServerConstant.mutedUsers,
        fromJson: (data) {
          final list = data['data'] as List<dynamic>;
          final modifiedList = list.map((json) {
            if (json.containsKey('displayName')) {
              json['name'] = json['displayName'];
              json.remove('displayName');
            }
            return UserModel.fromJson(json);
          }).toList();

          return modifiedList;
        },
      );
      return response;
    } catch (e) {
      print('Error fetching muted users: $e');
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getBlockedUsers() async {
    try {
      final response = await _api.get<List<UserModel>>(
        endpoint: ServerConstant.blockedUsers,
        fromJson: (data) {
          final list = data['data'] as List<dynamic>;
          final modifiedList = list.map((json) {
            if (json.containsKey('displayName')) {
              json['name'] = json['displayName'];
              json.remove('displayName');
            }
            return UserModel.fromBackend(json);
          }).toList();

          return modifiedList;
        },
      );
      return response;
    } catch (e) {
      print('Error fetching blocked users: $e');
      rethrow;
    }
  }

  @override
  Future<void> unmuteUser(int userId) async {
    try {
      await _api.delete(endpoint: "/users/$userId/mute");
    } catch (e) {
      print('Error unmuting user: $e');
      rethrow;
    }
  }

  @override
  Future<void> unblockUser(int userId) async {
    try {
      await _api.delete(endpoint: "/users/$userId/block");
    } catch (e) {
      print('Error unblocking user: $e');
      rethrow;
    }
  }
}
