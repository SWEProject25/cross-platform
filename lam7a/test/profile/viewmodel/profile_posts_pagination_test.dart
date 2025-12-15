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
}
