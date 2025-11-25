import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/settings/ui/viewmodel/muted_users_viewmodel.dart';
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
  // TEST: build() loads muted users
  // --------------------
  test('build() loads muted users from repository', () async {
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final state = await container.read(mutedUsersProvider.future);

    expect(state.mutedUsers.length, 2);
    expect(state.mutedUsers.first.id, 1);
    expect(state.mutedUsers.last.id, 2);
  });

  // --------------------
  // TEST: unmuteUser removes from list on success
  // --------------------
  test('unmuteUser removes user from muted list on success', () async {
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    when(() => mockRepo.unmuteUser(1)).thenAnswer((_) async => Future.value());

    final notifier = container.read(mutedUsersProvider.notifier);

    await notifier.future; // initial load

    await notifier.unmuteUser(1);

    final state = container.read(mutedUsersProvider).value!;

    expect(state.mutedUsers.length, 1);
    expect(state.mutedUsers.first.id, 2);
  });

  // --------------------
  // TEST: unmuteUser failure → AsyncError
  // --------------------
  test('unmuteUser failure sets AsyncError state', () async {
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    when(() => mockRepo.unmuteUser(1)).thenThrow(Exception("network error"));

    final notifier = container.read(mutedUsersProvider.notifier);

    await notifier.future; // initial load

    await notifier.unmuteUser(1);

    final state = container.read(mutedUsersProvider);

    expect(state.hasError, true);
  });
}
