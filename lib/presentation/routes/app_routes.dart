class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPasswordEmail = '/reset-password/email';
  static const String resetPasswordOtp = '/reset-password/otp';
  static const String resetPasswordConfirm = '/reset-password/confirm';
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  static const String discover = '/discover';
  static const String anchorwise = '/anchorwise';
  static const String alerts = '/alerts';
  static const String profile = '/profile';
  static const String contact = '/contact';
  static const String contactSupport = '/contact-support';
  static const String faq = '/faq';
  static const String changePassword = '/change-password';
  static const String changeUsername = '/change-username';
  static const String requestChangeEmail = '/request-change-email';
  static const String confirmChangeEmail = '/confirm-change-email';
  static const String anchorHistory = '/anchor-history';
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
    contactSupport,
    faq,
    changePassword,
    changeUsername,
    requestChangeEmail,
    confirmChangeEmail,
    anchorHistory,
  ];
  static const List<String> protectedRoutes = [
    home,
    dashboard,
    discover,
    anchorwise,
    alerts,
    profile,
    contact,
    contactSupport,
    faq,
    changePassword,
    changeUsername,
    requestChangeEmail,
    confirmChangeEmail,
    anchorHistory
  ];
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
