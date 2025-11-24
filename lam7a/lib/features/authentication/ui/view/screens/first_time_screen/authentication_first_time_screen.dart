import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_icon_button_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_login_text.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_terms_text.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/authentication_signup_flow_screen.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';

// first =_time_screen is the screen that appears
//to the user if he opens the application without logging in
class FirstTimeScreen extends StatelessWidget {
  static const String routeName = "first_time_screen";
  const FirstTimeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey("firstScreen"),
      appBar: AppBar(title: ImageIcon(AssetImage(AppAssets.xIcon))),
      body: Consumer(
        builder: (context, ref, child) {
          final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
          return Column(
            children: [
              Spacer(flex: 2),
              Expanded(
                flex: 4,
                //this is the container of the greeting text for the first time opening the application
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 8,
                        child: Text(
                          AuthenticationConstants.firstTimeScreenText,
                          style: GoogleFonts.outfit(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                ),
              ),

              // this part concerns in authentication navigation for registration and login and oAuth
              Column(
                children: [
                  IconedButtonCentered(
                    key: Key("googleOAuthButton"),
                    buttonLabel: AuthenticationConstants.oAuthWithGoogleText,
                    imgPath: AppAssets.googleIcon,
                    backGroundColor: Pallete.whiteColor,
                    textColor: Pallete.blackColor,
                    isBorder: true,
                  ),
                  IconedButtonCentered(
                    key: Key("githubOAuthButton"),
                    buttonLabel: AuthenticationConstants.oAuthWithGithubText,
                    imgPath: AppAssets.githubIcon,
                    backGroundColor: Pallete.whiteColor,
                    textColor: Pallete.blackColor,
                    isBorder: true,
                  ),
                  const Row(
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 2,
                        child: Divider(
                          color: Pallete.inactiveBottomBarItemColor,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "or",
                          style: TextStyle(color: Pallete.subtitleText),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Divider(
                          color: Pallete.subtitleText,
                          thickness: 1,
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                  IconedButtonCentered(
                    key: Key("createAccountButton"),
                    buttonLabel: "Create account",
                    backGroundColor: Theme.of(context).colorScheme.onSurface,
                    textColor: Theme.of(context).colorScheme.surface,
                    pressEffect: () {
                      Navigator.pushNamed(context, SignUpFlow.routeName);
                      viewmodel.changeToSignup();
                    },
                  ),
                ],
              ),
              SizedBox(height: 15),
              TermsText(),
              Spacer(flex: 1),
              LoginText(
                // this is the has the login text that moves the user to the log in steps
                onPress: () {
                  viewmodel.changeToLogin();
                },
              ),
              Spacer(flex: 1),
            ],
          );
        },
      ),
    );
  }
}
