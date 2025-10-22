import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier_step.dart';

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
