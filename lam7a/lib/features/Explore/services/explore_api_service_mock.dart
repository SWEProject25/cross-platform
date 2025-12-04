import 'package:lam7a/features/profile/model/profile_model.dart';
import 'explore_api_service.dart';
import 'package:lam7a/features/Explore/model/trending_hashtag.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service_mock.dart';

class MockExploreApiService implements ExploreApiService {
  // ----------------------------
  // Mock Hashtags
  // ----------------------------
  final List<TrendingHashtag> _mockHashtags = [
    TrendingHashtag(hashtag: "#Flutter", order: 1, tweetsCount: 12800),
    TrendingHashtag(hashtag: "#DartLang", order: 2, tweetsCount: 9400),
    TrendingHashtag(hashtag: "#Riverpod", order: 3, tweetsCount: 7200),
    TrendingHashtag(hashtag: "#OpenAI", order: 4, tweetsCount: 5100),
    TrendingHashtag(hashtag: "#Programming", order: 5, tweetsCount: 4500),
  ];

  final Map<String, UserModel> _mockUsers = {
    'hossam_dev': UserModel(
      name: 'Hossam Dev',
      username: 'hossam_dev',
      bio: 'Flutter Developer | Building amazing apps 🚀',
      profileImageUrl: 'https://i.pravatar.cc/150?img=1',
      bannerImageUrl: 'https://picsum.photos/400/150',
      location: 'Cairo, Egypt',
      birthDate: '1995-05-15',
      createdAt: 'Joined January 2020',
      followersCount: 1250,
      followingCount: 340,
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    'john_doe': UserModel(
      name: 'John Doe',
      username: 'john_doe',
      bio: 'Tech enthusiast | Coffee lover ☕',
      profileImageUrl: 'https://i.pravatar.cc/150?img=2',
      bannerImageUrl: 'https://picsum.photos/400/151',
      location: 'New York, USA',
      birthDate: '1990-03-20',
      createdAt: 'Joined March 2021',
      followersCount: 450,
      followingCount: 120,
      stateFollow: ProfileStateOfFollow.following,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
    'jane_smith': UserModel(
      name: 'Jane Smith',
      username: 'jane_smith',
      bio: 'UI/UX Designer | Creating beautiful experiences ✨',
      profileImageUrl: 'https://i.pravatar.cc/150?img=3',
      bannerImageUrl: 'https://picsum.photos/400/152',
      location: 'London, UK',
      birthDate: '1992-07-10',
      createdAt: 'Joined June 2019',
      followersCount: 2100,
      followingCount: 890,
      stateFollow: ProfileStateOfFollow.notfollowing,
      stateMute: ProfileStateOfMute.notmuted,
      stateBlocked: ProfileStateBlocked.notblocked,
    ),
  };

  @override
  Future<List<TrendingHashtag>> fetchTrendingHashtags() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockHashtags;
  }

  @override
  Future<List<TrendingHashtag>> fetchInterestHashtags(String interest) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockHashtags;
  }

  @override
  Future<List<UserModel>> fetchSuggestedUsers({int? limit}) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockUsers.values.toList();
  }

  @override
  Future<List<TweetModel>> fetchForYouTweets(int limit, int page) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final start = (page - 1) * limit;
    return mockTweets.values.skip(start).take(limit).toList();
  }

  @override
  Future<List<TweetModel>> fetchInterestBasedTweets(
    int limit,
    int page,
    String interest,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final filtered = mockTweets.values;

    final start = (page - 1) * limit;
    return filtered.skip(start).take(limit).toList();
  }
}
