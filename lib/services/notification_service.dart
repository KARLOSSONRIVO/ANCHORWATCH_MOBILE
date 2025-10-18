import 'storage_service.dart';

enum NotificationType {
  anchorAlert,
  weatherAlert,
  systemAlert,
  reminder,
  info,
}
enum NotificationPriority {
  low,
  medium,
  high,
  critical,
}
class NotificationService {
  static Future<void> init() async {
  }
  static bool areNotificationsEnabled() {
    return StorageService.getBool(StorageKeys.notifications) ?? true;
  }
  static Future<void> setNotificationsEnabled(bool enabled) async {
    await StorageService.setBool(StorageKeys.notifications, enabled);
  }
  static Future<void> showAnchorAlert({
    required String message,
    NotificationPriority priority = NotificationPriority.critical,
  }) async {
    if (!areNotificationsEnabled()) return;
  }
  static Future<void> showWeatherAlert({
    required String title,
    required String message,
    NotificationPriority priority = NotificationPriority.high,
  }) async {
    if (!areNotificationsEnabled()) return;
  }
  static Future<void> showSystemNotification({
    required String title,
    required String message,
    NotificationPriority priority = NotificationPriority.medium,
  }) async {
    if (!areNotificationsEnabled()) return;
  }
  static Future<void> clearAllNotifications() async {
  }
}

