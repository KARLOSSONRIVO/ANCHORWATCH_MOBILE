/// Authentication related API endpoints
class AuthEndpoints {
  // Base paths
  static const String _auth = '/accounts';
  
  // Authentication endpoints
  static const String login = '$_auth/login/';
  static const String register = '$_auth/register/';
  static const String logout = '$_auth/logout/';
  static const String refreshToken = '$_auth/token/refresh/';
  static const String forgotPassword = '$_auth/password/reset/';
  static const String resetPassword = '$_auth/password/reset/confirm/';
  static const String changePassword = '$_auth/password/change/';
  static const String verifyEmail = '$_auth/verify-email/';
  static const String resendVerification = '$_auth/resend-verification/';
  
  // User profile endpoints
  static const String profile = '$_auth/profile/';
  static const String updateProfile = '$_auth/profile/update/';
  static const String deleteAccount = '$_auth/profile/delete/';
}