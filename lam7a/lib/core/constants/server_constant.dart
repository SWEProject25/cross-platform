
class ServerConstant {
  static String serverURL =
      Platform.isAndroid ? 'http://10.0.2.2:8000' : 'http://127.0.0.1:8000';
    static String domain = "http://localhost:5000/api/v1.0";
    static String registrationEndPoint = "/auth/register";
    static String checkEmailEndPoint = "/auth/check-email";
    static String verificationOTP = "/auth/verification-otp";
    static String verifyOTP = "/auth/verify-otp";
    static String resendOTP = "/auth/resend-otp";
    static String login = "/auth/login";
    static String logout = "/auth/logout";
    static String refreshToken = "/auth/refresh-token";
    static String  forgotPassword = "/auth/forgot-password";
    static String resetPassword = "/auth/reset-password";
  static String serverURL = "http://backend-code.duckdns.org/dev";
}
