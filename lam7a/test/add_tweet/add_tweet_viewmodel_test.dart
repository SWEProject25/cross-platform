import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/user_new_tweets_viewmodel.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';

// Mocks
class MockAddTweetApiService extends Mock implements AddTweetApiService {}

// Mocking the Notifiers
class MockAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState(
      user: UserModel(id: 1, username: 'testuser', email: 'test@example.com'),
      isAuthenticated: true,
    );
  }
}

class MockUserNewTweetsViewModel extends UserNewTweetsViewModel with Mock {
  @override
  List<TweetModel> build() => [];
}

class MockTweetHomeViewModel extends TweetHomeViewModel with Mock {
  @override
  Future<Map<String, List<TweetModel>>> build() async => {};
}

void main() {
  late ProviderContainer container;
  late MockAddTweetApiService mockApiService;
  late MockUserNewTweetsViewModel mockUserNewTweetsViewModel;
  late MockTweetHomeViewModel mockTweetHomeViewModel;

  setUp(() {
    mockApiService = MockAddTweetApiService();
    mockUserNewTweetsViewModel = MockUserNewTweetsViewModel();
    mockTweetHomeViewModel = MockTweetHomeViewModel();

    container = ProviderContainer(
      overrides: [
        addTweetApiServiceProvider.overrideWithValue(mockApiService),
        authenticationProvider.overrideWith(() => MockAuthentication()),
        userNewTweetsViewModelProvider.overrideWith(() => mockUserNewTweetsViewModel),
        tweetHomeViewModelProvider.overrideWith(() => mockTweetHomeViewModel),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AddTweetViewmodel Tests', () {
    test('Initial state is correct', () {
      final state = container.read(addTweetViewmodelProvider);
      expect(state.body, isEmpty);
      expect(state.mediaPicPaths, isEmpty);
      expect(state.mediaVideoPath, isNull);
      expect(state.isLoading, isFalse);
      expect(state.isValidBody, isFalse);
    });

    test('updateBody updates state and validation', () {
      final notifier = container.read(addTweetViewmodelProvider.notifier);

      notifier.updateBody('Hello world');
      expect(container.read(addTweetViewmodelProvider).body, 'Hello world');
      expect(container.read(addTweetViewmodelProvider).isValidBody, isTrue);

      notifier.updateBody('');
      expect(container.read(addTweetViewmodelProvider).body, '');
      expect(container.read(addTweetViewmodelProvider).isValidBody, isFalse);

      notifier.updateBody('   ');
      expect(container.read(addTweetViewmodelProvider).body, '   ');
      expect(container.read(addTweetViewmodelProvider).isValidBody, isFalse);
    });

    test('addMediaPic adds images up to limit', () {
      final notifier = container.read(addTweetViewmodelProvider.notifier);

      notifier.addMediaPic('path/to/image1.jpg');
      expect(container.read(addTweetViewmodelProvider).mediaPicPaths.length, 1);

      notifier.addMediaPic('path/to/image2.jpg');
      notifier.addMediaPic('path/to/image3.jpg');
      notifier.addMediaPic('path/to/image4.jpg');
      expect(container.read(addTweetViewmodelProvider).mediaPicPaths.length, 4);

      // Try adding 5th image
      notifier.addMediaPic('path/to/image5.jpg');
      expect(container.read(addTweetViewmodelProvider).mediaPicPaths.length, 4);
    });

    test('removeMediaPicAt removes image at index', () {
      final notifier = container.read(addTweetViewmodelProvider.notifier);

      notifier.addMediaPic('path1');
      notifier.addMediaPic('path2');
      
      notifier.removeMediaPicAt(0);
      expect(container.read(addTweetViewmodelProvider).mediaPicPaths.length, 1);
      expect(container.read(addTweetViewmodelProvider).mediaPicPaths[0], 'path2');
    });

    test('setReplyTo sets post type correctly', () {
       final notifier = container.read(addTweetViewmodelProvider.notifier);
       notifier.setReplyTo(123);
       
       final state = container.read(addTweetViewmodelProvider);
       expect(state.parentPostId, 123);
       expect(state.postType, 'REPLY');
    });

    test('postTweet success flow', () async {
      final notifier = container.read(addTweetViewmodelProvider.notifier);
      notifier.updateBody('Valid tweet');
      
      final createdTweet = TweetModel(
        id: '100',
        userId: '1',
        body: 'Valid tweet',
        date: DateTime.now(),
        likes: 0,
        repost: 0,
        comments: 0,
        views: 0,
        qoutes: 0,
        bookmarks: 0,
        mediaImages: [],
        mediaVideos: [],
      );

      when(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
        type: any(named: 'type'),
      )).thenAnswer((_) async => createdTweet);

      await notifier.postTweet();

      final state = container.read(addTweetViewmodelProvider);
      expect(state.isLoading, isFalse);
      expect(state.isTweetPosted, isTrue);
      expect(state.errorMessage, isNull);

      verify(() => mockApiService.createTweet(
        userId: 1,
        content: 'Valid tweet',
        mediaPicPaths: any(named: 'mediaPicPaths'),
        mediaVideoPath: any(named: 'mediaVideoPath'),
        type: 'POST',
        parentPostId: any(named: 'parentPostId'),
        mentionsIds: any(named: 'mentionsIds'),
      )).called(1);
    });

    test('postTweet fails with invalid body', () async {
      final notifier = container.read(addTweetViewmodelProvider.notifier);
      notifier.updateBody(''); // Invalid

      await notifier.postTweet();

      final state = container.read(addTweetViewmodelProvider);
      expect(state.errorMessage, isNotNull);
      verifyNever(() => mockApiService.createTweet(
        userId: any(named: 'userId'),
        content: any(named: 'content'),
      ));
    });
  });
}
