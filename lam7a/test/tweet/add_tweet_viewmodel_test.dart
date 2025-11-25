import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service.dart';
import 'package:lam7a/features/add_tweet/services/add_tweet_api_service_impl.dart';
import 'package:lam7a/features/add_tweet/ui/state/add_tweet_state.dart';
import 'package:lam7a/features/add_tweet/ui/viewmodel/add_tweet_viewmodel.dart';
import 'package:lam7a/features/common/models/tweet_model.dart';
import 'package:lam7a/features/tweet/ui/viewmodel/tweet_home_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTweetApiService extends Mock implements AddTweetApiService {}

class FakeTweetHomeViewModel extends TweetHomeViewModel {
  final List<TweetModel> upsertedTweets = [];

  @override
  Future<Map<String, List<TweetModel>>> build() async {
    return {
      'for-you': <TweetModel>[],
    };
  }

  @override
  void upsertTweetLocally(TweetModel tweet) {
    upsertedTweets.add(tweet);
  }
}

class FakeAuthentication extends Authentication {
  @override
  AuthState build() {
    return AuthState(
      user: const UserModel(
        id: 10,
        username: 'alice',
        name: 'Alice',
        profileImageUrl: 'avatar.png',
      ),
      isAuthenticated: true,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late MockAddTweetApiService mockApiService;
  late FakeTweetHomeViewModel fakeHomeVm;

  final baseTweet = TweetModel(
    id: 't1',
    body: 'hello',
    date: DateTime(2025, 1, 1),
    userId: 'u1',
  );

  setUp(() {
    mockApiService = MockAddTweetApiService();

    container = ProviderContainer(
      overrides: [
        addTweetApiServiceProvider.overrideWithValue(mockApiService),
        tweetHomeViewModelProvider.overrideWith(FakeTweetHomeViewModel.new),
      ],
    );

    fakeHomeVm = container.read(
      tweetHomeViewModelProvider.notifier,
    ) as FakeTweetHomeViewModel;
  });

  tearDown(() {
    container.dispose();
  });

  group('AddTweetViewmodel', () {
    test('initial state is default AddTweetState', () {
      final state = container.read(addTweetViewmodelProvider);
      expect(state, const AddTweetState());
    });

    test('updateBody validates content length and clears error', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      // Invalid (only whitespace)
      vm.updateBody('   ');
      var state = container.read(addTweetViewmodelProvider);
      expect(state.body, '   ');
      expect(state.isValidBody, false);
      expect(state.errorMessage, isNull);

      // Valid body
      vm.updateBody('Hello');
      state = container.read(addTweetViewmodelProvider);
      expect(state.body, 'Hello');
      expect(state.isValidBody, true);
      expect(state.errorMessage, isNull);

      // Too long body
      final longBody = 'a' * (AddTweetViewmodel.maxBodyLength + 1);
      vm.updateBody(longBody);
      state = container.read(addTweetViewmodelProvider);
      expect(state.isValidBody, false);
    });

    test('addMediaPic respects maxMediaImages', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      for (var i = 0; i < AddTweetViewmodel.maxMediaImages + 2; i++) {
        vm.addMediaPic('path_$i');
      }

      final state = container.read(addTweetViewmodelProvider);
      expect(state.mediaPicPaths.length, AddTweetViewmodel.maxMediaImages);
      expect(state.mediaPicPaths.first, 'path_0');
      expect(state.mediaPicPaths.last, 'path_3');
    });

    test('removeMediaPicAt ignores invalid indexes and removes valid index', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);
      vm.addMediaPic('a');
      vm.addMediaPic('b');
      vm.addMediaPic('c');

      // Invalid indexes
      vm.removeMediaPicAt(-1);
      vm.removeMediaPicAt(3);
      var state = container.read(addTweetViewmodelProvider);
      expect(state.mediaPicPaths, ['a', 'b', 'c']);

      // Valid index
      vm.removeMediaPicAt(1);
      state = container.read(addTweetViewmodelProvider);
      expect(state.mediaPicPaths, ['a', 'c']);
    });

    test('updateMediaVideo and removeMediaVideo update state', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateMediaVideo('video.mp4');
      var state = container.read(addTweetViewmodelProvider);
      expect(state.mediaVideoPath, 'video.mp4');

      vm.removeMediaVideo();
      state = container.read(addTweetViewmodelProvider);
      expect(state.mediaVideoPath, isNull);
    });

    test('canPostTweet depends on isValidBody and isLoading', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      // Initially invalid
      expect(vm.canPostTweet(), false);

      vm.updateBody('Valid body');
      expect(container.read(addTweetViewmodelProvider).isValidBody, true);
      expect(vm.canPostTweet(), true);

      // When loading, cannot post
      vm.state = vm.state.copyWith(isLoading: true);
      expect(vm.canPostTweet(), false);
    });

    test('setReplyTo and setQuoteTo configure post type and parent id', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.setReplyTo(42);
      var state = container.read(addTweetViewmodelProvider);
      expect(state.parentPostId, 42);
      expect(state.postType, 'REPLY');

      vm.setQuoteTo(99);
      state = container.read(addTweetViewmodelProvider);
      expect(state.parentPostId, 99);
      expect(state.postType, 'QUOTE');
    });

    test('postTweet with invalid body sets error and does not call API', () async {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      // Body is empty and invalid by default
      await vm.postTweet();
      final state = container.read(addTweetViewmodelProvider);

      expect(state.errorMessage, 'Please enter valid tweet content');
      expect(state.isLoading, false);

      verifyNever(() => mockApiService.createTweet(
            userId: any(named: 'userId'),
            content: any(named: 'content'),
            mediaPicPaths: any(named: 'mediaPicPaths'),
            mediaVideoPath: any(named: 'mediaVideoPath'),
            type: any(named: 'type'),
            parentPostId: any(named: 'parentPostId'),
          ));
    });

    test('postTweet posts reply and skips home timeline upsert', () async {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateBody('Reply body');
      vm.setReplyTo(7);

      when(() => mockApiService.createTweet(
            userId: any(named: 'userId'),
            content: any(named: 'content'),
            mediaPicPaths: any(named: 'mediaPicPaths'),
            mediaVideoPath: any(named: 'mediaVideoPath'),
            type: any(named: 'type'),
            parentPostId: any(named: 'parentPostId'),
          )).thenAnswer((_) async => baseTweet);

      await vm.postTweet();

      final state = container.read(addTweetViewmodelProvider);
      expect(state.isLoading, false);
      expect(state.isTweetPosted, true);
      expect(state.errorMessage, isNull);

      // Uses fallback user id 1 when not authenticated
      verify(() => mockApiService.createTweet(
            userId: 1,
            content: 'Reply body',
            mediaPicPaths: const <String>[],
            mediaVideoPath: null,
            type: 'REPLY',
            parentPostId: 7,
          )).called(1);

      // Replies should not be injected into home timeline
      expect(fakeHomeVm.upsertedTweets, isEmpty);
    });

    test('postTweet for POST injects tweet into home timeline using authenticated user',
        () async {
      // Recreate container with authenticated user override
      container.dispose();
      mockApiService = MockAddTweetApiService();

      container = ProviderContainer(
        overrides: [
          addTweetApiServiceProvider.overrideWithValue(mockApiService),
          tweetHomeViewModelProvider.overrideWith(FakeTweetHomeViewModel.new),
          authenticationProvider.overrideWith(FakeAuthentication.new),
        ],
      );

      fakeHomeVm = container.read(
        tweetHomeViewModelProvider.notifier,
      ) as FakeTweetHomeViewModel;

      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateBody('Hello world');

      final backendTweet = baseTweet.copyWith(body: 'Hello world');

      when(() => mockApiService.createTweet(
            userId: any(named: 'userId'),
            content: any(named: 'content'),
            mediaPicPaths: any(named: 'mediaPicPaths'),
            mediaVideoPath: any(named: 'mediaVideoPath'),
            type: any(named: 'type'),
            parentPostId: any(named: 'parentPostId'),
          )).thenAnswer((_) async => backendTweet);

      await vm.postTweet();

      // Should use authenticated user id
      verify(() => mockApiService.createTweet(
            userId: 10,
            content: 'Hello world',
            mediaPicPaths: const <String>[],
            mediaVideoPath: null,
            type: 'POST',
            parentPostId: null,
          )).called(1);

      // Home timeline should receive tweet enriched with authenticated user info
      expect(fakeHomeVm.upsertedTweets, hasLength(1));
      final injected = fakeHomeVm.upsertedTweets.single;
      expect(injected.username, 'alice');
      expect(injected.authorName, 'Alice');
      expect(injected.authorProfileImage, 'avatar.png');
    });

    test('postTweet handles API error and sets error message', () async {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateBody('Body that will fail');
      vm.setReplyTo(5);

      when(() => mockApiService.createTweet(
            userId: any(named: 'userId'),
            content: any(named: 'content'),
            mediaPicPaths: any(named: 'mediaPicPaths'),
            mediaVideoPath: any(named: 'mediaVideoPath'),
            type: any(named: 'type'),
            parentPostId: any(named: 'parentPostId'),
          )).thenThrow(Exception('network error'));

      await vm.postTweet();

      final state = container.read(addTweetViewmodelProvider);
      expect(state.isLoading, false);
      expect(state.isTweetPosted, false);
      expect(state.errorMessage, contains('Failed to post tweet'));

      // On error, home timeline must not be updated
      expect(fakeHomeVm.upsertedTweets, isEmpty);
    });

    test('reset clears state back to defaults', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateBody('Some body');
      vm.addMediaPic('path');
      vm.updateMediaVideo('video.mp4');

      vm.reset();

      final state = container.read(addTweetViewmodelProvider);
      expect(state, const AddTweetState());
    });

    test('character count helpers report correct values', () {
      final vm = container.read(addTweetViewmodelProvider.notifier);

      vm.updateBody('abcd');

      final count = vm.getCharacterCount();
      final remaining = vm.getRemainingCharacters();

      expect(count, 4);
      expect(remaining, AddTweetViewmodel.maxBodyLength - 4);
    });
  });
}

