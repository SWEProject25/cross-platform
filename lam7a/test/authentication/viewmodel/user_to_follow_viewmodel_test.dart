import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/models/auth_state.dart';
import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/users_to_follow_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

class FakeAuthentication extends Authentication {
  UserModel? lastAuthenticatedUser;
  int updateUserCallCount = 0;

  @override
  AuthState build() {
    return AuthState(
      isAuthenticated: true,
      user: UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
        followingCount: 0,
        followersCount: 0,
      ),
    );
  }

  @override
  void updateUser(UserModel updatedUser) {
    lastAuthenticatedUser = updatedUser;
    updateUserCallCount++;
    state = state.copyWith(user: updatedUser);
  }

  @override
  void authenticateUser(UserDtoAuth? user) {
    if (user == null) return;
    
    lastAuthenticatedUser = userDtoToUserModel(user);
    state = state.copyWith(
      token: null,
      isAuthenticated: true,
      user: lastAuthenticatedUser,
    );
  }

  @override
  Future<void> isAuthenticated() async {}

  @override
  UserModel userDtoToUserModel(UserDtoAuth dto) {
    return UserModel(
      id: dto.id,
      username: dto.user?.username,
      email: dto.user?.email,
      role: dto.user?.role,
      name: dto.name,
      profileImageUrl: dto.profileImageUrl,
      bannerImageUrl: dto.bannerImageUrl,
      bio: dto.bio,
      location: dto.location,
      website: dto.website,
      createdAt: dto.createdAt?.toIso8601String(),
      followersCount: dto.followersCount,
      followingCount: dto.followingCount,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepositoryImpl mockRepo;
  late FakeAuthentication fakeAuth;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();
    fakeAuth = FakeAuthentication();

    container = ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
        authenticationProvider.overrideWith(() => fakeAuth),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('UsersToFollowViewmodel - build (Initial State)', () {
    test('should load users to follow successfully on build', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          profileImageUrl: '/img2.jpg',
          bio: 'Designer',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 3,
          name: 'Bob Wilson',
          username: 'bobwilson',
          profileImageUrl: '/img3.jpg',
          bio: 'Product manager',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);

      final users = await container.read(usersToFollowViewmodelProvider.future);

      expect(users, mockUsers);
      expect(users.length, 3);
      expect(users[0].name, 'John Doe');
      expect(users[1].name, 'Jane Smith');
      expect(users[2].name, 'Bob Wilson');
      expect(users[2].isFollowing, true);
      
      verify(() => mockRepo.getUsersToFollow()).called(1);
    });

    test('should return empty list when no users available', () async {
      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => []);

      final users = await container.read(usersToFollowViewmodelProvider.future);

      expect(users, isEmpty);
      verify(() => mockRepo.getUsersToFollow()).called(1);
    });

    test('should have loading state initially', () {
      when(() => mockRepo.getUsersToFollow()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => [],
        ),
      );

      final state = container.read(usersToFollowViewmodelProvider);

      expect(state, isA<AsyncLoading>());
    });

    test('should handle error when loading users fails', () async {
      when(() => mockRepo.getUsersToFollow())
          .thenThrow(Exception('Network error'));

      final state = container.read(usersToFollowViewmodelProvider);

      // Wait for the error to propagate
      await Future.delayed(const Duration(milliseconds: 100));

      expect(
        container.read(usersToFollowViewmodelProvider),
        isA<AsyncError>(),
      );
    });

    test('should load single user', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);

      final users = await container.read(usersToFollowViewmodelProvider.future);

      expect(users.length, 1);
      expect(users[0].id, 1);
      expect(users[0].name, 'John Doe');
      expect(users[0].isFollowing, false);
    });
  });

  group('UsersToFollowViewmodel - followUser', () {
    test('should follow user and update state', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          profileImageUrl: '/img2.jpg',
          bio: 'Designer',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      // Wait for initial load
      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.followUser(1);

      final state = container.read(usersToFollowViewmodelProvider);
      final users = state.value!;

      expect(users[0].isFollowing, true);
      expect(users[1].isFollowing, false);
      verify(() => mockRepo.followUser(1)).called(1);
    });

    test('should follow user without affecting other users', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 3,
          name: 'User 3',
          username: 'user3',
          profileImageUrl: '/img3.jpg',
          bio: 'Bio 3',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.followUser(2);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, false);
      expect(users[1].isFollowing, true);
      expect(users[2].isFollowing, false);
    });

    test('should handle following multiple users sequentially', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      
      await notifier.followUser(1);
      await notifier.followUser(2);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, true);
      expect(users[1].isFollowing, true);
      verify(() => mockRepo.followUser(1)).called(1);
      verify(() => mockRepo.followUser(2)).called(1);
    });

    test('should handle follow when repository returns false', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => false);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.followUser(1);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      // State should still update even if repo returns false
      expect(users[0].isFollowing, true);
      verify(() => mockRepo.followUser(1)).called(1);
    });
  });

  group('UsersToFollowViewmodel - unfollowUser', () {
    test('should unfollow user and update state', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 2,
          name: 'Jane Smith',
          username: 'janesmith',
          profileImageUrl: '/img2.jpg',
          bio: 'Designer',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.unfollowUser(1);

      final state = container.read(usersToFollowViewmodelProvider);
      final users = state.value!;

      expect(users[0].isFollowing, false);
      expect(users[1].isFollowing, true);
      verify(() => mockRepo.unFollowUser(1)).called(1);
    });

    test('should update authentication user following count after unfollow', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final initialFollowingCount = container.read(authenticationProvider).user!.followingCount;

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.unfollowUser(1);

      expect(fakeAuth.updateUserCallCount, 1);
      expect(
        fakeAuth.lastAuthenticatedUser!.followingCount,
        initialFollowingCount + 1,
      );
    });

    test('should unfollow user without affecting other users', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 3,
          name: 'User 3',
          username: 'user3',
          profileImageUrl: '/img3.jpg',
          bio: 'Bio 3',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.unfollowUser(2);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, true);
      expect(users[1].isFollowing, false);
      expect(users[2].isFollowing, true);
    });

    test('should handle unfollowing multiple users sequentially', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      
      await notifier.unfollowUser(1);
      await notifier.unfollowUser(2);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, false);
      expect(users[1].isFollowing, false);
      verify(() => mockRepo.unFollowUser(1)).called(1);
      verify(() => mockRepo.unFollowUser(2)).called(1);
      expect(fakeAuth.updateUserCallCount, 2);
    });

    test('should handle unfollow when repository returns false', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => false);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      await notifier.unfollowUser(1);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      // State should still update even if repo returns false
      expect(users[0].isFollowing, false);
      verify(() => mockRepo.unFollowUser(1)).called(1);
    });
  });

  group('UsersToFollowViewmodel - Integration Tests', () {
    test('should handle complete flow of follow and unfollow', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: '/img1.jpg',
          bio: 'Software developer',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);

      // Follow user
      await notifier.followUser(1);
      expect(
        container.read(usersToFollowViewmodelProvider).value![0].isFollowing,
        true,
      );

      // Unfollow user
      await notifier.unfollowUser(1);
      expect(
        container.read(usersToFollowViewmodelProvider).value![0].isFollowing,
        false,
      );

      verify(() => mockRepo.followUser(1)).called(1);
      verify(() => mockRepo.unFollowUser(1)).called(1);
      expect(fakeAuth.updateUserCallCount, 1);
    });

    test('should handle mixed follow/unfollow operations on multiple users', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: false,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 3,
          name: 'User 3',
          username: 'user3',
          profileImageUrl: '/img3.jpg',
          bio: 'Bio 3',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);

      await notifier.followUser(1);
      await notifier.unfollowUser(2);
      await notifier.followUser(3);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, true);
      expect(users[1].isFollowing, false);
      expect(users[2].isFollowing, true);
    });

    test('should maintain following count across multiple operations', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: true,
        ),
        UserToFollowDto(
          id: 2,
          name: 'User 2',
          username: 'user2',
          profileImageUrl: '/img2.jpg',
          bio: 'Bio 2',
          isFollowing: true,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);

      await notifier.unfollowUser(1);
      await notifier.unfollowUser(2);

      // Should have updated user twice
      expect(fakeAuth.updateUserCallCount, 2);
    });
  });

  group('UsersToFollowViewmodel - Edge Cases', () {
    test('should handle user with null fields', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'John Doe',
          username: 'johndoe',
          profileImageUrl: null,
          bio: null,
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);

      final users = await container.read(usersToFollowViewmodelProvider.future);

      expect(users.length, 1);
      expect(users[0].profileImageUrl, null);
      expect(users[0].bio, null);
    });

    test('should handle following a user that does not exist in list', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);
      
      // Try to follow user with ID 999 that doesn't exist
      await notifier.followUser(999);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      // Should not affect existing user
      expect(users[0].isFollowing, false);
      verify(() => mockRepo.followUser(999)).called(1);
    });

    test('should handle large list of users', () async {
      final mockUsers = List.generate(
        100,
        (index) => UserToFollowDto(
          id: index + 1,
          name: 'User ${index + 1}',
          username: 'user${index + 1}',
          profileImageUrl: '/img${index + 1}.jpg',
          bio: 'Bio ${index + 1}',
          isFollowing: index % 2 == 0,
        ),
      );

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);

      final users = await container.read(usersToFollowViewmodelProvider.future);

      expect(users.length, 100);
      expect(users.first.id, 1);
      expect(users.last.id, 100);
    });

    test('should handle rapid follow/unfollow operations', () async {
      final mockUsers = [
        UserToFollowDto(
          id: 1,
          name: 'User 1',
          username: 'user1',
          profileImageUrl: '/img1.jpg',
          bio: 'Bio 1',
          isFollowing: false,
        ),
      ];

      when(() => mockRepo.getUsersToFollow()).thenAnswer((_) async => mockUsers);
      when(() => mockRepo.followUser(any())).thenAnswer((_) async => true);
      when(() => mockRepo.unFollowUser(any())).thenAnswer((_) async => true);

      await container.read(usersToFollowViewmodelProvider.future);

      final notifier = container.read(usersToFollowViewmodelProvider.notifier);

      // Rapid operations
      await notifier.followUser(1);
      await notifier.unfollowUser(1);
      await notifier.followUser(1);
      await notifier.unfollowUser(1);

      final users = container.read(usersToFollowViewmodelProvider).value!;

      expect(users[0].isFollowing, false);
      verify(() => mockRepo.followUser(1)).called(2);
      verify(() => mockRepo.unFollowUser(1)).called(2);
    });
  });
}