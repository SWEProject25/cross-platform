import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:lam7a/features/profile/services/profile_api_service.dart';
import '../helpers/profile_test_helpers.dart';

class MockProfileApiService extends Mock implements ProfileApiService {}

void main() {
  late MockProfileApiService api;
  late ProfileRepository repo;

  setUp(() {
    api = MockProfileApiService();
    repo = ProfileRepository(api);
  });

  test('getProfile returns ProfileModel from DTO', () async {
    final dto = makeTestDto();

    when(() => api.getProfileByUsername("hossam.ho8814"))
        .thenAnswer((_) async => dto);

    final model = await repo.getProfile("hossam.ho8814");

    expect(model.displayName, "hossam mohamed");
    expect(model.handle, "hossam.ho8814");
    expect(model.followersCount, 3);
  });

  test('updateMyProfile uploads avatar & banner when needed', () async {
    final dto = makeTestDto();

    when(() => api.uploadProfilePicture(any()))
        .thenAnswer((_) async => "https://cdn/avatar.jpg");

    when(() => api.uploadBanner(any()))
        .thenAnswer((_) async => "https://cdn/banner.jpg");

    when(() => api.updateMyProfile(any())).thenAnswer((_) async => dto);

    final example = makeTestModel();

    final result = await repo.updateMyProfile(
      example,
      avatarPath: "/local/avatar.png",
      bannerPath: "/local/banner.png",
    );

    verify(() => api.uploadProfilePicture("/local/avatar.png")).called(1);
    verify(() => api.uploadBanner("/local/banner.png")).called(1);

    expect(result.avatarImage, "https://cdn/avatar.jpg");
    expect(result.bannerImage, "https://cdn/banner.jpg");
  });
}
