import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/forgot_password_screen.dart';
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
              title: SvgPicture.asset(
                AppAssets.xIcon,
                width: 32,
                height: 32,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
              // replaces currentCo),
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
                    key: ValueKey("mainLoginView"),
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
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        AuthenticationStepButton(
                                          label: "forgot password",
                                          onPressedEffect: () {
                                            Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                                          },
                                          bgColor: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          textColor: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          enable: true,
                                        ),
                                        SizedBox(width: 120,),
                                        AuthenticationStepButton(
                                          key: ValueKey("loginNextButton"),
                                          enable: viewmodel.shouldEnableNextLogin(),
                                          label: AuthenticationConstants
                                              .loginButtonLabels[currentIndex],
                                          bgColor: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          textColor: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                          onPressedEffect: () async {
                                            if (currentIndex ==
                                                AuthenticationConstants
                                                    .finishLogin) {
                                              await viewmodel.login();
                                              String? message = ref
                                                  .watch(
                                                    authenticationViewmodelProvider,
                                                  )
                                                  .toastMessageLogin;
                                              final updateState = ref.read(
                                                authenticationViewmodelProvider,
                                              );
                                    
                                              if (message != null) {
                                                AuthenticationConstants.flushMessage(
                                                  message,
                                                  context,
                                                  "loginMessage",
                                                );
                                              }
                                              final authenticationState = ref.read(
                                                authenticationProvider,
                                              );
                                              if (authenticationState
                                                  .isAuthenticated) {
                                                if (updateState
                                                        .hasCompeletedFollowing &&
                                                    updateState
                                                        .hasCompeletedInterests) {
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    NavigationHomeScreen.routeName,
                                                    (route) => false,
                                                  );
                                                } else {
                                                  Navigator.pushNamedAndRemoveUntil(
                                                    context,
                                                    AuthenticationTransmissionScreen
                                                        .routeName,
                                                    (route) => false,
                                                  );
                                                }
                                              }
                                            } else if (viewmodel
                                                .shouldEnableNextLogin()) {
                                              viewmodel.gotoNextLoginStep();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(child: LoadingCircle(key: ValueKey("loadingLogin"))),
          ),
        );
      },
    );
  }
}
