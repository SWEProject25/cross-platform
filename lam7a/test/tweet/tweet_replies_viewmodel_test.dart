import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/services/tweet_api_service.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_replies_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockTweetsApiService extends Mock implements TweetsApiService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockTweetsApiService mockApiService;
  const postId = 'post-1';

  setUp(() {
    mockApiService = MockTweetsApiService();
    container = ProviderContainer(
      overrides: [
        tweetsApiServiceProvider.overrideWith((ref) => mockApiService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  TweetModel _buildTweet(String id) {
    return TweetModel(
      id: id,
      body: 'Reply $id',
      mediaPic: null,
      mediaVideo: null,
      date: DateTime(2025, 1, 1),
      likes: 0,
      qoutes: 0,
      bookmarks: 0,
      repost: 0,
      comments: 0,
      views: 0,
      userId: 'u1',
    );
  }

  test('TweetRepliesViewModel returns replies from service', () async {
    final replies = <TweetModel>[
      _buildTweet('r1'),
      _buildTweet('r2'),
    ];

    when(() => mockApiService.getRepliesForPost(postId))
        .thenAnswer((_) async => replies);

    final result = await container.read(
      tweetRepliesViewModelProvider(postId).future,
    );

    expect(result, replies);
  });

  test('TweetRepliesViewModel handles empty list', () async {
    when(() => mockApiService.getRepliesForPost(postId))
        .thenAnswer((_) async => <TweetModel>[]);

    final result = await container.read(
      tweetRepliesViewModelProvider(postId).future,
    );

    expect(result, isEmpty);
  });
}
