


import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/navigation/utils/models/userMainData.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'navigation_viewmodel.g.dart';

@riverpod
class NavigationViewModel extends _$NavigationViewModel {
  @override
  int build() {
    return 0;
  }
  Future<bool> logoutButtonPressed() async {
    final authController  = ref.watch(authenticationProvider.notifier);
    final authState = ref.watch(authenticationProvider);
    await authController.logout();
    return authState.isAuthenticated;
  }
  Usermaindata getUserMainData() {
    final authState = ref.watch(authenticationProvider);
    Usermaindata userData = Usermaindata();
    userData.name = authState.user?.name;
    userData.userName = authState.user?.username;
    userData.profileImageUrl = authState.user?.profileImageUrl;
    return userData;
  }

}