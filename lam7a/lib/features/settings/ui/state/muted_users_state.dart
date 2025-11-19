import '../../../../core/models/user_model.dart';

class MutedUsersState {
  final List<UserModel> mutedUsers;

  const MutedUsersState({this.mutedUsers = const []});

  MutedUsersState copyWith({List<UserModel>? mutedUsers}) {
    return MutedUsersState(mutedUsers: mutedUsers ?? this.mutedUsers);
  }
}
