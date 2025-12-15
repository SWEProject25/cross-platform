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

  // --------------------
  // TEST: refreshBlockedUsers success
  // --------------------
  test('refreshBlockedUsers updates state with fresh data', () async {
    // Initial load
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(blockedUsersProvider.notifier);
    await notifier.future;

    var state = container.read(blockedUsersProvider).value!;
    expect(state.blockedUsers.length, 2);

    // Mock new data for refresh
    final userC = UserModel(
      id: 3,
      username: "charlie",
      email: "c@mail.com",
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

    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB, userC]);

    // Call refresh
    await notifier.refreshBlockedUsers();

    state = container.read(blockedUsersProvider).value!;
    expect(state.blockedUsers.length, 3);
    expect(state.blockedUsers[2].id, 3);
    expect(state.blockedUsers[2].username, "charlie");
  });

  // --------------------
  // TEST: refreshBlockedUsers sets loading state
  // --------------------
  test('refreshBlockedUsers sets AsyncLoading state during refresh', () async {
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(blockedUsersProvider.notifier);
    await notifier.future;

    // Mock delayed response to catch loading state
    when(() => mockRepo.fetchBlockedUsers()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return [userA];
    });

    // Start refresh (don't await yet)
    final refreshFuture = notifier.refreshBlockedUsers();

    // Check loading state
    await Future.delayed(const Duration(milliseconds: 10));
    final loadingState = container.read(blockedUsersProvider);
    expect(loadingState.isLoading, true);

    // Wait for completion
    await refreshFuture;

    final finalState = container.read(blockedUsersProvider);
    expect(finalState.isLoading, false);
    expect(finalState.hasValue, true);
  });

  // --------------------
  // TEST: refreshBlockedUsers error
  // --------------------
  test('refreshBlockedUsers sets AsyncError on failure', () async {
    // Initial load success
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(blockedUsersProvider.notifier);
    await notifier.future;

    // Mock error on refresh
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenThrow(Exception("Network error"));

    await notifier.refreshBlockedUsers();

    final state = container.read(blockedUsersProvider);
    expect(state.hasError, true);
    expect(state.error.toString(), contains("Network error"));
  });

  // --------------------
  // TEST: refreshBlockedUsers with empty list
  // --------------------
  test('refreshBlockedUsers handles empty list', () async {
    // Initial load with users
    when(
      () => mockRepo.fetchBlockedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(blockedUsersProvider.notifier);
    await notifier.future;

    // Refresh returns empty list
    when(() => mockRepo.fetchBlockedUsers()).thenAnswer((_) async => []);

    await notifier.refreshBlockedUsers();

    final state = container.read(blockedUsersProvider).value!;
    expect(state.blockedUsers.length, 0);
    expect(state.blockedUsers, isEmpty);
  });
}
