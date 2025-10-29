import '../../models/users_model.dart';

class MutedUsersState {
  final List<User> mutedUsers;
  final bool isLoading;

  const MutedUsersState({this.mutedUsers = const [], this.isLoading = false});

  MutedUsersState copyWith({List<User>? mutedUsers, bool? isLoading}) {
    return MutedUsersState(
      mutedUsers: mutedUsers ?? this.mutedUsers,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
