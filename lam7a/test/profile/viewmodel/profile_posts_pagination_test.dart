import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/viewmodel/profile_posts_pagination.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  test('loads initial profile posts', () async {
    final fakeApi = FakeProfileApiService()
      ..posts = [
        {
          "postId": 1,
          "userId": "1",
          "username": "test",
          "text": "Hello",
          "likesCount": 1,
          "commentsCount": 0,
          "retweetsCount": 0,
          "date": DateTime.now().toIso8601String(),
        }
      ];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );

    addTearDown(container.dispose);

    // 🔹 Read notifier to trigger build()
    final state = container.read(profilePostsProvider('1'));

    // 🔹 Allow async loadInitial() to finish
    await Future.delayed(const Duration(milliseconds: 10));

    final updatedState = container.read(profilePostsProvider('1'));

    expect(updatedState.items.length, 1);
    expect(updatedState.items.first.body, 'Hello');
  });

  test('handles empty posts list', () async {
    final fakeApi = FakeProfileApiService()..posts = [];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    container.read(profilePostsProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profilePostsProvider('1'));

    expect(state.items, isEmpty);
    expect(state.hasMore, false);
  });
  test('uses originalPostData when present', () async {
    final fakeApi = FakeProfileApiService()
      ..posts = [
        {
          "originalPostData": {
            "postId": 99,
            "userId": "1",
            "username": "orig",
            "name": "Original",
            "text": "Original post",
            "date": DateTime.now().toIso8601String(),
          }
        }
      ];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    container.read(profilePostsProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profilePostsProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'Original post');
  });

  test('sets hasMore true when page is full', () async {
    final fakeApi = FakeProfileApiService()
      ..posts = List.generate(
        20, // pageSize
        (i) => {
          "postId": i,
          "userId": "1",
          "username": "test",
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

    container.read(profilePostsProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profilePostsProvider('1'));

    expect(state.items.length, 20);
    expect(state.hasMore, true);
  });

  test('loadMore appends posts', () async {
    final fakeApi = FakeProfileApiService()
      ..posts = [
        {
          "postId": 1,
          "userId": "1",
          "username": "test",
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

    final notifier =
        container.read(profilePostsProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    fakeApi.posts = [
      {
        "postId": 2,
        "userId": "1",
        "username": "test",
        "text": "Second",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.loadMore();

    final state = container.read(profilePostsProvider('1'));

    expect(state.items.length, 2);
    expect(state.items.last.body, 'Second');
  });

  test('refresh reloads posts', () async {
    final fakeApi = FakeProfileApiService()
      ..posts = [
        {
          "postId": 1,
          "userId": "1",
          "username": "test",
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

    final notifier =
        container.read(profilePostsProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    fakeApi.posts = [
      {
        "postId": 2,
        "userId": "1",
        "username": "test",
        "text": "New",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.refresh();

    final state = container.read(profilePostsProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'New');
  });

  test('normalizeTweetJson maps fields correctly', () {
    final notifier = ProfilePostsPaginationNotifier('1');

    final json = notifier.normalizeTweetJson({
      "postId": 10,
      "text": "Hello",
      "date": "2024-01-01",
      "userId": 1,
      "username": "tester",
      "name": "Tester",
      "likesCount": 3,
    });

    expect(json['id'], 10);
    expect(json['text'], 'Hello');
    expect(json['likesCount'], 3);
    expect(json['user']['username'], 'tester');
    expect(json['isRepost'], false);
  });


}
