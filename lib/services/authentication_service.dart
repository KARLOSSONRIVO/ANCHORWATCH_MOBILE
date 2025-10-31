import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../domain/entities/auth_result.dart';
import '../domain/entities/user.dart';
import '../data/models/auth/user_model.dart';
import '../data/endpoints/auth_endpoints.dart';
import 'token_storage_service.dart';
import 'storage_service.dart';
import 'dio_client.dart';

@lazySingleton
class AuthenticationService {
  final TokenStorageService _tokenStorage;
  final DioClient _dioClient;

  AuthenticationService(this._tokenStorage, this._dioClient);
  Future<bool> isAuthenticated() async {
    final hasValidTokens = _tokenStorage.hasValidTokens();
    if (!hasValidTokens) {
      await _tokenStorage.clearTokens();
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      _dioClient.clearAuthToken();
    } else {
      final accessToken = getAccessToken();
      if (accessToken != null) {
        _dioClient.setAuthToken(accessToken);
      }
    }

    return hasValidTokens;
  }

  String? getAccessToken() {
    return _tokenStorage.getAccessToken();
  }

  String? getRefreshToken() {
    return _tokenStorage.getRefreshToken();
  }

  Future<bool> storeAuthResult(AuthResult authResult) async {
    try {
      final tokensStored = await _tokenStorage.saveTokens(authResult.tokens);

      if (tokensStored) {
        await StorageService.setString(StorageKeys.userId, authResult.user.id);
        await StorageService.setString(
          StorageKeys.userEmail,
          authResult.user.email,
        );
        await StorageService.setString(
          StorageKeys.userName,
          authResult.user.username,
        );

        updateDioClientToken();

        _dioClient.setAuthToken(authResult.tokens.accessToken);
      }

      return tokensStored;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final accessToken = _tokenStorage.getAccessToken();
      final refreshToken = _tokenStorage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        try {
          await _dioClient.post(
            AuthEndpoints.logout,
            data: {'access': accessToken, 'refresh': refreshToken},
          );
        } catch (e) {
          return false;
        }
      }

      final tokensCleared = await _tokenStorage.clearTokens();

      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      await StorageService.remove(StorageKeys.userToken);

      _dioClient.clearAuthToken();

      return tokensCleared;
    } catch (e) {
      return false;
    }
  }

  String? getUserId() {
    return StorageService.getString(StorageKeys.userId);
  }

  String? getUserEmail() {
    return StorageService.getString(StorageKeys.userEmail);
  }

  String? getUserName() {
    return StorageService.getString(StorageKeys.userName);
  }

  Future<bool> updateUserProfile({String? name, String? email}) async {
    try {
      if (name != null) {
        await StorageService.setString(StorageKeys.userName, name);
      }

      if (email != null) {
        await StorageService.setString(StorageKeys.userEmail, email);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  bool isValidToken(String token) {
    final parts = token.split('.');
    return parts.length == 3 && token.isNotEmpty;
  }

  bool isSessionValid() {
    final token = getAccessToken();
    if (token == null) return false;

    return isValidToken(token) && _tokenStorage.hasValidTokens();
  }

  Map<String, String> getAuthHeaders() {
    final token = getAccessToken();
    if (token == null) return {};

    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<User?> fetchUserProfile() async {
    try {
      final token = getAccessToken();
      if (token == null) {
        return null;
      }

      final response = await _dioClient.get<Map<String, dynamic>>(
        AuthEndpoints.profile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data != null) {
        final userModel = UserModel.fromJson(response.data!);
        return userModel.toEntity();
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  void updateDioClientToken() {
    final token = getAccessToken();
    if (token != null) {
      _dioClient.setAuthToken(token);
    }
  }

  void clearDioClientToken() {
    _dioClient.clearAuthToken();
  }

  Future<void> clearLocalDataOnly() async {
    try {
      // Clear tokens from storage without making API calls
      await _tokenStorage.clearTokens();

      // Clear user data from storage
      await StorageService.remove(StorageKeys.userId);
      await StorageService.remove(StorageKeys.userEmail);
      await StorageService.remove(StorageKeys.userName);
      await StorageService.remove(StorageKeys.userToken);

      // Clear auth token from Dio client
      _dioClient.clearAuthToken();
    } catch (e) {
      // Ignore errors during cleanup
    }
  }
}
