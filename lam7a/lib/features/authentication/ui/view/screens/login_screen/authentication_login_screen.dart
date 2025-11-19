import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

List<Widget> loginFlow = [UniqueIdentifier(), PasswordLogin()];

class LogInScreen extends StatefulWidget {
  static const String routeName = "login";

  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _loginFlowtate();
}

class _loginFlowtate extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ///////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
        ref.listen(authenticationProvider, (previous, next) {
          if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
            if (!context.mounted) return;
            // Navigate to transmission screen (after auth page) instead of directly to home
            Navigator.pushNamedAndRemoveUntil(
              context,
              AuthenticationTransmissionScreen.routeName,
              (route) => false,
            );
          }
        });
        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        final authenticationState = ref.watch(authenticationProvider);
        int currentIndex = state.currentLoginStep;
        ///////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
        // this pop scope is to preven the back gestures from the user and do what i want instead
        ///////////////////////////////////////////////////////////////////////////
        ///////////////////////////////////////////////////////////////////////////
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (currentIndex > 0) {
              viewmodel.gotoPrevLoginStep();
              return;
            }
            Navigator.pushReplacementNamed(context, FirstTimeScreen.routeName);
            viewmodel.goToHome();
          },
          canPop: false,
          child: Scaffold(
            appBar: AppBar(
              title: ImageIcon(AssetImage(AppAssets.xIcon)),
              leading: IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    FirstTimeScreen.routeName,
                  );
                  viewmodel.goToHome();
                },
                icon: Icon(Icons.close),
              ),
            ),
            body: !state.isLoadingLogin
                ? Column(
                    children: [
                      loginFlow[currentIndex],
                      Spacer(flex: 5),

                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Spacer(flex: 6),
                              Expanded(
                                flex: 2,
                                child: AuthenticationStepButton(
                                  key: ValueKey("loginNextButton"),
                                  enable: viewmodel.shouldEnableNextLogin(),
                                  label: AuthenticationConstants.loginButtonLabels[currentIndex],
                                  bgColor: Theme.of(context).colorScheme.onSurface,
                                  textColor: Theme.of(context).colorScheme.surface,
                                  onPressedEffect: () async{
                                    if (currentIndex == AuthenticationConstants.finishLogin) {
                                      await viewmodel.login();
                                      String? message = ref.read(authenticationViewmodelProvider).toastMessageLogin;
                                      if (message != null)
                                      {
                                        AuthenticationConstants.flushMessage(message, context, "loginMessage");
                                      }
                                      if (authenticationState.isAuthenticated) {
                                        Navigator.pop(context);
                                        // Navigate to transmission screen (after auth page)
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AuthenticationTransmissionScreen.routeName,
                                          (route) => false,
                                        );
                                      }
                                    } else if (viewmodel.shouldEnableNextLogin()){
                                      viewmodel.gotoNextLoginStep();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: LoadingCircle(),
                  ),
          ),
        );
      },
    );
  }
}
