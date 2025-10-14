import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../domain/entities/auth_result.dart';
import '../domain/entities/user.dart';
import '../data/models/auth/user_model.dart';
import '../data/endpoints/auth_endpoints.dart';
import 'token_storage_service.dart';
import 'storage_service.dart';
import 'dio_client.dart';

/// Service for handling authentication operations with JWT tokens
@lazySingleton
class AuthenticationService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;
  
  AuthenticationService(this._tokenStorage, this._dioClient);

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
      // Clear auth token from DioClient
      _dioClient.clearAuthToken();
    } else {
      // If tokens are valid, set the auth token in DioClient
      final accessToken = getAccessToken();
      if (accessToken != null) {
        _dioClient.setAuthToken(accessToken);
        debugPrint('AuthenticationService: Auth token restored in DioClient');
      }
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

        // Update DioClient with the new auth token
        updateDioClientToken();

        // Set the auth token in DioClient for authenticated API requests
        _dioClient.setAuthToken(authResult.tokens.accessToken);
        debugPrint('AuthenticationService: Auth token set in DioClient');
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
      // Get current tokens for server logout
      final accessToken = _tokenStorage.getAccessToken();
      final refreshToken = _tokenStorage.getRefreshToken();
      
      // Call server logout endpoint if we have tokens
      if (accessToken != null && refreshToken != null) {
        try {
          debugPrint('AuthenticationService: Calling server logout endpoint');
          await _dioClient.post(
            AuthEndpoints.logout,
            data: {
              'access': accessToken,
              'refresh': refreshToken,
            },
          );
          debugPrint('AuthenticationService: Server logout successful');
        } catch (serverError) {
          debugPrint('AuthenticationService: Server logout failed: $serverError');
          // Continue with local logout even if server logout fails
        }
      }
      
      // Clear local tokens and data
      final tokensCleared = await _tokenStorage.clearTokens();
      
      // Clear only authentication-related data, preserve onboarding status
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      await StorageService.remove(StorageKeys.userToken);
      
      // Clear DioClient auth token
      _dioClient.clearAuthToken();

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

  /// Fetch user profile from server
  Future<User?> fetchUserProfile() async {
    try {
      final token = getAccessToken();
      if (token == null) {
        debugPrint('AuthenticationService: No access token available for profile fetch');
        return null;
      }

      debugPrint('AuthenticationService: Fetching user profile');
      final response = await _dioClient.get<Map<String, dynamic>>(
        AuthEndpoints.profile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.data != null) {
        final userModel = UserModel.fromJson(response.data!);
        debugPrint('AuthenticationService: Profile fetched successfully');
        return userModel.toEntity();
      }

      debugPrint('AuthenticationService: No profile data received');
      return null;
    } catch (e) {
      debugPrint('AuthenticationService: Profile fetch error: $e');
      return null;
    }
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