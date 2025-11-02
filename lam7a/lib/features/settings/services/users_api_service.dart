import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import 'users_api_service_mock.dart';

part 'users_api_service.g.dart';

@riverpod
UsersApiService usersApiService(Ref ref) {
  return UsersApiServiceMock(); // Replace later with real backend API
}

abstract class UsersApiService {
  Future<List<UserModel>> getMutedUsers();
  Future<List<UserModel>> getBlockedUsers();
  Future<void> unmuteUser(String userId);
  Future<void> unblockUser(String userId);
}
