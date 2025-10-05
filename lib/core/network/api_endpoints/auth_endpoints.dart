/// Authentication related API endpoints
class AuthEndpoints {
  // Base paths
  static const String _auth = '/accounts';
  
  // Authentication endpoints
  static const String login = '$_auth/login/';
  static const String register = '$_auth/register/';
  static const String logout = '$_auth/logout/';
  
  // User profile endpoints
  static const String profile = '$_auth/user/';

}