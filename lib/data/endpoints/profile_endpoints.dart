/// Profile related API endpoints
class ProfileEndpoints {
  // Base paths
  static const String _accounts = '/accounts';
  
  // Change password endpoint
  static const String changePassword = '$_accounts/change-password/';
  
  // Change username endpoint
  static const String changeUsername = '$_accounts/change-username/';
  
  // Profile picture endpoints
  static const String generateProfileUploadURL = '$_accounts/upload-url/';
  static const String confirmProfileImage = '$_accounts/confirm/';
}