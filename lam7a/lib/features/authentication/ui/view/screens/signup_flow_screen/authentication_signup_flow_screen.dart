import 'package:flutter/material.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_password_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_user_data_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/user_name_screen/user_name_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_otp_code_Step.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

final List<Widget> signupFlowSteps = [
  UserDataSignUp(),
  VerificationCode(),
  PasswordScreen(),
  ProfilePicture(),
  UserNameScreen(),
];

class SignUpFlow extends StatefulWidget {
  static const String routeName = "sign_up_flow";

  const SignUpFlow({super.key});

  @override
  State<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends State<SignUpFlow> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        ref.listen(authenticationProvider, (previous, next) {
          if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
            if (!context.mounted) return;
            Navigator.pushReplacementNamed(
              context,
              AuthenticationTransmissionScreen.routeName,
            );
          }
        });

        final state = ref.watch(authenticationViewmodelProvider);
        final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
        final authenticationState = ref.watch(authenticationProvider);
        final authenticationController = ref.watch(
          authenticationProvider.notifier,
        );
        int currentIndex = state.currentSignupStep;
        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
        // pop scope to prevent pop screen on back gestures
        /////////////////////////////////////////////////////////////////
        /////////////////////////////////////////////////////////////////
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
            key: ValueKey("signUpScreen"),
            appBar: AppBar(
              title: const ImageIcon(AssetImage(AppAssets.xIcon)),
              // taping on back button
              leading: IconButton(
                onPressed: () {
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
                icon: Icon(Icons.arrow_back),
              ),
            ),
            // the main screen that has the sign up steps
            body: !state.isLoadingSignup && !state.isLoadingLogin
                ? Column(
                    children: [
                      signupFlowSteps[currentIndex],
                      Spacer(flex: 5),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ((signupFlowSteps[currentIndex]
                                          is ProfilePicture) ||
                                      (signupFlowSteps[currentIndex]
                                          is UserNameScreen))
                                  ? Expanded(
                                      flex: 8,
                                      child: AuthenticationStepButton(
                                        label: "skip for now",
                                        bgColor: Pallete.whiteColor,
                                        textColor: Pallete.blackColor,
                                        onPressedEffect: () {
                                          viewmodel.gotoNextSignupStep();
                                        },
                                      ),
                                    )
                                  : Expanded(flex: 8, child: Container()),
                              Spacer(flex: 8),
                              Expanded(
                                flex: 6,
                                child: AuthenticationStepButton(
                                  key: ValueKey("nextSignupStepButton"),
                                  enable: viewmodel.shouldEnableNext(),
                                  label: AuthenticationConstants.nextLabels[currentIndex],
                                  onPressedEffect: () async {
                                    if (viewmodel.shouldEnableNext()) {
                                      await viewmodel.registrationProgress();
                                      String? message = ref.read(authenticationViewmodelProvider).toastMessage;
                                      if (message != null)
                                      {
                                          AuthenticationConstants.flushMessage(message, context, "signupMessage");
                                          ref.read(authenticationViewmodelProvider.notifier).clearMessage();
                                      }
                                      if (authenticationState.isAuthenticated)
                                      {
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(context, AuthenticationTransmissionScreen.routeName, (route) => false);
                                      }
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
                    child: CircularProgressIndicator(
                      backgroundColor: Pallete.transparentColor,
                      color: Pallete.blackColor,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
