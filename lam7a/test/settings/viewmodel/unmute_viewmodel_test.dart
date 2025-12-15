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

  // --------------------
  // TEST: refreshMutedUsers success
  // --------------------
  test('refreshMutedUsers updates state with fresh data', () async {
    // Initial load
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(mutedUsersProvider.notifier);
    await notifier.future;

    var state = container.read(mutedUsersProvider).value!;
    expect(state.mutedUsers.length, 2);

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
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB, userC]);

    // Call refresh
    await notifier.refreshMutedUsers();

    state = container.read(mutedUsersProvider).value!;
    expect(state.mutedUsers.length, 3);
    expect(state.mutedUsers[2].id, 3);
    expect(state.mutedUsers[2].username, "charlie");
  });

  // --------------------
  // TEST: refreshMutedUsers sets loading state
  // --------------------
  test('refreshMutedUsers sets AsyncLoading state during refresh', () async {
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(mutedUsersProvider.notifier);
    await notifier.future;

    // Mock delayed response to catch loading state
    when(() => mockRepo.fetchMutedUsers()).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return [userA];
    });

    // Start refresh (don't await yet)
    final refreshFuture = notifier.refreshMutedUsers();

    // Check loading state
    await Future.delayed(const Duration(milliseconds: 10));
    final loadingState = container.read(mutedUsersProvider);
    expect(loadingState.isLoading, true);

    // Wait for completion
    await refreshFuture;

    final finalState = container.read(mutedUsersProvider);
    expect(finalState.isLoading, false);
    expect(finalState.hasValue, true);
  });

  // --------------------
  // TEST: refreshMutedUsers error
  // --------------------
  test('refreshMutedUsers sets AsyncError on failure', () async {
    // Initial load success
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(mutedUsersProvider.notifier);
    await notifier.future;

    // Mock error on refresh
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenThrow(Exception("Network error"));

    await notifier.refreshMutedUsers();

    final state = container.read(mutedUsersProvider);
    expect(state.hasError, true);
    expect(state.error.toString(), contains("Network error"));
  });

  // --------------------
  // TEST: refreshMutedUsers with empty list
  // --------------------
  test('refreshMutedUsers handles empty list', () async {
    // Initial load with users
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(mutedUsersProvider.notifier);
    await notifier.future;

    var state = container.read(mutedUsersProvider).value!;
    expect(state.mutedUsers.length, 2);

    // Refresh returns empty list
    when(() => mockRepo.fetchMutedUsers()).thenAnswer((_) async => []);

    await notifier.refreshMutedUsers();

    state = container.read(mutedUsersProvider).value!;
    expect(state.mutedUsers.length, 0);
    expect(state.mutedUsers, isEmpty);
  });

  // --------------------
  // TEST: refreshMutedUsers replaces previous data
  // --------------------
  test('refreshMutedUsers replaces previous data completely', () async {
    // Initial load
    when(
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userA, userB]);

    final notifier = container.read(mutedUsersProvider.notifier);
    await notifier.future;

    // Refresh with completely different users
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

    final userD = UserModel(
      id: 4,
      username: "diana",
      email: "d@mail.com",
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
      () => mockRepo.fetchMutedUsers(),
    ).thenAnswer((_) async => [userC, userD]);

    await notifier.refreshMutedUsers();

    final state = container.read(mutedUsersProvider).value!;
    expect(state.mutedUsers.length, 2);
    expect(state.mutedUsers[0].id, 3);
    expect(state.mutedUsers[1].id, 4);
    expect(state.mutedUsers.any((u) => u.id == 1), false);
    expect(state.mutedUsers.any((u) => u.id == 2), false);
  });
}
