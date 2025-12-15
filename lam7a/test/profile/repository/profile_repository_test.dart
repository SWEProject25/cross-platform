import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import '../helpers/fake_profile_api.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import 'package:lam7a/features/profile/dtos/profile_dto.dart';

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
}
