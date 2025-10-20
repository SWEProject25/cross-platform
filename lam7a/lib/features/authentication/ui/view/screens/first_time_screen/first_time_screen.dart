import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/authentication_viewmodel.dart';
import 'package:lam7a/features/authentication/ui/widgets/icon_button_widget.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_login_text.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_terms_text.dart';
import 'package:lam7a/features/authentication/ui/view/screens/sign_up_flow_screen/sign_up_flow_screen.dart';

class FirstTimeScreen extends StatelessWidget {
  static const String routeName = "first_time_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: ImageIcon(AssetImage(AppAssets.xIcon))),
      body: Consumer(
        builder: (context, ref, child){ 
          final viewmodel = ref.watch(authenticationViewmodelProvider.notifier);
          return Column(
          children: [
            Spacer(flex: 2),
            Expanded(
              flex: 4,
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(flex: 1),
                    Expanded(
                      flex: 8,
                      child: Text(
                        "See What's happening in the world right now",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Pallete.blackColor,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                  ],
                ),
                // width: 50,
              ),
            ),
        
            Column(
              children: [
                IconedButtonCentered(
                  buttonLabel: "Continue with google account",
                  imgPath: AppAssets.googleIcon,
                  backGroundColor: Pallete.whiteColor,
                  textColor: Pallete.blackColor,
                ),
                IconedButtonCentered(
                  buttonLabel: "Continue with github account",
                  imgPath: AppAssets.githubIcon,
                  backGroundColor: Pallete.whiteColor,
                  textColor: Pallete.blackColor,
                ),
                Row(
                  children: [
                    Spacer(flex: 1),
                    Expanded(
                      child: Divider(
                        color: Pallete.inactiveBottomBarItemColor,
                        thickness: 1,
                      ),
                      flex: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "or",
                        style: TextStyle(color: Pallete.subtitleText),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Pallete.subtitleText, thickness: 1),
                      flex: 2,
                    ),
                    Spacer(flex: 1),
                  ],
                ),
                IconedButtonCentered(
                  buttonLabel: "Create account",
                  backGroundColor: Pallete.blackColor,
                  textColor: Pallete.whiteColor,
                  pressEffect: (){Navigator.pushNamed(context, SignUpFlow.routeName); viewmodel.changeToSignup();},
                ),
              ],
            ),
            SizedBox(height: 15),
            TermsText(),
            Spacer(flex: 1),
            LoginText(
              onPress: (){
                viewmodel.changeToLogin();
              },
            ),
            Spacer(flex: 1),
          ],
        );
        }
      ),
    );
  }
}
