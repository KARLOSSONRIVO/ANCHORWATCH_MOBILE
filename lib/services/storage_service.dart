import 'package:shared_preferences/shared_preferences.dart';

/// Service for handling local storage operations using SharedPreferences
class StorageService {
  static SharedPreferences? _preferences;

  /// Initialize the storage service
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get preferences {
    if (_preferences == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _preferences!;
  }

  /// Store a string value
  static Future<bool> setString(String key, String value) async {
    return await preferences.setString(key, value);
  }

  /// Get a string value
  static String? getString(String key) {
    return preferences.getString(key);
  }

  /// Store a boolean value
  static Future<bool> setBool(String key, bool value) async {
    return await preferences.setBool(key, value);
  }

  /// Get a boolean value
  static bool? getBool(String key) {
    return preferences.getBool(key);
  }

  /// Store an integer value
  static Future<bool> setInt(String key, int value) async {
    return await preferences.setInt(key, value);
  }

  /// Get an integer value
  static int? getInt(String key) {
    return preferences.getInt(key);
  }

  /// Store a double value
  static Future<bool> setDouble(String key, double value) async {
    return await preferences.setDouble(key, value);
  }

  /// Get a double value
  static double? getDouble(String key) {
    return preferences.getDouble(key);
  }

  /// Store a list of strings
  static Future<bool> setStringList(String key, List<String> value) async {
    return await preferences.setStringList(key, value);
  }

  /// Get a list of strings
  static List<String>? getStringList(String key) {
    return preferences.getStringList(key);
  }

  /// Remove a key-value pair
  static Future<bool> remove(String key) async {
    return await preferences.remove(key);
  }

  /// Clear all stored data
  static Future<bool> clear() async {
    return await preferences.clear();
  }

  /// Check if a key exists
  static bool containsKey(String key) {
    return preferences.containsKey(key);
  }

  /// Get all keys
  static Set<String> getKeys() {
    return preferences.getKeys();
  }
}

/// Commonly used storage keys
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