import 'package:lam7a/features/common/models/tweet_model.dart';

abstract class TweetRepository {
  Future<TweetModel> getTweetById(String id);
  Future<List<TweetModel>> getAllTweets();
  void updateTweet(TweetModel updated);
  void addTweet(TweetModel tweet);
  void deleteTweet(String id);
}
