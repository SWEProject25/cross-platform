import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/settings/ui/viewmodel/blocked_users_viewmodel.dart';
import 'package:lam7a/features/settings/repository/user_releations_repository.dart';
import 'package:lam7a/core/models/user_model.dart';

// --------------------
// MOCKS
// --------------------
class MockUserRelationsRepository extends Mock
    implements UserRelationsRepository {}

void main() {
  late ProviderContainer container;
  late MockUserRelationsRepository mockRepo;

  final userA = UserModel(
    id: 1,
    username: "alice",
    email: "a@mail.com",
    role: "",
    name: "",
    birthDate: "",
    profileImageUrl: "",
    bannerImageUrl: "",
    bio: "",
    location: "",
    website: "",
    createdAt: "",
  );

  final userB = UserModel(
    id: 2,
    username: "bob",
    email: "b@mail.com",
    role: "",
    name: "",
    birthDate: "",
    profileImageUrl: "",
    bannerImageUrl: "",
    bio: "",
    location: "",
    website: "",
    createdAt: "",
  );

  setUp(() {
    mockRepo = MockUserRelationsRepository();

    container = ProviderContainer(
      overrides: [
        userRelationsRepositoryProvider.overrideWith((ref) => mockRepo),
      ],
    );
  });

  // --------------------
  // TEST: build() loads blocked users
  // --------------------
  test('build() loads blocked users from repository', () async {
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final state = await container.read(blockedUsersProvider.future);

    expect(state.blockedUsers.length, 2);
    expect(state.blockedUsers[0].id, 1);
    expect(state.blockedUsers[1].id, 2);
  });

  // --------------------
  // TEST: unblockUser success
  // --------------------
  test('unblockUser removes user from state on success', () async {
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    when(() => mockRepo.unblockUser(1)).thenAnswer((_) async => Future.value());

    final notifier = container.read(blockedUsersProvider.notifier);

    // Trigger initial load
    await notifier.future;

    // Unblock userA
    await notifier.unblockUser(1);

    final state = container.read(blockedUsersProvider).value!;

    expect(state.blockedUsers.length, 1);
    expect(state.blockedUsers.first.id, 2);
  });

  // --------------------
  // TEST: unblockUser error → reverts to previous list
  // --------------------
  test('unblockUser error restores old list after AsyncError', () async {
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    when(() => mockRepo.unblockUser(1)).thenThrow(Exception("Failed"));

    final notifier = container.read(blockedUsersProvider.notifier);

    await notifier.future; // initial load

    await notifier.unblockUser(1);

    final state = container.read(blockedUsersProvider).value!;

    // Should still have both users
    expect(state.blockedUsers.length, 2);
  });
}
