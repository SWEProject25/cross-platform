import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';

final tweetRepostersProvider =
    FutureProvider.autoDispose.family<List<UserModel>, String>((ref, postId) async {
  final service = ref.read(postInteractionsServiceProvider);
  return service.getReposters(postId);
});
