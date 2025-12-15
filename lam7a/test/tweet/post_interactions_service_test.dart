import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

import 'package:lam7a/core/api/api_config.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/features/tweet/services/post_interactions_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late PostInteractionsService service;

  setUp(() {
    mockApiService = MockApiService();
    service = PostInteractionsService(mockApiService);
  });

  group('toggleLike', () {
    test('returns backend liked flag when present in data.liked', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/like',
        ),
      ).thenAnswer(
        (_) async => {
          'data': {'liked': true},
        },
      );

      final result = await service.toggleLike('123');

      expect(result, isTrue);
    });

    test('infers like from message text when liked flag is missing', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/like',
        ),
      ).thenAnswer(
        (_) async => {
          'message': 'Post liked successfully',
        },
      );

      final result = await service.toggleLike('123');

      expect(result, isTrue);
    });

    test('infers unlike from message containing unliked', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/like',
        ),
      ).thenAnswer(
        (_) async => {
          'message': 'Post has been unliked',
        },
      );

      final result = await service.toggleLike('123');

      expect(result, isFalse);
    });

    test('propagates errors from ApiService', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/like',
        ),
      ).thenThrow(Exception('network'));

      expect(
        () => service.toggleLike('123'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('getLikesCount', () {
    test('returns length when data is a list', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'limit': 100, 'page': 1},
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {'id': 1},
            {'id': 2},
          ],
        },
      );

      final count = await service.getLikesCount('123');

      expect(count, 2);
    });

    test('returns 0 on 404 DioException', () async {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: 'test'),
        response: Response(
          requestOptions: RequestOptions(path: 'test'),
          statusCode: 404,
        ),
      );

      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(dioError);

      final count = await service.getLikesCount('123');

      expect(count, 0);
    });

    test('returns 0 on any other error', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(Exception('boom'));

      final count = await service.getLikesCount('123');

      expect(count, 0);
    });
  });

  group('getLikers', () {
    test('maps flat list of users', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'page': 1, 'limit': 20},
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {'id': 1, 'username': 'u1', 'email': 'e1'},
          ],
        },
      );

      final users = await service.getLikers('123');

      expect(users, hasLength(1));
      expect(users.first.id, 1);
      expect(users.first.username, 'u1');
    });

    test('maps nested user object from wrapped data list', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'page': 2, 'limit': 5},
        ),
      ).thenAnswer(
        (_) async => {
          'data': {
            'data': [
              {
                'user': {
                  'id': '2',
                  'username': 'u2',
                  'email': 'e2',
                },
              },
            ],
          },
        },
      );

      final users = await service.getLikers(
        '123',
        page: 2,
        limit: 5,
      );

      expect(users, hasLength(1));
      expect(users.first.id, 2);
      expect(users.first.username, 'u2');
    });

    test('returns empty list on 404 DioException', () async {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: 'test'),
        response: Response(
          requestOptions: RequestOptions(path: 'test'),
          statusCode: 404,
        ),
      );

      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'page': 1, 'limit': 20},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(dioError);

      final users = await service.getLikers('123');

      expect(users, isEmpty);
    });

    test('returns empty list on other errors', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'page': 1, 'limit': 20},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(Exception('boom'));

      final users = await service.getLikers('123');

      expect(users, isEmpty);
    });
  });

  group('toggleRepost & getRepostsCount', () {
    test('toggleRepost infers repost from message', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/repost',
        ),
      ).thenAnswer(
        (_) async => {
          'message': 'Repost added',
        },
      );

      final result = await service.toggleRepost('123');

      expect(result, isTrue);
    });

    test('toggleRepost infers un-repost from message', () async {
      when(
        () => mockApiService.post<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/repost',
        ),
      ).thenAnswer(
        (_) async => {
          'message': 'Repost removed',
        },
      );

      final result = await service.toggleRepost('123');

      expect(result, isFalse);
    });

    test('getRepostsCount returns length when data is list', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/reposters',
          queryParameters: {'limit': 100, 'page': 1},
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {'id': 1},
            {'id': 2},
            {'id': 3},
          ],
        },
      );

      final count = await service.getRepostsCount('123');

      expect(count, 3);
    });

    test('getRepostsCount returns 0 on 404 DioException', () async {
      final dioError = DioException(
        type: DioExceptionType.badResponse,
        requestOptions: RequestOptions(path: 'test'),
        response: Response(
          requestOptions: RequestOptions(path: 'test'),
          statusCode: 404,
        ),
      );

      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/reposters',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(dioError);

      final count = await service.getRepostsCount('123');

      expect(count, 0);
    });
  });

  group('user flags and counts', () {
    test('isLikedByCurrentUser returns true when id present in list', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {'id': 1},
            {'id': 42},
          ],
        },
      );

      final result = await service.isLikedByCurrentUser('123', 42);

      expect(result, isTrue);
    });

    test('isRepostedByCurrentUser returns true when id present in list',
        () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/reposters',
          queryParameters: {'limit': 100, 'page': 1},
        ),
      ).thenAnswer(
        (_) async => {
          'data': [
            {'id': 7},
            {'id': 42},
          ],
        },
      );

      final result = await service.isRepostedByCurrentUser('123', 42);

      expect(result, isTrue);
    });

    test('isLikedByCurrentUser returns false on error', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/likers',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(Exception('boom'));

      final result = await service.isLikedByCurrentUser('123', 1);

      expect(result, isFalse);
    });

    test('isRepostedByCurrentUser returns false on error', () async {
      when(
        () => mockApiService.get<Map<String, dynamic>>(
          endpoint: '${ApiConfig.postsEndpoint}/123/reposters',
          queryParameters: {'limit': 100, 'page': 1},
          options: null,
          fromJson: null,
        ),
      ).thenThrow(Exception('boom'));

      final result = await service.isRepostedByCurrentUser('123', 1);

      expect(result, isFalse);
    });

    test('getPostCounts combines likes and reposts', () async {
      final testService = _TestablePostInteractionsService(mockApiService)
        ..likes = 5
        ..reposts = 3;

      final counts = await testService.getPostCounts('123');

      expect(counts['likes'], 5);
      expect(counts['reposts'], 3);
    });
  });
}

class _TestablePostInteractionsService extends PostInteractionsService {
  _TestablePostInteractionsService(ApiService api) : super(api);

  int likes = 0;
  int reposts = 0;

  @override
  Future<int> getLikesCount(String postId) async => likes;

  @override
  Future<int> getRepostsCount(String postId) async => reposts;
}
