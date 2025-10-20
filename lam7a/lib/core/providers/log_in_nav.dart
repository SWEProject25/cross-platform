import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login/password_login.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier/unique_identifier.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/password/password_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_data/user_data.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_name_screen/user_name_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/verification_code/verification_code.dart';

Provider<List<Widget>> logInNavProvider = Provider<List<Widget>>((ref) {
  return [
    UniqueIdentifier(),
    PasswordLogin(),
  ];
});

class CurrentIndexLogInNotifier extends StateNotifier<int> {
  CurrentIndexLogInNotifier(super.state);
  static const int maxIndex = 1;

  void goToHome()
  {
    state = 0;
  }
  void goToNext() {
    if (state < maxIndex) state++;
  }

  void goToPrevious() {
    if (state > 0) {
      state--;
    }
  }

  @override
  int build() {
    return 0;
  }
}

StateNotifierProvider<CurrentIndexLogInNotifier, int> currentLogInStepProvider =
    StateNotifierProvider<CurrentIndexLogInNotifier, int>(
  (ref) => CurrentIndexLogInNotifier(0),
);
