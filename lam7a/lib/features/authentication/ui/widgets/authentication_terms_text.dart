import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Spacer(flex: 1),
        Expanded(
          flex: 12,
          child: RichText(
            text: TextSpan(
              style: TextStyle(color: Pallete.subtitleText),
              children: [
                TextSpan(text: "By signing up you agree to our"),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Terms",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(text: ", "),
                 WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Privacy Policy",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(text: " and "),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Cookies use",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(text: "."),
              ],
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }
}
