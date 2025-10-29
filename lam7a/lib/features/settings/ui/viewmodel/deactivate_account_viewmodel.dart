import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/deactivate_account_state.dart';
import 'account_viewmodel.dart';

class DeactivateAccountViewModel extends Notifier<DeactivateAccountState> {
  late final String currentPassword;
  @override
  DeactivateAccountState build() {
    currentPassword = ref.read(accountProvider).password;
    return const DeactivateAccountState();
  }

  void goToConfirmPage() {
    state = state.copyWith(currentPage: DeactivateAccountPage.confirm);
  }

  void goToMainPage() {
    state = state.copyWith(currentPage: DeactivateAccountPage.main);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void deactivateAccount() {
    if (state.password != currentPassword) {
      // Handle incorrect password case
      // You might want to set an error state or notify the user
      print('Incorrect password provided for deactivation.');
      return;
    }
    // TODO: implement real deactivation logic here (API call, etc.)
    print('Deactivating account with password: ${state.password}');
  }
}

final deactivateAccountProvider =
    NotifierProvider.autoDispose<
      DeactivateAccountViewModel,
      DeactivateAccountState
    >(DeactivateAccountViewModel.new);
