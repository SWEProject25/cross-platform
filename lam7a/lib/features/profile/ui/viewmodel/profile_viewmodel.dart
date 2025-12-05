// lib/features/profile/ui/viewmodel/profile_viewmodel.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/core/models/user_model.dart';

part 'profile_viewmodel.g.dart';

@riverpod
Future<UserModel> profileViewModel(
  Ref ref,
  String username,
) async {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getProfile(username);
}
