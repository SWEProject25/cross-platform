// coverage:ignore-file
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/navigation/utils/models/user_main_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'navigation_viewmodel.g.dart';

@riverpod
class NavigationViewModel extends _$NavigationViewModel {
  late final authController;
  late final authState;

  @override
  int build() {
    authController  = ref.read(authenticationProvider.notifier);
    authState = ref.read(authenticationProvider);
    return 0;
  }
  Future<bool> logoutButtonPressed() async {

    await authController.logout();
    return authState.isAuthenticated;
  } 
}