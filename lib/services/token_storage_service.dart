import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/entities/auth_tokens.dart';

@lazySingleton
class TokenStorageService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  final SharedPreferences _prefs;
  
  TokenStorageService(this._prefs);

  /// Save authentication tokens to SharedPreferences
  Future<bool> saveTokens(AuthTokens tokens) async {
    try {
      final accessTokenSaved = await _prefs.setString(_accessTokenKey, tokens.accessToken);
      final refreshTokenSaved = await _prefs.setString(_refreshTokenKey, tokens.refreshToken);
      
      return accessTokenSaved && refreshTokenSaved;
    } catch (e) {
      print('Error saving tokens: $e');
      return false;
    }
  }

  /// Retrieve stored authentication tokens
  AuthTokens? getTokens() {
    try {
      final accessToken = _prefs.getString(_accessTokenKey);
      final refreshToken = _prefs.getString(_refreshTokenKey);
      
      if (accessToken != null && refreshToken != null) {
        return AuthTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
      
      return null;
    } catch (e) {
      print('Error retrieving tokens: $e');
      return null;
    }
  }

  /// Get only access token
  String? getAccessToken() {
    try {
      return _prefs.getString(_accessTokenKey);
    } catch (e) {
      print('Error retrieving access token: $e');
      return null;
    }
  }

  /// Get only refresh token
  String? getRefreshToken() {
    try {
      return _prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error retrieving refresh token: $e');
      return null;
    }
  }

  /// Check if user has valid tokens stored
  bool hasValidTokens() {
    final tokens = getTokens();
    if (tokens == null || tokens.accessToken.isEmpty || tokens.refreshToken.isEmpty) {
      return false;
    }
    
    // Check if access token is not expired
    return !_isTokenExpired(tokens.accessToken);
  }

  /// Check if a JWT token is expired
  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true; // Invalid JWT format
      
      // Decode the payload (second part)
      final payload = parts[1];
      // Add padding if needed for base64 decoding
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);
      
      final exp = payloadMap['exp'];
      if (exp == null) return false; // No expiration claim
      
      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      print('Error checking token expiration: $e');
      return true; // Consider expired if we can't decode
    }
  }

  /// Get token expiration time
  DateTime? getTokenExpiration(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);
      
      final exp = payloadMap['exp'];
      if (exp == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    } catch (e) {
      print('Error getting token expiration: $e');
      return null;
    }
  }

  /// Clear all stored tokens (logout)
  Future<bool> clearTokens() async {
    try {
      final accessCleared = await _prefs.remove(_accessTokenKey);
      final refreshCleared = await _prefs.remove(_refreshTokenKey);
      
      return accessCleared && refreshCleared;
    } catch (e) {
      print('Error clearing tokens: $e');
      return false;
    }
  }

  /// Update only access token (useful for token refresh)
  Future<bool> updateAccessToken(String newAccessToken) async {
    try {
      return await _prefs.setString(_accessTokenKey, newAccessToken);
    } catch (e) {
      print('Error updating access token: $e');
      return false;
    }
  }
}