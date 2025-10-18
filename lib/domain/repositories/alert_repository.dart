import '../entities/alert.dart';

abstract class AlertRepository {
  Future<List<Alert>> getAlertHistory({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  });
  Future<AlertDashboard> getAlertDashboard();
  Future<List<AlertRule>> getAlertRules();
  Future<AlertRule> createAlertRule({
    required String type,
    required String name,
    required Map<String, dynamic> conditions,
    required Map<String, dynamic> notificationSettings,
  });
  Future<AlertRule> updateAlertRule({
    required String ruleId,
    String? name,
    bool? isEnabled,
    Map<String, dynamic>? conditions,
    Map<String, dynamic>? notificationSettings,
  });
  Future<void> deleteAlertRule(String ruleId);
  Future<void> acknowledgeAlert(String alertId);
  Future<void> resolveAlert(String alertId);
  Future<void> triggerAlertDetection();
  Future<Map<String, dynamic>> testAlertSystem();
  Future<Map<String, dynamic>> getNotificationConfig();
  Future<Map<String, dynamic>> updateNotificationConfig(
    Map<String, dynamic> config,
  );
}

