import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/password/password_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_data/user_data.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/user_name_screen/user_name_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/steps/verification_code/verification_code.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:lam7a/features/authentication/ui/widgets/next_button.dart';

class SignUpFlow extends StatefulWidget {
  static const String routeName = "sign_up_flow";

  @override
  State<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<SignUpFlow> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final signUpFlow = ref.watch(signUpFlowProvider);
        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        int currentIndex = state.currentSignupStep;
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (currentIndex != 0) {
              viewmodel.gotoPrevSignupStep();
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                FirstTimeScreen.routeName,
                (route) => false,
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: ImageIcon(AssetImage(AppAssets.xIcon)),
              leading: IconButton(
                onPressed: () {
                  if (currentIndex != 0)
                    viewmodel.gotoPrevLoginStep();
                  else
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      FirstTimeScreen.routeName,
                      (route) => false,
                    );
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                signUpFlow[currentIndex],
                Spacer(flex: 5,),
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ((signUpFlow[currentIndex] is ProfilePicture) || (signUpFlow[currentIndex] is UserNameScreen))
                            ? Expanded(
                              flex: 8,
                              child: NextButton(
                                  label: "skip for now",
                                  bgColor: Pallete.whiteColor,
                                  textColor: Pallete.blackColor,
                                  
                                  onPressedEffect: () {
                                    viewmodel.gotoNextSignupStep();
                                  },
                                ),
                            )
                            : Expanded(child: Container(), flex: 8,),
                            Spacer(flex: 8,),
                        Expanded(
                          flex: 5,
                          child: NextButton(
                            label: "Next",
                            onPressedEffect: () {
                              viewmodel.gotoNextSignupStep();
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
