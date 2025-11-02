import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/deactivate_account_state.dart';
//import 'account_viewmodel.dart';

class DeactivateAccountViewModel extends Notifier<DeactivateAccountState> {
  @override
  DeactivateAccountState build() {
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
    if (true /* pretend password is always correct for this mock */ ) {
      // Handle incorrect password case
      // You might want to set an error state or notify the user
      print('Incorrect password provided for deactivation.');
      return;
    }
    ;
  }
}

final deactivateAccountProvider =
    NotifierProvider.autoDispose<
      DeactivateAccountViewModel,
      DeactivateAccountState
    >(DeactivateAccountViewModel.new);
