import 'package:flutter/material.dart';
import 'storage_service.dart';

/// Service for handling authentication operations
class AuthenticationService {
  /// Check if user is authenticated
  static bool isAuthenticated() {
    final token = StorageService.getString(StorageKeys.userToken);
    return token != null && token.isNotEmpty;
  }

  /// Get current user token
  static String? getUserToken() {
    return StorageService.getString(StorageKeys.userToken);
  }

  /// Store user authentication data
  static Future<bool> login({
    required String token,
    required String userId,
    required String email,
    String? name,
  }) async {
    try {
      await StorageService.setString(StorageKeys.userToken, token);
      await StorageService.setString(StorageKeys.userId, userId);
      await StorageService.setString(StorageKeys.userEmail, email);
      
      if (name != null) {
        await StorageService.setString(StorageKeys.userName, name);
      }
      
      return true;
    } catch (e) {
      debugPrint('AuthenticationService.login error: $e');
      return false;
    }
  }

  /// Clear user authentication data
  static Future<bool> logout() async {
    try {
      await StorageService.remove(StorageKeys.userToken);
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      
      return true;
    } catch (e) {
      debugPrint('AuthenticationService.logout error: $e');
      return false;
    }
  }

  /// Get current user ID
  static String? getUserId() {
    return StorageService.getString(StorageKeys.userId);
  }

  /// Get current user email
  static String? getUserEmail() {
    return StorageService.getString(StorageKeys.userEmail);
  }

  /// Get current user name
  static String? getUserName() {
    return StorageService.getString(StorageKeys.userName);
  }

  /// Update user profile information
  static Future<bool> updateUserProfile({
    String? name,
    String? email,
  }) async {
    try {
      if (name != null) {
        await StorageService.setString(StorageKeys.userName, name);
      }
      
      if (email != null) {
        await StorageService.setString(StorageKeys.userEmail, email);
      }
      
      return true;
    } catch (e) {
      debugPrint('AuthenticationService.updateUserProfile error: $e');
      return false;
    }
  }

  /// Validate token format (basic validation)
  static bool isValidToken(String token) {
    // Add your token validation logic here
    // This is a basic example - adjust according to your token format
    return token.isNotEmpty && token.length > 10;
  }

  /// Check if user session is valid (could include expiry check)
  static bool isSessionValid() {
    final token = getUserToken();
    if (token == null) return false;
    
    // Add session expiry logic here if needed
    // For now, just check if token exists and is valid format
    return isValidToken(token);
  }

  /// Get authentication headers for API calls
  static Map<String, String> getAuthHeaders() {
    final token = getUserToken();
    if (token == null) return {};
    
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}