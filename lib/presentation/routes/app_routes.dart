/// Application route constants
class AppRoutes {
  // App flow routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  
  // Password reset routes
  static const String resetPasswordEmail = '/reset-password/email';
  static const String resetPasswordOtp = '/reset-password/otp';
  static const String resetPasswordConfirm = '/reset-password/confirm';
  
  // Main app routes
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String discover = '/discover';
  static const String anchorwise = '/anchorwise';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  
  // Support and help routes
  static const String contact = '/contact';
  static const String faq = '/faq';
  
  // Profile management routes
  static const String changePassword = '/change-password';
  static const String changeUsername = '/change-username';
  
  // AnchorWatch specific routes (for future features)
  static const String anchorHistory = '/anchor-history';

  
  /// List of all available routes
  static const List<String> allRoutes = [
    splash,
    onboarding,
    login,
    signup,
    resetPasswordEmail,
    resetPasswordOtp,
    resetPasswordConfirm,
    home,
    dashboard,
    discover,
    anchorwise,
    alerts,
    profile,
    contact,
    faq,
    changePassword,
    changeUsername,
    anchorHistory,
  ];
  
  /// Protected routes that require authentication
  static const List<String> protectedRoutes = [
    home,
    dashboard,
    discover,
    anchorwise,
    alerts,
    profile,
    contact,
    faq,
    changePassword,
    changeUsername,
    anchorHistory
  ];
  
  /// Public routes accessible without authentication
  static const List<String> publicRoutes = [
    splash,
    onboarding,
    login,
    signup,
    resetPasswordEmail,
    resetPasswordOtp,
    resetPasswordConfirm,
  ];
}