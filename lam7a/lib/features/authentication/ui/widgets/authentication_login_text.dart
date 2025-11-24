import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/authentication_login_screen.dart';

class LoginText extends StatelessWidget {
  Function onPress;
  LoginText({super.key, required this.onPress});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(flex: 1),
        Expanded(
          flex: 9,
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Pallete.subtitleText),
              children: [
                TextSpan(text: "Have an account already? "),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: InkWell(
                    key: ValueKey("loginButton"),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        LogInScreen.routeName,
                      );
                      onPress();
                    },
                    child: Text(
                      "Log in",

                      style: TextStyle(
                        color: Pallete.linkColor,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                        decorationColor: Pallete.linkColor
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
