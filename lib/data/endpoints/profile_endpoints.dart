/// Profile related API endpoints
class ProfileEndpoints {
  // Base paths
  static const String _accounts = '/accounts';
  
  // Change password endpoint
  static const String changePassword = '$_accounts/change-password/';
  
  // Change username endpoint
  static const String changeUsername = '$_accounts/change-username/';
  
  // Change email endpoints
  static const String requestChangeEmail = '$_accounts/request-change/';
  static const String confirmChangeEmail = '$_accounts/confirm-change/';
}