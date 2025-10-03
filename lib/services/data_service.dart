import 'package:flutter/material.dart';
import 'storage_service.dart';

/// App data model for general application data
class AppData {
  final String id;
  final String name;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const AppData({
    required this.id,
    required this.name,
    required this.type,
    required this.data,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Create from JSON
  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
    );
  }

  /// Create a copy with updated fields
  AppData copyWith({
    String? id,
    String? name,
    String? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return AppData(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'AppData(id: $id, name: $name, type: $type, isActive: $isActive)';
  }
}

/// Service for managing general application data (non-coordinate related)
class DataService {
  static const String _appDataKey = 'app_data';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _sessionDataKey = 'session_data';

  /// Initialize data service
  static Future<void> init() async {
    debugPrint('DataService: Initializing');
  }

  // General Data Management
  /// Save app data
  static Future<bool> saveAppData(AppData data) async {
    try {
      final dataList = getAppData();
      
      // Check if data with same ID exists
      final existingIndex = dataList.indexWhere((d) => d.id == data.id);
      if (existingIndex != -1) {
        dataList[existingIndex] = data.copyWith(updatedAt: DateTime.now());
      } else {
        dataList.add(data);
      }

      await _saveAppDataToStorage(dataList);
      debugPrint('DataService: App data saved - ${data.name}');
      return true;
    } catch (e) {
      debugPrint('DataService.saveAppData error: $e');
      return false;
    }
  }

  /// Get all app data
  static List<AppData> getAppData() {
    try {
      final List<String>? dataStrings = StorageService.getStringList(_appDataKey);
      if (dataStrings == null) return [];

      // In a real implementation, you'd use json.decode
      // For now, return empty list
      return [];
    } catch (e) {
      debugPrint('DataService.getAppData error: $e');
      return [];
    }
  }

  /// Get app data by type
  static List<AppData> getAppDataByType(String type) {
    return getAppData().where((data) => data.type == type).toList();
  }

  /// Get app data by ID
  static AppData? getAppDataById(String id) {
    try {
      final dataList = getAppData();
      return dataList.where((data) => data.id == id).firstOrNull;
    } catch (e) {
      debugPrint('DataService.getAppDataById error: $e');
      return null;
    }
  }

  /// Delete app data
  static Future<bool> deleteAppData(String dataId) async {
    try {
      final dataList = getAppData();
      dataList.removeWhere((data) => data.id == dataId);
      
      await _saveAppDataToStorage(dataList);
      debugPrint('DataService: App data deleted - $dataId');
      return true;
    } catch (e) {
      debugPrint('DataService.deleteAppData error: $e');
      return false;
    }
  }

  // User Preferences Management
  /// Save user preference
  static Future<bool> saveUserPreference(String key, dynamic value) async {
    try {
      final preferences = getUserPreferences();
      preferences[key] = value;
      
      // In a real implementation, you'd use json.encode
      await StorageService.setString(_userPreferencesKey, preferences.toString());
      
      debugPrint('DataService: User preference saved - $key');
      return true;
    } catch (e) {
      debugPrint('DataService.saveUserPreference error: $e');
      return false;
    }
  }

  /// Get all user preferences
  static Map<String, dynamic> getUserPreferences() {
    try {
      final String? preferencesString = StorageService.getString(_userPreferencesKey);
      if (preferencesString == null) return {};

      // In a real implementation, you'd use json.decode
      return {};
    } catch (e) {
      debugPrint('DataService.getUserPreferences error: $e');
      return {};
    }
  }

  /// Get specific user preference
  static T? getUserPreference<T>(String key) {
    try {
      final preferences = getUserPreferences();
      return preferences[key] as T?;
    } catch (e) {
      debugPrint('DataService.getUserPreference error: $e');
      return null;
    }
  }

  /// Remove user preference
  static Future<bool> removeUserPreference(String key) async {
    try {
      final preferences = getUserPreferences();
      preferences.remove(key);
      
      await StorageService.setString(_userPreferencesKey, preferences.toString());
      debugPrint('DataService: User preference removed - $key');
      return true;
    } catch (e) {
      debugPrint('DataService.removeUserPreference error: $e');
      return false;
    }
  }

  // Session Data Management
  /// Save session data
  static Future<bool> saveSessionData(String key, dynamic value) async {
    try {
      final sessionData = getSessionData();
      sessionData[key] = {
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await StorageService.setString(_sessionDataKey, sessionData.toString());
      debugPrint('DataService: Session data saved - $key');
      return true;
    } catch (e) {
      debugPrint('DataService.saveSessionData error: $e');
      return false;
    }
  }

  /// Get all session data
  static Map<String, dynamic> getSessionData() {
    try {
      final String? sessionString = StorageService.getString(_sessionDataKey);
      if (sessionString == null) return {};

      // In a real implementation, you'd use json.decode
      return {};
    } catch (e) {
      debugPrint('DataService.getSessionData error: $e');
      return {};
    }
  }

  /// Get specific session data
  static T? getSessionValue<T>(String key) {
    try {
      final sessionData = getSessionData();
      final data = sessionData[key];
      return data != null ? data['value'] as T? : null;
    } catch (e) {
      debugPrint('DataService.getSessionValue error: $e');
      return null;
    }
  }

  /// Clear session data
  static Future<void> clearSessionData() async {
    await StorageService.remove(_sessionDataKey);
    debugPrint('DataService: Session data cleared');
  }

  // Utility Methods
  /// Clear all data
  static Future<void> clearAllData() async {
    await StorageService.remove(_appDataKey);
    await StorageService.remove(_userPreferencesKey);
    await StorageService.remove(_sessionDataKey);
    
    debugPrint('DataService: All data cleared');
  }

  /// Export data as JSON
  static Map<String, dynamic> exportData() {
    return {
      'appData': getAppData().map((data) => data.toJson()).toList(),
      'userPreferences': getUserPreferences(),
      'sessionData': getSessionData(),
      'exportTime': DateTime.now().toIso8601String(),
    };
  }

  /// Get data statistics
  static Map<String, int> getDataStatistics() {
    final appData = getAppData();
    final preferences = getUserPreferences();
    final sessionData = getSessionData();
    
    return {
      'totalAppData': appData.length,
      'activeAppData': appData.where((data) => data.isActive).length,
      'userPreferences': preferences.length,
      'sessionEntries': sessionData.length,
    };
  }

  /// Save app data to storage (private method)
  static Future<void> _saveAppDataToStorage(List<AppData> dataList) async {
    final List<String> dataStrings = dataList.map((data) {
      // In a real implementation, you'd use json.encode(data.toJson())
      return data.toString();
    }).toList();

    await StorageService.setStringList(_appDataKey, dataStrings);
  }
}