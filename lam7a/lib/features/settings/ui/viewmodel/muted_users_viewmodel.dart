import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/users_repository.dart';
import '../state/muted_users_state.dart';

class MutedUsersViewModel extends Notifier<MutedUsersState> {
  late final UsersRepository _repo;

  @override
  MutedUsersState build() {
    _repo = ref.read(usersRepositoryProvider);
    _loadUsers();
    return const MutedUsersState(isLoading: true);
  }

  Future<void> _loadUsers() async {
    final users = await _repo.fetchMutedUsers();
    state = state.copyWith(isLoading: false, mutedUsers: users);
  }

  Future<void> unmuteUser(String userId) async {
    await _repo.unmuteUser(userId);
    state = state.copyWith(
      mutedUsers: state.mutedUsers.where((u) => u.id != userId).toList(),
    );
  }
}

final mutedUsersProvider =
    NotifierProvider<MutedUsersViewModel, MutedUsersState>(
      MutedUsersViewModel.new,
    );
