import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/users_model.dart';
import '../services/users_api_service.dart';

part 'users_repository.g.dart';

@riverpod
UsersRepository usersRepository(Ref ref) {
  return UsersRepository(ref.read(usersApiServiceProvider));
}

class UsersRepository {
  final UsersApiService _api;

  UsersRepository(this._api);

  Future<List<User>> fetchMutedUsers() => _api.getMutedUsers();
  Future<List<User>> fetchBlockedUsers() => _api.getBlockedUsers();

  Future<void> unmuteUser(String userId) => _api.unmuteUser(userId);
  Future<void> unblockUser(String userId) => _api.unblockUser(userId);
}
