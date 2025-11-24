import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/profile/ui/viewmodel/profile_viewmodel.dart';
import 'package:lam7a/features/profile/repository/profile_repository.dart';
import 'package:riverpod/riverpod.dart';
import '../helpers/profile_test_helpers.dart';
import 'package:lam7a/features/profile/model/profile_model.dart';

class FakeRepo implements ProfileRepository {
  final model = makeTestModel();

  @override
  Future<ProfileModel> getProfile(String username) async => model;

  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('profileViewModel returns expected ProfileModel', () async {
    final container = ProviderContainer(
      overrides: [
        profileRepositoryProvider.overrideWithValue(FakeRepo()),
      ],
    );

    final result =
        await container.read(profileViewModelProvider("hossam").future);

    expect(result.displayName, "hossam mohamed");
    expect(result.handle, "hossam.ho8814");

    container.dispose();
  });
}
