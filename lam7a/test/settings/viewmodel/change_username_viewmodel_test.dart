import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lam7a/features/settings/ui/viewmodel/change_username_viewmodel.dart';
import 'package:lam7a/features/settings/ui/viewmodel/account_viewmodel.dart';
import 'package:lam7a/core/models/user_model.dart';

class FakeAccountViewModel extends AccountViewModel {
  late UserModel _state = UserModel(
    username: 'old_user',
    email: 'test@mail.com',
    role: '',
    name: '',
    birthDate: '',
    profileImageUrl: '',
    bannerImageUrl: '',
    bio: '',
    location: '',
    website: '',
    createdAt: '',
  );

  @override
  UserModel build() => _state;

  @override
  Future<void> changeUsername(String newUsername) async {
    _state = _state.copyWith(username: newUsername);
  }
}

void main() {
  late ProviderContainer container;
  late FakeAccountViewModel fakeAccount;
  late ChangeUsernameViewModel viewmodel;

  setUp(() {
    fakeAccount = FakeAccountViewModel();

    container = ProviderContainer(
      overrides: [accountProvider.overrideWith(() => fakeAccount)],
    );

    viewmodel = container.read(changeUsernameProvider.notifier);
  });

  test('initial state loads old username', () {
    final state = container.read(changeUsernameProvider);
    expect(state.currentUsername, 'old_user');
    expect(state.newUsername, '');
    expect(state.isValid, false);
    expect(state.isLoading, false);
  });

  test('updateUsername validates correctly', () {
    viewmodel.updateUsername('new_name');
    final state = container.read(changeUsernameProvider);

    expect(state.newUsername, 'new_name');
    expect(state.isValid, true);
  });

  test('saveUsername updates account + resets state', () async {
    viewmodel.updateUsername('updated_user');

    await viewmodel.saveUsername();

    final state = container.read(changeUsernameProvider);

    expect(state.currentUsername, 'updated_user'); // updated
    expect(fakeAccount.build().username, 'updated_user'); // provider updated
    expect(state.newUsername, ''); // reset
    expect(state.isValid, false);
    expect(state.isLoading, false);
  });
}
