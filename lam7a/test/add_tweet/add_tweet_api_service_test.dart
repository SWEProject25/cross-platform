import 'dart:io';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/core/services/api_service.dart';
import 'package:lam7a/core/api/api_config.dart';

// Mocks
class MockApiService extends Mock implements ApiService {}

void main() {
  late AddTweetApiServiceImpl service;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    service = AddTweetApiServiceImpl(apiService: mockApiService);
    
    // Register fallback values
    registerFallbackValue(Options());
    registerFallbackValue(FormData());
  });

  group('AddTweetApiServiceImpl Tests', () {
    test('createTweet sends correct basic data', () async {
      final responseData = {
        'status': 'success',
        'data': {
          'id': '123',
          'user_id': '1',
          'content': 'Test content',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0, 'repost': 0, 'comments': 0, 'views': 0, 'qoutes': 0, 'bookmarks': 0,
          'media': []
        }
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => responseData);

      final result = await service.createTweet(
        userId: 1,
        content: 'Test content',
        type: 'POST',
      );

      verify(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).called(1);
    });

    test('createTweet prefers transformed post shape when postId is present',
        () async {
      final now = DateTime.now().toIso8601String();
      final responseData = {
        'status': 'success',
        'data': {
          'postId': '42',
          'userId': '1',
          'text': 'Transformed content',
          'date': now,
          'likesCount': 3,
          'commentsCount': 1,
          'retweetsCount': 2,
          'media': [
            {
              'url': 'http://img.com/transformed.jpg',
              'type': 'IMAGE',
            },
            {
              'url': 'http://vid.com/transformed.mp4',
              'type': 'VIDEO',
            },
          ],
        },
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
            endpoint: any(named: 'endpoint'),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => responseData);

      final result = await service.createTweet(
        userId: 1,
        content: 'Transformed content',
      );

      expect(result.id, '42');
      expect(result.body, 'Transformed content');
      expect(result.mediaImages, contains('http://img.com/transformed.jpg'));
      expect(result.mediaVideos, contains('http://vid.com/transformed.mp4'));
    });

    test('createTweet parses media in response correctly', () async {
      final responseData = {
        'status': 'success',
        'data': {
          'id': '126', 'user_id': '1', 'content': 'Media Tweet',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0, 'repost': 0, 'comments': 0, 'views': 0, 'qoutes': 0, 'bookmarks': 0,
          'media': [
            {'media_url': 'http://img.com/1.jpg', 'type': 'IMAGE'},
            {'media_url': 'http://vid.com/1.mp4', 'type': 'VIDEO'},
          ]
        }
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => responseData);

      final result = await service.createTweet(userId: 1, content: 'Media Tweet');

      expect(result.mediaImages, contains('http://img.com/1.jpg'));
      expect(result.mediaVideos, contains('http://vid.com/1.mp4'));
    });

    test('createTweet parses legacy mediaUrls in response correctly', () async {
       final responseData = {
        'status': 'success',
        'data': {
          'id': '126', 'user_id': '1', 'content': 'Media Tweet',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0, 'repost': 0, 'comments': 0, 'views': 0, 'qoutes': 0, 'bookmarks': 0,
          'mediaUrls': [
            'http://img.com/pic.jpg',
            'http://vid.com/movie.mp4'
          ]
        }
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => responseData);

       final result = await service.createTweet(userId: 1, content: 'Media Tweet');

      expect(result.mediaImages, contains('http://img.com/pic.jpg'));
      expect(result.mediaVideos, contains('http://vid.com/movie.mp4'));
    });

    test('createTweet throws StateError when response data is not a map',
        () async {
      final responseData = {
        'status': 'success',
        'data': 'unexpected-string-response',
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
            endpoint: any(named: 'endpoint'),
            data: any(named: 'data'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => responseData);

      expect(
        () => service.createTweet(userId: 1, content: 'Bad response'),
        throwsA(isA<StateError>()),
      );
    });

    // SKIP: Real file IO causing crashes in test runner environment
    /*
    test('createTweet includes VIDEO file in FormData', () async {
      // Create temp file
      final tempDir = Directory.systemTemp.createTempSync('test_video');
      final file = File('${tempDir.path}/test_video.mp4');
      await file.writeAsBytes([0, 1, 2, 3]);

      final responseData = {
        'status': 'success', 'data': {
          'id': '128', 'user_id': '1', 'content': 'Vid',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0, 'repost': 0, 'comments': 0, 'views': 0, 'qoutes': 0, 'bookmarks': 0,
          'media': []
        }
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => responseData);

      await service.createTweet(
        userId: 1,
        content: 'Vid',
        mediaVideoPath: file.path,
      );

      verify(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        data: any(named: 'data', that: isA<FormData>().having(
          (d) => d.files.any((f) => f.key == 'media' && f.value.filename == 'test_video.mp4'),
          'has video file',
          true
        )),
        options: any(named: 'options'),
      )).called(1);

      // Cleanup
      if (await tempDir.exists()) await tempDir.delete(recursive: true);
    });
    */
    
    test('createTweet ignores non-existent files', () async {
       final responseData = {
        'status': 'success', 'data': {
          'id': '129', 'user_id': '1', 'content': 'Missing',
          'created_at': DateTime.now().toIso8601String(),
          'likes': 0, 'repost': 0, 'comments': 0, 'views': 0, 'qoutes': 0, 'bookmarks': 0,
          'media': []
        }
      };

      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => responseData);

      await service.createTweet(
        userId: 1,
        content: 'Missing',
        mediaPicPaths: ['/path/to/missing/file.jpg'],
        mediaVideoPath: '/path/to/missing/video.mp4',
      );

      // Verify NO media files were added
       verify(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: ApiConfig.postsEndpoint,
        data: any(named: 'data', that: isA<FormData>().having(
          (d) => d.files.isEmpty,
          'has NO media files',
          true
        )),
        options: any(named: 'options'),
      )).called(1);
    });

    test('createTweet handles DioException correctly', () async {
      when(() => mockApiService.post<Map<String, dynamic>>(
        endpoint: any(named: 'endpoint'),
        data: any(named: 'data'),
        options: any(named: 'options'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(requestOptions: RequestOptions(path: ''), statusCode: 500, statusMessage: 'Server Error'),
      ));

      expect(
        () => service.createTweet(userId: 1, content: 'Error'),
        throwsA(isA<DioException>()),
      );
    });
  });
}
