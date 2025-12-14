import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/core/utils/app_assets.dart';

class AuthenticationConstants {
  static const int userData = 0;
  static const int finishLogin = 1;
  static const int OTPCode = 1;
  static const int passwordScreen = 2;
  static const int transisionScreen = 3;
  static const List<String> nextLabels = [
    "Next",
    "Next",
    "Sign up",
    "Next",
    "Continue",
  ];
  static const List<String> loginButtonLabels = ["Next", "Login"];
  static const String firstTimeScreenText =
      "See What's happening in the world right now";
  static const String oAuthWithGoogleText = "Continue with google";
  static const String oAuthWithGithubText = "Continue with github";
  static const String userDataHeaderText = "Create Your Account";
  static const String passwordSignupHeaderText = "You'll need a password";
  static const String passwordSignupInstructionsText =
      "make sure it's 8 characters and has at least 1 capital letter, 1 small letter, 1 number , 1 special character";
  static const String otpCodeHeaderText = "We sent you a code";
  static const String otpCodeDesText =
      "Enter it below to verify emai@example.com";
  static const String otpCodeResendText = "Didn't recieve an email?";
  static const String message = 'message';
  static const String emailExist = 'Email is available';
  static const String faild = 'fail';
  static const String token = 'email';
  static const String success = 'success';
  static const String status = 'status';
  static const String errorEmailMessage = "this email is already taken";
  static const String otpSentMessage = "the code is sent to your account";
  static const String wrongOtpMessage = "the code is wrong";

  static void flushMessage(
    String message,
    BuildContext context,
    String key,
  ) async {
    await Flushbar(
      key: ValueKey(key),
      messageText: Text(
        textAlign: TextAlign.center,
        message,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onTertiary,
          letterSpacing: 0.3,
          height: 1.4,
          fontFamily: 'Inter', // or GoogleFonts.inter()
        ),
      ),
      padding: EdgeInsets.all(10),
      maxWidth: 200,

      duration: Duration(seconds: 1),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: EdgeInsets.only(right: 50, left: 50, bottom: 250),
      borderRadius: BorderRadius.circular(25),
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: SvgPicture.asset(
        AppAssets.xIcon,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
        // replaces currentCo
      ),
      boxShadows: [
        BoxShadow(
          color: Color(0x04000000), // ~2.5% black
          offset: Offset(0, 6),
          blurRadius: 15,
          spreadRadius: 4,
        ),
        BoxShadow(
          color: Color(0x0A000000), // ~4% black
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 4,
        ),
      ],
    ).show(context);
  }
}
