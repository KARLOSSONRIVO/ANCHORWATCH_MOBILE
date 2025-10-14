import '../entities/alert.dart';

abstract class AlertRepository {
  /// Get alert history with pagination
  Future<List<Alert>> getAlertHistory({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  });

  /// Get alert dashboard data
  Future<AlertDashboard> getAlertDashboard();

  /// Get alert rules
  Future<List<AlertRule>> getAlertRules();

  /// Create a new alert rule (admin only)
  Future<AlertRule> createAlertRule({
    required String type,
    required String name,
    required Map<String, dynamic> conditions,
    required Map<String, dynamic> notificationSettings,
  });

  /// Update an existing alert rule
  Future<AlertRule> updateAlertRule({
    required String ruleId,
    String? name,
    bool? isEnabled,
    Map<String, dynamic>? conditions,
    Map<String, dynamic>? notificationSettings,
  });

  /// Delete an alert rule
  Future<void> deleteAlertRule(String ruleId);

  /// Acknowledge an alert
  Future<void> acknowledgeAlert(String alertId);

  /// Resolve an alert
  Future<void> resolveAlert(String alertId);

  /// Trigger manual alert detection (admin only)
  Future<void> triggerAlertDetection();

  /// Test alert system (admin only)
  Future<Map<String, dynamic>> testAlertSystem();

  /// Get notification configuration
  Future<Map<String, dynamic>> getNotificationConfig();

  /// Update notification configuration
  Future<Map<String, dynamic>> updateNotificationConfig(
    Map<String, dynamic> config,
  );
}
