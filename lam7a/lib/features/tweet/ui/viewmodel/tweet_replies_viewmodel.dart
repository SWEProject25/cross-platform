import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tweet_replies_viewmodel.g.dart';

/// ViewModel responsible for loading replies for a given tweet
@riverpod
class TweetRepliesViewModel extends _$TweetRepliesViewModel {
  @override
  Future<List<TweetModel>> build(String postId) async {
    final api = ref.read(tweetsApiServiceProvider);
    return api.getRepliesForPost(postId);
  }
}
