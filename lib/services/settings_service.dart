import 'package:flutter/material.dart';
import 'storage_service.dart';

/// App theme modes
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Service for managing app settings and preferences
class SettingsService {
  /// Initialize settings service
  static Future<void> init() async {
    debugPrint('SettingsService: Initializing');
  }

  // Theme Settings
  /// Get current theme mode
  static AppThemeMode getThemeMode() {
    final String? themeModeString = StorageService.getString(StorageKeys.themeMode);
    if (themeModeString == null) return AppThemeMode.system;
    
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == themeModeString,
      orElse: () => AppThemeMode.system,
    );
  }

  /// Set theme mode
  static Future<void> setThemeMode(AppThemeMode themeMode) async {
    await StorageService.setString(StorageKeys.themeMode, themeMode.name);
  }

  // Language Settings
  /// Get current language
  static String getLanguage() {
    return StorageService.getString(StorageKeys.language) ?? 'en';
  }

  /// Set language
  static Future<void> setLanguage(String languageCode) async {
    await StorageService.setString(StorageKeys.language, languageCode);
  }

  // Notification Settings
  /// Check if notifications are enabled
  static bool areNotificationsEnabled() {
    return StorageService.getBool(StorageKeys.notifications) ?? true;
  }

  /// Set notification preference
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await StorageService.setBool(StorageKeys.notifications, enabled);
  }



  // App Settings
  /// Check if this is first app launch
  static bool isFirstLaunch() {
    return StorageService.getBool(StorageKeys.isFirstLaunch) ?? true;
  }

  /// Set first launch completed
  static Future<void> setFirstLaunchCompleted() async {
    await StorageService.setBool(StorageKeys.isFirstLaunch, false);
  }

  /// Check if onboarding is completed
  static bool isOnboardingCompleted() {
    return StorageService.getBool(StorageKeys.isOnboardingCompleted) ?? false;
  }

  /// Set onboarding completed
  static Future<void> setOnboardingCompleted(bool completed) async {
    await StorageService.setBool(StorageKeys.isOnboardingCompleted, completed);
  }

  // AnchorWatch Specific Settings

  /// Check if sound alerts are enabled
  static bool areSoundAlertsEnabled() {
    return StorageService.getBool('sound_alerts_enabled') ?? true;
  }

  /// Set sound alerts preference
  static Future<void> setSoundAlertsEnabled(bool enabled) async {
    await StorageService.setBool('sound_alerts_enabled', enabled);
  }

  /// Check if vibration alerts are enabled
  static bool areVibrationAlertsEnabled() {
    return StorageService.getBool('vibration_alerts_enabled') ?? true;
  }

  /// Set vibration alerts preference
  static Future<void> setVibrationAlertsEnabled(bool enabled) async {
    await StorageService.setBool('vibration_alerts_enabled', enabled);
  }

  /// Get weather alert preference
  static bool areWeatherAlertsEnabled() {
    return StorageService.getBool('weather_alerts_enabled') ?? true;
  }

  /// Set weather alert preference
  static Future<void> setWeatherAlertsEnabled(bool enabled) async {
    await StorageService.setBool('weather_alerts_enabled', enabled);
  }

  // Utility Methods
  /// Reset all settings to defaults
  static Future<void> resetToDefaults() async {
    await StorageService.setString(StorageKeys.themeMode, AppThemeMode.system.name);
    await StorageService.setString(StorageKeys.language, 'en');
    await StorageService.setBool(StorageKeys.notifications, true);
    await StorageService.setBool('sound_alerts_enabled', true);
    await StorageService.setBool('vibration_alerts_enabled', true);
    await StorageService.setBool('weather_alerts_enabled', true);
    
    debugPrint('SettingsService: All settings reset to defaults');
  }

  /// Export settings as JSON
  static Map<String, dynamic> exportSettings() {
    return {
      'themeMode': getThemeMode().name,
      'language': getLanguage(),
      'notificationsEnabled': areNotificationsEnabled(),
      'soundAlertsEnabled': areSoundAlertsEnabled(),
      'vibrationAlertsEnabled': areVibrationAlertsEnabled(),
      'weatherAlertsEnabled': areWeatherAlertsEnabled(),
    };
  }

  /// Import settings from JSON
  static Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('themeMode')) {
        final themeMode = AppThemeMode.values.firstWhere(
          (mode) => mode.name == settings['themeMode'],
          orElse: () => AppThemeMode.system,
        );
        await setThemeMode(themeMode);
      }

      if (settings.containsKey('language')) {
        await setLanguage(settings['language']);
      }

      if (settings.containsKey('notificationsEnabled')) {
        await setNotificationsEnabled(settings['notificationsEnabled']);
      }

      if (settings.containsKey('soundAlertsEnabled')) {
        await setSoundAlertsEnabled(settings['soundAlertsEnabled']);
      }

      if (settings.containsKey('vibrationAlertsEnabled')) {
        await setVibrationAlertsEnabled(settings['vibrationAlertsEnabled']);
      }

      if (settings.containsKey('weatherAlertsEnabled')) {
        await setWeatherAlertsEnabled(settings['weatherAlertsEnabled']);
      }

      debugPrint('SettingsService: Settings imported successfully');
    } catch (e) {
      debugPrint('SettingsService.importSettings error: $e');
    }
  }
}