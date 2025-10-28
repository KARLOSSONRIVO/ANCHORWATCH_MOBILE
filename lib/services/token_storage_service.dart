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
  Future<bool> saveTokens(AuthTokens tokens) async {
    try {
      final accessTokenSaved = await _prefs.setString(
        _accessTokenKey,
        tokens.accessToken,
      );
      final refreshTokenSaved = await _prefs.setString(
        _refreshTokenKey,
        tokens.refreshToken,
      );

      return accessTokenSaved && refreshTokenSaved;
    } catch (e) {
      return false;
    }
  }

  AuthTokens? getTokens() {
    try {
      final accessToken = _prefs.getString(_accessTokenKey);
      final refreshToken = _prefs.getString(_refreshTokenKey);

      if (accessToken != null && refreshToken != null) {
        return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  String? getAccessToken() {
    try {
      return _prefs.getString(_accessTokenKey);
    } catch (e) {
      return null;
    }
  }

  String? getRefreshToken() {
    try {
      return _prefs.getString(_refreshTokenKey);
    } catch (e) {
      return null;
    }
  }

  bool hasValidTokens() {
    final tokens = getTokens();
    if (tokens == null ||
        tokens.accessToken.isEmpty ||
        tokens.refreshToken.isEmpty) {
      return false;
    }
    return !_isTokenExpired(tokens.accessToken);
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true; // Invalid JWT format
      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      final Map<String, dynamic> payloadMap = jsonDecode(decoded);

      final exp = payloadMap['exp'];
      if (exp == null) return false; // No expiration claim

      final expirationDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isAfter(expirationDate);
    } catch (e) {
      return true; // Consider expired if we can't decode
    }
  }

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
      return null;
    }
  }

  Future<bool> clearTokens() async {
    try {
      final accessCleared = await _prefs.remove(_accessTokenKey);
      final refreshCleared = await _prefs.remove(_refreshTokenKey);

      return accessCleared && refreshCleared;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateAccessToken(String newAccessToken) async {
    try {
      return await _prefs.setString(_accessTokenKey, newAccessToken);
    } catch (e) {
      return false;
    }
  }
}
