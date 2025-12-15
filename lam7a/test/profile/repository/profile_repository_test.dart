import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import '../helpers/fake_profile_api.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';
import 'package:lam7a/core/models/user_model.dart';

void main() {
  test('getProfile maps ProfileDto to UserModel correctly', () async {
    final api = FakeProfileApiService()
      ..profile = ProfileDto(
        id: 1,
        userId: 1,
        name: 'Hossam',
        user: {'username': 'hossam'},
        followersCount: 10,
        followingCount: 5,
      );

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(api),
      ],
    );

    final repo = container.read(profileRepositoryProvider);
    final user = await repo.getProfile('hossam');

    expect(user.name, 'Hossam');
    expect(user.username, 'hossam');
    expect(user.followersCount, 10);
    expect(user.followingCount, 5);
  });

  test('getMyProfile maps dto correctly', () async {
    final api = FakeProfileApiService()
      ..myProfile = ProfileDto(
        id: 2,
        userId: 2,
        name: 'Me',
        user: {'username': 'me'},
      );

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(api),
      ],
    );

    final repo = container.read(profileRepositoryProvider);
    final user = await repo.getMyProfile();

    expect(user.username, 'me');
  });

  test('followUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.followUser(1);
    expect(api.followCalled, true);
  });

  test('unfollowUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.unfollowUser(1);
    expect(api.unfollowCalled, true);
  });

  test('muteUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.muteUser(1);
    expect(api.muteCalled, true);
  });

  test('blockUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.blockUser(1);
    expect(api.blockCalled, true);
  });


  test('updateMyProfile uploads avatar and banner when local paths provided', () async {
    final api = FakeProfileApiService()
      ..profile = ProfileDto(
        id: 1,
        userId: 1,
        name: 'Old',
        user: {'username': 'test'},
      );

    final repo = ProfileRepository(api);

    final updated = await repo.updateMyProfile(
      UserModel(id: 1, profileId: 1, name: 'New'),
      avatarPath: '/local/avatar.png',
      bannerPath: '/local/banner.png',
    );

    expect(updated.name, 'New');
  });

  test('updateMyProfile does not upload http urls', () async {
    final api = FakeProfileApiService()
      ..profile = ProfileDto(
        id: 1,
        userId: 1,
        name: 'Old',
        user: {'username': 'test'},
        profileImageUrl: 'http://existing/avatar.png',
        bannerImageUrl: 'http://existing/banner.png',
      );

    final repo = ProfileRepository(api);

    final updated = await repo.updateMyProfile(
      UserModel(
        id: 1,
        profileId: 1,
        name: 'Updated',
        profileImageUrl: 'http://existing/avatar.png',
        bannerImageUrl: 'http://existing/banner.png',
      ),
      avatarPath: 'http://existing/avatar.png',
      bannerPath: 'http://existing/banner.png',
    );

    expect(updated.profileImageUrl, 'http://existing/avatar.png');
    expect(updated.bannerImageUrl, 'http://existing/banner.png');
  });

  test('unmuteUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.unmuteUser(1);
    expect(api.unmuteCalled, true);
  });


  test('unblockUser calls api', () async {
    final api = FakeProfileApiService();
    final repo = ProfileRepository(api);

    await repo.unblockUser(1);
    expect(api.unblockCalled, true);
  });

  test('fromDto defaults states to false when flags missing', () async {
    final api = FakeProfileApiService()
      ..profile = ProfileDto.fromJson({
        'id': 1,
        'user_id': 1,
        'name': 'Test',
        'user': {'username': 'test'},
      });

    final container = ProviderContainer(
      overrides: [
        profileApiServiceProvider.overrideWithValue(api),
      ],
    );

    final repo = container.read(profileRepositoryProvider);
    final user = await repo.getProfile('test');

    expect(user.stateMute, ProfileStateOfMute.notmuted);
    expect(user.stateBlocked, ProfileStateBlocked.notblocked);
    expect(user.stateFollowingMe, ProfileStateFollowingMe.notfollowingme);
    expect(user.followersCount, 0);
    expect(user.followingCount, 0);
  });



}
