import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_reposters_viewmodel.dart';
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

  test('TweetRepostersViewModel returns reposters from service', () async {
    final users = <UserModel>[
      const UserModel(id: 1, username: 'user1'),
      const UserModel(id: 2, username: 'user2'),
    ];

    when(() => mockService.getReposters(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => users);

    final result = await container.read(
      tweetRepostersViewModelProvider(postId).future,
    );

    expect(result, users);

    verify(() => mockService.getReposters(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).called(1);
  });

  test('TweetRepostersViewModel handles empty list', () async {
    when(() => mockService.getReposters(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => <UserModel>[]);

    final result = await container.read(
      tweetRepostersViewModelProvider(postId).future,
    );

    expect(result, isEmpty);

    verify(() => mockService.getReposters(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).called(1);
  });

  test('TweetRepostersViewModel surfaces errors from service', () async {
    when(() => mockService.getReposters(
          postId,
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        )).thenThrow(Exception('network error'));

    await expectLater(
      container.read(
        tweetRepostersViewModelProvider(postId).future,
      ),
      // Riverpod surfaces an error when the provider fails while loading
      throwsA(isA<StateError>()),
    );
  });
}
