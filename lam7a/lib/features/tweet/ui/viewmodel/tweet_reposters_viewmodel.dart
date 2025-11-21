import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_reposters_viewmodel.g.dart';

/// ViewModel responsible for loading the list of users who reposted a tweet
@riverpod
class TweetRepostersViewModel extends _$TweetRepostersViewModel {
  @override
  Future<List<UserModel>> build(String postId) async {
    final service = ref.read(postInteractionsServiceProvider);
    return service.getReposters(postId);
  }
}
