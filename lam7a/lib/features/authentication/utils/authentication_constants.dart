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
  static const String oAuthWithGoogleText = "Continue with google account";
  static const String oAuthWithGithubText = "Continue with github account";
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
}
