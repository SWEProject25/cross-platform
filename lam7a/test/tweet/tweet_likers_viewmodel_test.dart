import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_likers_viewmodel.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';
import 'package:lam7a/core/models/user_model.dart';

// Mocks
class MockPostInteractionsService extends Mock implements PostInteractionsService {}

void main() {
  late ProviderContainer container;
  late MockPostInteractionsService mockService;

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

  group('TweetLikersViewModel Tests', () {
    test('build calls getLikers and returns users', () async {
      final users = [
        UserModel(id: 1, username: 'user1', email: 'u1@test.com'),
        UserModel(id: 2, username: 'user2', email: 'u2@test.com'),
      ];

      when(() => mockService.getLikers('123')).thenAnswer((_) async => users);

      final result = await container.read(tweetLikersViewModelProvider('123').future);

      expect(result, users);
      verify(() => mockService.getLikers('123')).called(1);
    });

    test('build handles empty list', () async {
      when(() => mockService.getLikers('123')).thenAnswer((_) async => []);

      final result = await container.read(tweetLikersViewModelProvider('123').future);

      expect(result, isEmpty);
      verify(() => mockService.getLikers('123')).called(1);
    });

    test('build handles error', () async {
      when(() => mockService.getLikers('123')).thenThrow(Exception('Network error'));

      expect(
        () => container.read(tweetLikersViewModelProvider('123').future),
        throwsA(isA<Object>()),
      );
    });
  });
}
