// coverage:ignore-file
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user_model.dart';
import 'users_api_service_mock.dart';
import 'users_api_service_implementation.dart';
import '../../../core/services/api_service.dart';

part 'users_api_service.g.dart';

@riverpod
UsersApiService usersApiService(Ref ref) {
  return UsersApiServiceMock(); // Replace later with real backend API
}

@riverpod
UsersApiService usersApiServiceImpl(Ref ref) {
  return UsersApiServiceImpl(ref.read(apiServiceProvider));
}

abstract class UsersApiService {
  Future<List<UserModel>> getMutedUsers();
  Future<List<UserModel>> getBlockedUsers();
  Future<void> unmuteUser(int userId);
  Future<void> unblockUser(int userId);
}
