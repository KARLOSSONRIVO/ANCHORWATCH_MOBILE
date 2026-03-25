import '../../domain/entities/alert.dart';

class AlertModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final String createdAt;
  final String severity;
  final String status;
  final Map<String, dynamic>? data;
  final String? description;

  AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.severity,
    required this.status,
    this.data,
    this.description,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    final createdAtValue = json['created_at'] ?? json['triggered_at'];

    return AlertModel(
      id: json['id']?.toString() ?? '',
      type: (json['type'] ?? json['alert_type'])?.toString() ?? '',
      title:
          (json['title'] ?? json['rule_name'] ?? json['alert_type'])
              ?.toString() ??
          '',
      message: json['message']?.toString() ?? '',
      createdAt: createdAtValue?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'low',
      status: json['status']?.toString() ?? 'active',
      data: json['data'] is Map
          ? Map<String, dynamic>.from(json['data'] as Map)
          : null,
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'created_at': createdAt,
      'severity': severity,
      'status': status,
      'data': data,
      'description': description,
    };
  }

  Alert toEntity() {
    return Alert(
      id: id,
      type: type,
      title: title,
      message: message,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      severity: severity,
      status: status,
      data: data,
      description: description,
    );
  }

  static AlertModel fromEntity(Alert alert) {
    return AlertModel(
      id: alert.id,
      type: alert.type,
      title: alert.title,
      message: alert.message,
      createdAt: alert.createdAt.toIso8601String(),
      severity: alert.severity,
      status: alert.status,
      data: alert.data,
      description: alert.description,
    );
  }
}

class AlertRuleModel {
  final String id;
  final String type;
  final String name;
  final bool isEnabled;
  final Map<String, dynamic> conditions;
  final Map<String, dynamic> notificationSettings;
  final String createdAt;
  final String? updatedAt;

  AlertRuleModel({
    required this.id,
    required this.type,
    required this.name,
    required this.isEnabled,
    required this.conditions,
    required this.notificationSettings,
    required this.createdAt,
    this.updatedAt,
  });

  factory AlertRuleModel.fromJson(Map<String, dynamic> json) {
    return AlertRuleModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isEnabled: json['is_enabled'] as bool? ?? false,
      conditions: json['conditions'] as Map<String, dynamic>? ?? {},
      notificationSettings:
          json['notification_settings'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String?,
    );
  }

  AlertRule toEntity() {
    return AlertRule(
      id: id,
      type: type,
      name: name,
      isEnabled: isEnabled,
      conditions: conditions,
      notificationSettings: notificationSettings,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
    );
  }
}

class AlertDashboardModel {
  final int totalAlerts;
  final int activeAlerts;
  final int criticalAlerts;
  final int highAlerts;
  final int mediumAlerts;
  final int lowAlerts;
  final List<AlertModel> recentAlerts;
  final Map<String, int> alertsByType;

  AlertDashboardModel({
    required this.totalAlerts,
    required this.activeAlerts,
    required this.criticalAlerts,
    required this.highAlerts,
    required this.mediumAlerts,
    required this.lowAlerts,
    required this.recentAlerts,
    required this.alertsByType,
  });

  factory AlertDashboardModel.fromJson(Map<String, dynamic> json) {
    final alertsSection = json['alerts'] as Map<String, dynamic>?;
    final statistics = alertsSection?['statistics'] as Map<String, dynamic>?;
    final recentAlertsJson =
        (alertsSection?['recent'] as List<dynamic>?) ??
        (json['recent_alerts'] as List<dynamic>?) ??
        <dynamic>[];
    final bySeverity = statistics?['by_severity'] is Map
        ? Map<String, dynamic>.from(statistics?['by_severity'] as Map)
        : <String, dynamic>{};
    final byStatus = statistics?['by_status'] is Map
        ? Map<String, dynamic>.from(statistics?['by_status'] as Map)
        : <String, dynamic>{};
    final byType =
        (statistics?['by_type'] is Map
            ? Map<String, dynamic>.from(statistics?['by_type'] as Map)
            : null) ??
        (json['alerts_by_type'] is Map
            ? Map<String, dynamic>.from(json['alerts_by_type'] as Map)
            : <String, dynamic>{});

    int asInt(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    int valueWithFallback(dynamic primary, dynamic fallback) {
      final primaryValue = asInt(primary);
      if (primaryValue > 0 || primary == 0) {
        return primaryValue;
      }
      return asInt(fallback);
    }

    return AlertDashboardModel(
      totalAlerts: valueWithFallback(
        statistics?['total_alerts'],
        json['total_alerts'],
      ),
      activeAlerts: valueWithFallback(
        byStatus['active'],
        json['active_alerts'],
      ),
      criticalAlerts: valueWithFallback(
        bySeverity['critical'],
        json['critical_alerts'],
      ),
      highAlerts: valueWithFallback(bySeverity['high'], json['high_alerts']),
      mediumAlerts: valueWithFallback(
        bySeverity['medium'],
        json['medium_alerts'],
      ),
      lowAlerts: valueWithFallback(bySeverity['low'], json['low_alerts']),
      recentAlerts: recentAlertsJson
          .map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      alertsByType: byType.map((k, v) => MapEntry(k, asInt(v))),
    );
  }

  AlertDashboard toEntity() {
    return AlertDashboard(
      totalAlerts: totalAlerts,
      activeAlerts: activeAlerts,
      criticalAlerts: criticalAlerts,
      highAlerts: highAlerts,
      mediumAlerts: mediumAlerts,
      lowAlerts: lowAlerts,
      recentAlerts: recentAlerts.map((model) => model.toEntity()).toList(),
      alertsByType: alertsByType,
    );
  }
}
