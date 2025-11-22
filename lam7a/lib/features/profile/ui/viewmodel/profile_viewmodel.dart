import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';

part 'profile_viewmodel.g.dart';

@riverpod
Future<ProfileModel> profileViewModel(
  Ref ref,
  String username,
) async {
  final repo = ref.read(profileRepositoryProvider);
  return repo.getProfile(username);
}
