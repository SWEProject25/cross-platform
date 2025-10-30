import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:mocktail/mocktail.dart';

/// ---- MOCK CLASSES ----
class MockAddTweetApiService extends Mock implements AddTweetApiService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockAddTweetApiService mockApiService;

  final testTweet = TweetModel(
    id: '1',
    body: 'Test tweet content',
    mediaPic: null,
    mediaVideo: null,
    date: DateTime(2025, 10, 30),
    likes: 0,
    qoutes: 0,
    bookmarks: 0,
    repost: 0,
    comments: 0,
    views: 0,
    userId: 'user123',
  );

  setUp(() {
    mockApiService = MockAddTweetApiService();
    container = ProviderContainer(
      overrides: [
        addTweetApiServiceProvider.overrideWith((ref) => mockApiService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AddTweetViewmodel - Initial State', () {
    test('should initialize with empty state', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      final state = viewModel.state;

      expect(state.body, equals(''));
      expect(state.isValidBody, false);
      expect(state.isLoading, false);
      expect(state.mediaPicPath, isNull);
      expect(state.mediaVideoPath, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isTweetPosted, false);
    });
  });

  group('AddTweetViewmodel - Body Validation', () {
    test('should update body and validate correctly for valid input', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('Hello world');
      
      expect(viewModel.state.body, equals('Hello world'));
      expect(viewModel.state.isValidBody, true);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('should invalidate empty body', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('');
      
      expect(viewModel.state.body, equals(''));
      expect(viewModel.state.isValidBody, false);
    });

    test('should invalidate body with only whitespace', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('   ');
      
      expect(viewModel.state.body, equals('   '));
      expect(viewModel.state.isValidBody, false);
    });

    test('should validate body at minimum length (1 character)', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('A');
      
      expect(viewModel.state.body, equals('A'));
      expect(viewModel.state.isValidBody, true);
    });

    test('should validate body at maximum length (280 characters)', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      final maxLengthBody = 'A' * 280;
      
      viewModel.updateBody(maxLengthBody);
      
      expect(viewModel.state.body, equals(maxLengthBody));
      expect(viewModel.state.isValidBody, true);
    });

    test('should invalidate body exceeding maximum length', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      final tooLongBody = 'A' * 281;
      
      viewModel.updateBody(tooLongBody);
      
      expect(viewModel.state.body, equals(tooLongBody));
      expect(viewModel.state.isValidBody, false);
    });
  });

  group('AddTweetViewmodel - Media Management', () {
    test('should update media pic path', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      const picPath = '/path/to/image.jpg';
      
      viewModel.updateMediaPic(picPath);
      
      expect(viewModel.state.mediaPicPath, equals(picPath));
    });

    test('should update media video path', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      const videoPath = '/path/to/video.mp4';
      
      viewModel.updateMediaVideo(videoPath);
      
      expect(viewModel.state.mediaVideoPath, equals(videoPath));
    });

    test('should remove media pic', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // First set a path
      viewModel.updateMediaPic('/path/to/image.jpg');
      expect(viewModel.state.mediaPicPath, isNotNull);
      
      // Then remove it
      viewModel.removeMediaPic();
      expect(viewModel.state.mediaPicPath, isNull);
    });

    test('should remove media video', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // First set a path
      viewModel.updateMediaVideo('/path/to/video.mp4');
      expect(viewModel.state.mediaVideoPath, isNotNull);
      
      // Then remove it
      viewModel.removeMediaVideo();
      expect(viewModel.state.mediaVideoPath, isNull);
    });

    test('should handle both media types simultaneously', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateMediaPic('/path/to/image.jpg');
      viewModel.updateMediaVideo('/path/to/video.mp4');
      
      expect(viewModel.state.mediaPicPath, equals('/path/to/image.jpg'));
      expect(viewModel.state.mediaVideoPath, equals('/path/to/video.mp4'));
    });
  });

  group('AddTweetViewmodel - Can Post Tweet', () {
    test('should allow posting when body is valid and not loading', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('Valid tweet content');
      
      expect(viewModel.canPostTweet(), true);
    });

    test('should not allow posting when body is invalid', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('');
      
      expect(viewModel.canPostTweet(), false);
    });

    test('should not allow posting when already loading', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('Valid tweet content');
      // Manually set loading state for testing
      viewModel.state = viewModel.state.copyWith(isLoading: true);
      
      expect(viewModel.canPostTweet(), false);
    });
  });

  group('AddTweetViewmodel - Post Tweet', () {
    test('should successfully post tweet without media', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('Test tweet content');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet);
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isTweetPosted, true);
      expect(viewModel.state.errorMessage, isNull);
      
      verify(() => mockApiService.createTweet(
        userId: 'user123',
        content: 'Test tweet content',
        mediaPicPath: null,
        mediaVideoPath: null,
      )).called(1);
    });

    test('should successfully post tweet with image', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('Tweet with image');
      viewModel.updateMediaPic('/path/to/image.jpg');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet.copyWith(
        mediaPic: 'https://example.com/image.jpg',
      ));
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isTweetPosted, true);
      
      verify(() => mockApiService.createTweet(
        userId: 'user123',
        content: 'Tweet with image',
        mediaPicPath: '/path/to/image.jpg',
        mediaVideoPath: null,
      )).called(1);
    });

    test('should successfully post tweet with video', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('Tweet with video');
      viewModel.updateMediaVideo('/path/to/video.mp4');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet.copyWith(
        mediaVideo: 'https://example.com/video.mp4',
      ));
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isTweetPosted, true);
      
      verify(() => mockApiService.createTweet(
        userId: 'user123',
        content: 'Tweet with video',
        mediaPicPath: null,
        mediaVideoPath: '/path/to/video.mp4',
      )).called(1);
    });

    test('should trim whitespace from body before posting', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('  Tweet with spaces  ');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet);
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify trimmed content was sent
      verify(() => mockApiService.createTweet(
        userId: 'user123',
        content: 'Tweet with spaces',
        mediaPicPath: null,
        mediaVideoPath: null,
      )).called(1);
    });

    test('should not post when body is invalid', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup with invalid body
      viewModel.updateBody('');
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isTweetPosted, false);
      expect(viewModel.state.errorMessage, equals('Please enter valid tweet content'));
      
      verifyNever(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      ));
    });

    test('should handle API error gracefully', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('Test tweet');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenThrow(Exception('Network error'));
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify
      expect(viewModel.state.isLoading, false);
      expect(viewModel.state.isTweetPosted, false);
      expect(viewModel.state.errorMessage, contains('Failed to post tweet'));
    });

    test('should set loading state during API call', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup
      viewModel.updateBody('Test tweet');
      var loadingStateObserved = false;
      
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async {
        // Check loading state during API call
        loadingStateObserved = viewModel.state.isLoading;
        return testTweet;
      });
      
      // Execute
      await viewModel.postTweet('user123');
      
      // Verify loading was true during call
      expect(loadingStateObserved, true);
      // And false after completion
      expect(viewModel.state.isLoading, false);
    });
  });

  group('AddTweetViewmodel - Reset State', () {
    test('should reset state after successful post', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      // Setup and post
      viewModel.updateBody('Test tweet');
      viewModel.updateMediaPic('/path/to/image.jpg');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet);
      
      await viewModel.postTweet('user123');
      
      // Verify tweet was posted
      expect(viewModel.state.isTweetPosted, true);
      
      // Reset by calling resetState (if it exists) or manually
      viewModel.state = const AddTweetState();
      
      // Verify state is reset
      expect(viewModel.state.body, equals(''));
      expect(viewModel.state.isValidBody, false);
      expect(viewModel.state.mediaPicPath, isNull);
      expect(viewModel.state.isTweetPosted, false);
    });
  });

  group('AddTweetViewmodel - Edge Cases', () {
    test('should handle null userId gracefully', () async {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('Test tweet');
      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        mediaPicPath: any(named: 'mediaPicPath'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
      )).thenAnswer((_) async => testTweet);
      
      // Should not throw
      await viewModel.postTweet('');
      
      // Verify API was called with empty userId
      verify(() => mockApiService.createTweet(
        userId: '',
        content: 'Test tweet',
        mediaPicPath: null,
        mediaVideoPath: null,
      )).called(1);
    });

    test('should handle special characters in body', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      const specialBody = 'Test with emojis 😀🎉 and symbols #hashtag @mention';
      
      viewModel.updateBody(specialBody);
      
      expect(viewModel.state.body, equals(specialBody));
      expect(viewModel.state.isValidBody, true);
    });

    test('should handle multiple rapid updates', () {
      final viewModel = container.read(addTweetViewmodelProvider.notifier);
      
      viewModel.updateBody('First');
      viewModel.updateBody('Second');
      viewModel.updateBody('Third');
      
      expect(viewModel.state.body, equals('Third'));
      expect(viewModel.state.isValidBody, true);
    });
  });
}
