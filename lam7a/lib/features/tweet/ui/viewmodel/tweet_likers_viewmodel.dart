import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_likers_viewmodel.g.dart';

/// ViewModel responsible for loading the list of users who liked a tweet
@riverpod
class TweetLikersViewModel extends _$TweetLikersViewModel {
  @override
  Future<List<UserModel>> build(String postId) async {
    final service = ref.read(postInteractionsServiceProvider);
    return service.getLikers(postId);
  }
}
