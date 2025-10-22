import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/log_in_nav.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';

class LogInScreen extends StatefulWidget {
  static const String routeName = "login";

  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        final loginScreens = ref.watch(loginFlowProvider);
        int currentIndex = state.currentLoginStep;
        // this pop scope is to preven the back gestures from the user and do what i want instead 
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
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
            body: !state.isLoadingLogin ? Column(
              children: [
                loginScreens[currentIndex],
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
                            label: "Next",
                            onPressedEffect: () {
                              if (currentIndex == 1)
                              {
                                viewmodel.login();
                              }
                              else
                              viewmodel.gotoNextLoginStep();
                              
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ) : Center(child: CircularProgressIndicator(color: Pallete.blackColor,)),
          ),
        );
      },
    );
  }
}
