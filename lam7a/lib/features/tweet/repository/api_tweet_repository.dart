// lib/features/tweet/repository/api_tweet_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';

class ApiTweetRepository implements TweetRepository {
  final String baseUrl;

  ApiTweetRepository({required this.baseUrl});

  @override
  Future<List<TweetModel>> getAllTweets() async {
    final response = await http.get(Uri.parse('$baseUrl/tweets'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => TweetModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load tweets');
    }
  }

  @override
  Future<TweetModel> getTweetById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/tweets/$id'));

    if (response.statusCode == 200) {
      return TweetModel.fromJson(jsonDecode(response.body));
    }
    // } else if (response.statusCode == 404) {
    //  TweetModel.empty();
    // } 
    else {
      throw Exception('Failed to fetch tweet');
    }
  }

  @override
  Future<void> addTweet(TweetModel tweet) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tweets'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tweet.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create tweet');
    }
  }

  @override
  Future<void> updateTweet(TweetModel tweet) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tweets/${tweet.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tweet.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update tweet');
    }
  }

  @override
  Future<void> deleteTweet(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tweets/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete tweet');
    }
  }
}
