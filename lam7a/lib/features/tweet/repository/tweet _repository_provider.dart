// lib/features/tweet/repository/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/tweet/repository/tweet_repository.dart';
import 'package:lam7a/features/tweet/repository/api_tweet_repository.dart';
import 'package:lam7a/features/tweet/services/mock_tweet_api_service.dart';

final tweetRepositoryProvider = Provider<TweetRepository>((ref) {
  const useMock = true;

  if (useMock) {
    // Trigger build by watching the provider itself
    final mockRepo = ref.watch(mockTweetRepositoryProvider.notifier);
    ref.watch(mockTweetRepositoryProvider); // 👈 ensures build() runs
    return mockRepo;
  } else {
    return ApiTweetRepository(baseUrl: 'https://.com/api');
  }
});

