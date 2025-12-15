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
}
