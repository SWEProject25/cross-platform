import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/view/screens/login_screen/log_in.dart';

class LoginText extends StatelessWidget {
  Function onPress;
  LoginText({required this.onPress});
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
                TextSpan(text: "Have an account already?"),
                WidgetSpan(
                  child: InkWell(
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
