import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/viewmodel/profile_likes_pagination.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  test('loads initial liked posts', () async {
    final fakeApi = FakeProfileApiService()
      ..likes = [
        {
          "postId": 5,
          "userId": "1",
          "username": "tester",
          "name": "Tester",
          "text": "Liked post",
          "likesCount": 5,
          "commentsCount": 1,
          "retweetsCount": 0,
          "isLikedByMe": true,
          "date": DateTime.now().toIso8601String(),
        }
      ];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    final notifier =
        container.read(profileLikesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileLikesProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'Liked post');
    expect(state.hasMore, false);
  });

  test('handles empty likes list', () async {
    final fakeApi = FakeProfileApiService()..likes = [];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileLikesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileLikesProvider('1'));

    expect(state.items, isEmpty);
    expect(state.hasMore, false);
  });

  test('sets hasMore = true when page is full', () async {
    final fakeApi = FakeProfileApiService()
      ..likes = List.generate(
        20, // assume pageSize = 20
        (i) => {
          "postId": i,
          "userId": "1",
          "username": "tester",
          "name": "Tester",
          "text": "Post $i",
          "date": DateTime.now().toIso8601String(),
        },
      );

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileLikesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileLikesProvider('1'));

    expect(state.items.length, 20);
    expect(state.hasMore, true);
  });

  test('loadMore appends items', () async {
    final fakeApi = FakeProfileApiService()
      ..likes = [
        {
          "postId": 1,
          "userId": "1",
          "username": "tester",
          "name": "Tester",
          "text": "First",
          "date": DateTime.now().toIso8601String(),
        }
      ];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileLikesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    // Simulate second page
    fakeApi.likes = [
      {
        "postId": 2,
        "userId": "1",
        "username": "tester",
        "name": "Tester",
        "text": "Second",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.loadMore();

    final state = container.read(profileLikesProvider('1'));

    expect(state.items.length, 2);
    expect(state.items.last.body, 'Second');
  });

  test('refresh reloads likes', () async {
    final fakeApi = FakeProfileApiService()
      ..likes = [
        {
          "postId": 1,
          "userId": "1",
          "username": "tester",
          "name": "Tester",
          "text": "Old",
          "date": DateTime.now().toIso8601String(),
        }
      ];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(profileLikesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    // Change backend response
    fakeApi.likes = [
      {
        "postId": 2,
        "userId": "1",
        "username": "tester",
        "name": "Tester",
        "text": "New",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.refresh();

    final state = container.read(profileLikesProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'New');
  });

  test('normalizeTweetJson maps fields correctly', () {
    final notifier = ProfileLikesPaginationNotifier('1');

    final result = notifier.normalizeTweetJson({
      "postId": 10,
      "text": "Hello",
      "date": "2024-01-01",
      "userId": 1,
      "username": "tester",
      "name": "Tester",
      "likesCount": 3,
    });

    expect(result['id'], 10);
    expect(result['text'], 'Hello');
    expect(result['likesCount'], 3);
    expect(result['user']['username'], 'tester');
    expect(result['isRepost'], false);
  });


}
