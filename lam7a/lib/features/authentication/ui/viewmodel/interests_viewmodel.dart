import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interests_viewmodel.g.dart';

@riverpod
class InterestsViewModel extends _$InterestsViewModel {
  Future<List<InterestDto>> build() async {
    final repo = ref.read(authenticationImplRepositoryProvider);
    return await repo.getInterests();
  }

  Future<void> selectInterests(List<int> interestIds) async {
    final repo = ref.read(authenticationImplRepositoryProvider);

    await repo.selectInterests(interestIds);
  }
}
