import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_likers_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockPostInteractionsService extends Mock implements PostInteractionsService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockPostInteractionsService mockService;
  const postId = 'post-1';

  setUp(() {
    mockService = MockPostInteractionsService();
    container = ProviderContainer(
      overrides: [
        postInteractionsServiceProvider.overrideWithValue(mockService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('TweetLikersViewModel returns likers from service', () async {
    final users = <UserModel>[
      const UserModel(id: 1, username: 'user1'),
      const UserModel(id: 2, username: 'user2'),
    ];

    when(() => mockService.getLikers(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => users);

    final result = await container.read(
      tweetLikersViewModelProvider(postId).future,
    );

    expect(result, users);
  });

  test('TweetLikersViewModel handles empty list', () async {
    when(() => mockService.getLikers(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => <UserModel>[]);

    final result = await container.read(
      tweetLikersViewModelProvider(postId).future,
    );

    expect(result, isEmpty);
  });
}
