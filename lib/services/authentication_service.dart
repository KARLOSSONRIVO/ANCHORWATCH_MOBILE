import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import '../domain/entities/auth_result.dart';
import 'token_storage_service.dart';
import 'storage_service.dart';

/// Service for handling authentication operations with JWT tokens
@lazySingleton
class AuthenticationService {
  final TokenStorageService _tokenStorage;
  
  AuthenticationService(this._tokenStorage);

  /// Check if user is authenticated by validating stored tokens
  Future<bool> isAuthenticated() async {
    final hasValidTokens = _tokenStorage.hasValidTokens();
    
    // If tokens are invalid/expired, clear them
    if (!hasValidTokens) {
      await _tokenStorage.clearTokens();
      // Clear any stored user data as well
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
    }
    
    return hasValidTokens;
  }

  /// Get current access token
  String? getAccessToken() {
    return _tokenStorage.getAccessToken();
  }

  /// Get current refresh token
  String? getRefreshToken() {
    return _tokenStorage.getRefreshToken();
  }

  /// Store authentication result after successful login
  Future<bool> storeAuthResult(AuthResult authResult) async {
    try {
      // Store tokens
      final tokensStored = await _tokenStorage.saveTokens(authResult.tokens);
      
      if (tokensStored) {
        // Store user information
        await StorageService.setString(StorageKeys.userId, authResult.user.id);
        await StorageService.setString(StorageKeys.userEmail, authResult.user.email);
        await StorageService.setString(StorageKeys.userName, authResult.user.username);
      }
      
      return tokensStored;
    } catch (e) {
      debugPrint('AuthenticationService.storeAuthResult error: $e');
      return false;
    }
  }

  /// Clear all authentication data (logout)
  Future<bool> logout() async {
    try {
      // Clear tokens
      final tokensCleared = await _tokenStorage.clearTokens();
      
      // Clear only authentication-related data, preserve onboarding status
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      await StorageService.remove(StorageKeys.userToken);
      
      debugPrint('AuthenticationService: Logout completed - authentication data cleared');
      return tokensCleared;
    } catch (e) {
      debugPrint('AuthenticationService.logout error: $e');
      return false;
    }
  }

  /// Get current user ID
  String? getUserId() {
    return StorageService.getString(StorageKeys.userId);
  }

  /// Get current user email
  String? getUserEmail() {
    return StorageService.getString(StorageKeys.userEmail);
  }

  /// Get current user name
  String? getUserName() {
    return StorageService.getString(StorageKeys.userName);
  }

  /// Update user profile information
  Future<bool> updateUserProfile({
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

  /// Validate JWT token format (basic validation)
  bool isValidToken(String token) {
    // Basic JWT format validation (should have 3 parts separated by dots)
    final parts = token.split('.');
    return parts.length == 3 && token.isNotEmpty;
  }

  /// Check if current session is valid
  bool isSessionValid() {
    final token = getAccessToken();
    if (token == null) return false;
    
    return isValidToken(token) && _tokenStorage.hasValidTokens();
  }

  /// Get authentication headers for API calls
  Map<String, String> getAuthHeaders() {
    final token = getAccessToken();
    if (token == null) return {};
    
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Update DioClient with current access token
  void updateDioClientToken() {
    final token = getAccessToken();
    if (token != null) {
      // This will be called to update Dio's auth header
      // The DioClient will need to be updated to use this
    }
  }
}