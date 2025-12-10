import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/providers/authentication.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/view/screens/first_time_screen/authentication_first_time_screen.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/reset_password.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/steps/email_sent.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/steps/enter_email_to_send_code.dart';
import 'package:lam7a/features/authentication/ui/view/screens/forgot_password/steps/verify_email.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/password_login_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/steps/unique_identifier_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/transmissionScreen/authentication_transmission_screen.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/forgot_password_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_step_button.dart';
import 'package:lam7a/features/authentication/ui/widgets/loading_circle.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:lam7a/features/navigation/ui/view/navigation_home_screen.dart';

const List<Widget> forgotPasswordFlow = [
  EnterEmailToSendCode(),
  VerifyEmail(),
  EmailSent(),
];

class ForgotPasswordScreen extends StatefulWidget {
  static const String routeName = "forgot_password";

  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    return Consumer(
      builder: (context, ref, child) {
        int currentStep = ref
            .watch(forgotPasswordViewmodelProvider)
            .currentForgotPasswordStep;
        int safeStep = currentStep.clamp(0, forgotPasswordFlow.length - 1);

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
        return PopScope(
          onPopInvokedWithResult: (didPop, result) {
            Navigator.pushReplacementNamed(context, FirstTimeScreen.routeName);
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
                },
                icon: Icon(Icons.close),
              ),
            ),
            body: !isLoading
                ? Column(
                    key: ValueKey("mainLoginView"),
                    children: [
                      forgotPasswordFlow[safeStep],
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
                                  key: ValueKey("forgot_password_next_button"),
                                  enable: true,
                                  label: "Next",
                                  bgColor: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  textColor: Theme.of(
                                    context,
                                  ).colorScheme.surface,
                                  onPressedEffect: () async {
                                    if (safeStep < 2) {
                                      if (safeStep == 1) {
                                        isLoading = true;
                                        await ref
                                            .read(
                                              forgotPasswordViewmodelProvider
                                                  .notifier,
                                            )
                                            .isInstructionSent(
                                              ref
                                                  .read(
                                                    forgotPasswordViewmodelProvider,
                                                  )
                                                  .email,
                                            );
                                      }
                                      else
                                      {
                                        ref.read(forgotPasswordViewmodelProvider
                                                  .notifier).gotoNextStep();
                                      }
                                      isLoading = false;
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        ResetPassword.routeName,
                                      );
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
                : Center(child: LoadingCircle()),
          ),
        );
      },
    );
  }
}
