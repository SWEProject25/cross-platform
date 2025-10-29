import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/users_model.dart';
import 'users_api_service_mock.dart';

part 'users_api_service.g.dart';

@riverpod
UsersApiService usersApiService(Ref ref) {
  return UsersApiServiceMock(); // Replace later with real backend API
}

abstract class UsersApiService {
  Future<List<User>> getMutedUsers();
  Future<List<User>> getBlockedUsers();
  Future<void> unmuteUser(String userId);
  Future<void> unblockUser(String userId);
}
