import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';

final tweetRepliesProvider =
    FutureProvider.autoDispose.family<List<TweetModel>, String>((ref, postId) async {
  final api = ref.read(tweetsApiServiceProvider);
  return api.getRepliesForPost(postId);
});
