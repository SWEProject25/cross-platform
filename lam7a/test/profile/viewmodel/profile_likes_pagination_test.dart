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
}
