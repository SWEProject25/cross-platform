import 'package:flutter/material.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_otp_code_Step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_password_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/authentication_signup_user_data_step.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/profile_picture/profile_picture.dart';
import 'package:lam7a/features/authentication/ui/view/screens/signup_flow_screen/steps/user_name_screen/user_name_screen.dart';

const int userData = 0;
const int OTPCode = 1;
const int passwordScreen = 2;
const List<String> nextLabels = ["Next", "Next", "Sign up", "Next", "Next"];
const String firstTimeScreenText = "See What's happening in the world right now";
const String oAuthWithGoogleText = "Continue with google account";
const String oAuthWithGithubText = "Continue with github account";
const String userDataHeaderText = "Create Your Account";
const String passwordSignupHeaderText = "You'll need a password";
const String passwordSignupInstructionsText =
    "make sure it's 8 characters and has at least 1 capital letter, 1 small letter, 1 number , 1 special character";
const String otpCodeHeaderText = "We sent you a code";
const String otpCodeDesText = "Enter it below to verify emai@example.com";
const String otpCodeResendText = "Didn't recieve an email?";
