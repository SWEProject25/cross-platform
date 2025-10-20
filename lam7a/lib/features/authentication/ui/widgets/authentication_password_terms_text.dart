import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lam7a/core/theme/app_pallete.dart';

class PasswordTermsText extends StatelessWidget {
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
                TextSpan(text: "By signing up, you agree to the "),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Terms of services",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(text: "and "),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Privacy Policy",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(text: " including "),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Cookies use",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(
                  text:
                      "X may use your contact information, including your email address and phone number for purposes outlined in our Privacy Policy, such as keeping your account secure and personalising our services, including ads. ",
                ),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " Learn more",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
                TextSpan(
                  text:
                      " Others will be able to find you by email address or phone number, when provided, unless you choose otherwise.",
                ),
                WidgetSpan(
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      " here",
                      style: TextStyle(color: Pallete.linkColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Spacer(flex: 1),
      ],
    );
  }
}
