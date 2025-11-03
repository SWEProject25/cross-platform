import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repository/users_repository.dart';
import '../state/muted_users_state.dart';

class MutedUsersViewModel extends AsyncNotifier<MutedUsersState> {
  late final UserRelationsRepository _repo;

  @override
  Future<MutedUsersState> build() async {
    _repo = ref.read(usersRepositoryProvider);
    final users = await _repo.fetchMutedUsers();
    return MutedUsersState(mutedUsers: users);
  }

  Future<void> unmuteUser(int userId) async {
    try {
      final currentState = state.value;
      if (currentState == null) return;

      await _repo.unmuteUser(userId);

      final updatedList = currentState.mutedUsers
          .where((u) => u.id != userId)
          .toList();
      state = AsyncData(currentState.copyWith(mutedUsers: updatedList));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final mutedUsersProvider =
    AsyncNotifierProvider<MutedUsersViewModel, MutedUsersState>(
      MutedUsersViewModel.new,
    );
