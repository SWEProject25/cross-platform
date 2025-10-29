import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/users_repository.dart';
import '../state/blocked_users_state.dart';

class BlockedUsersViewModel extends Notifier<BlockedUsersState> {
  late final UsersRepository _repo;

  @override
  BlockedUsersState build() {
    _repo = ref.read(usersRepositoryProvider);
    _loadUsers();
    return const BlockedUsersState(isLoading: true);
  }

  Future<void> _loadUsers() async {
    final users = await _repo.fetchBlockedUsers();
    state = state.copyWith(isLoading: false, blockedUsers: users);
  }

  Future<void> unblockUser(String userId) async {
    await _repo.unblockUser(userId);
    state = state.copyWith(
      blockedUsers: state.blockedUsers.where((u) => u.id != userId).toList(),
    );
  }
}

final blockedUsersProvider =
    NotifierProvider<BlockedUsersViewModel, BlockedUsersState>(
      BlockedUsersViewModel.new,
    );
