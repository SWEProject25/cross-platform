import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/profile/ui/viewmodel/profile_replies_pagination.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/fake_profile_api.dart';

void main() {
  test('loads initial profile replies', () async {
    final fakeApi = FakeProfileApiService()
      ..replies = [
        {
          "postId": 10,
          "userId": "1",
          "username": "tester",
          "name": "Tester",
          "text": "This is a reply",
          "likesCount": 2,
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

    final notifier =
        container.read(profileRepliesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'This is a reply');
    expect(state.hasMore, false);
  });

  test('handles empty replies list', () async {
    final fakeApi = FakeProfileApiService()..replies = [];

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileRepliesProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items, isEmpty);
    expect(state.hasMore, false);
  });

  test('uses originalPostData when present', () async {
    final fakeApi = FakeProfileApiService()
      ..replies = [
        {
          "originalPostData": {
            "postId": 99,
            "userId": "1",
            "username": "orig",
            "name": "Original",
            "text": "Original reply",
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

    container.read(profileRepliesProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'Original reply');
  });

  test('sets hasMore true when page is full', () async {
    final fakeApi = FakeProfileApiService()
      ..replies = List.generate(
        20, // pageSize
        (i) => {
          "postId": i,
          "userId": "1",
          "username": "tester",
          "text": "Reply $i",
          "date": DateTime.now().toIso8601String(),
        },
      );

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(fakeApi),
      ],
    );
    addTearDown(container.dispose);

    container.read(profileRepliesProvider('1'));
    await Future<void>.delayed(Duration.zero);

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items.length, 20);
    expect(state.hasMore, true);
  });

  test('loadMore appends replies', () async {
    final fakeApi = FakeProfileApiService()
      ..replies = [
        {
          "postId": 1,
          "userId": "1",
          "username": "tester",
          "text": "First reply",
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
        container.read(profileRepliesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    fakeApi.replies = [
      {
        "postId": 2,
        "userId": "1",
        "username": "tester",
        "text": "Second reply",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.loadMore();

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items.length, 2);
    expect(state.items.last.body, 'Second reply');
  });

  test('refresh reloads replies', () async {
    final fakeApi = FakeProfileApiService()
      ..replies = [
        {
          "postId": 1,
          "userId": "1",
          "username": "tester",
          "text": "Old reply",
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
        container.read(profileRepliesProvider('1').notifier);

    notifier.loadInitial();
    await Future<void>.delayed(Duration.zero);

    fakeApi.replies = [
      {
        "postId": 2,
        "userId": "1",
        "username": "tester",
        "text": "New reply",
        "date": DateTime.now().toIso8601String(),
      }
    ];

    await notifier.refresh();

    final state = container.read(profileRepliesProvider('1'));

    expect(state.items.length, 1);
    expect(state.items.first.body, 'New reply');
  });

  test('normalizeTweetJson maps fields correctly', () {
    final notifier = ProfileRepliesPaginationNotifier('1');

    final json = notifier.normalizeTweetJson({
      "postId": 10,
      "text": "Reply text",
      "date": "2024-01-01",
      "userId": 1,
      "username": "tester",
      "name": "Tester",
      "likesCount": 3,
    });

    expect(json['id'], 10);
    expect(json['text'], 'Reply text');
    expect(json['likesCount'], 3);
    expect(json['user']['username'], 'tester');
    expect(json['isRepost'], false);
  });


}
