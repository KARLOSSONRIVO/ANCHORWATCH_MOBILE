/// Application route constants
class AppRoutes {
  // Authentication routes
  static const String splash = '/';
  static const String login = '/login';
  
  // Main app routes
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // AnchorWatch specific routes (for future features)
  static const String anchorMap = '/anchor-map';
  static const String anchorHistory = '/anchor-history';
  static const String weather = '/weather';
  
  /// List of all available routes
  static const List<String> allRoutes = [
    splash,
    login,
    home,
    profile,
    settings,
    anchorMap,
    anchorHistory,
    weather,
  ];
  
  /// Protected routes that require authentication
  static const List<String> protectedRoutes = [
    home,
    profile,
    settings,
    anchorMap,
    anchorHistory,
    weather,
  ];
  
  /// Public routes accessible without authentication
  static const List<String> publicRoutes = [
    splash,
    login,
  ];
}