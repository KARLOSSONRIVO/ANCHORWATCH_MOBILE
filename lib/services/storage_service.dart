import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class StorageService {
  static SharedPreferences? _preferences;
  
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }
  
  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _preferences!;
  }
  static Future<bool> setString(String key, String value) async {
    return await preferences.setString(key, value);
  }
  static String? getString(String key) {
    return preferences.getString(key);
  }
  static Future<bool> setBool(String key, bool value) async {
    return await preferences.setBool(key, value);
  }
  static bool? getBool(String key) {
    return preferences.getBool(key);
  }
  static Future<bool> setInt(String key, int value) async {
    return await preferences.setInt(key, value);
  }
  static int? getInt(String key) {
    return preferences.getInt(key);
  }
  static Future<bool> setDouble(String key, double value) async {
    return await preferences.setDouble(key, value);
  }
  static double? getDouble(String key) {
    return preferences.getDouble(key);
  }
  static Future<bool> setStringList(String key, List<String> value) async {
    return await preferences.setStringList(key, value);
  }
  static List<String>? getStringList(String key) {
    return preferences.getStringList(key);
  }
  static Future<bool> remove(String key) async {
    return await preferences.remove(key);
  }
  static Future<bool> clear() async {
    return await preferences.clear();
  }
  static bool containsKey(String key) {
    return preferences.containsKey(key);
  }
  static Set<String> getKeys() {
    return preferences.getKeys();
  }

  // User-specific helper methods
  static Future<String?> getUserId() async {
    return getString(StorageKeys.userId);
  }

  static Future<String?> getUserEmail() async {
    return getString(StorageKeys.userEmail);
  }

  static Future<String?> getUsername() async {
    return getString(StorageKeys.userName);
  }

  static Future<bool> setUserId(String userId) async {
    return await setString(StorageKeys.userId, userId);
  }

  static Future<bool> setUserEmail(String email) async {
    return await setString(StorageKeys.userEmail, email);
  }

  static Future<bool> setUsername(String username) async {
    return await setString(StorageKeys.userName, username);
  }
}
class StorageKeys {
  static const String isOnboardingCompleted = 'is_onboarding_completed';
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String isFirstLaunch = 'is_first_launch';
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notifications = 'notifications_enabled';
}
