import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/providers/log_in_nav.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/sign_up_flow_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';

class LogInScreen extends StatelessWidget {
  static const String routeName = "login";
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        final loginScreens = ref.watch(loginFlowProvider);
        int currentIndex = state.currentLoginStep;
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            Navigator.pushReplacementNamed(context, FirstTimeScreen.routeName);
            viewmodel.goToHome();
            print(state.identifier);
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
            body: Column(
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
                          child: NextButton(
                            label: "Next",
                            onPressedEffect: () {
                              viewmodel.gotoNextLoginStep();
                              
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
