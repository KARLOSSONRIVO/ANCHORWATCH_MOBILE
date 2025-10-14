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
    return AlertModel(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      severity: json['severity'] as String? ?? 'low',
      status: json['status'] as String? ?? 'active',
      data: json['data'] as Map<String, dynamic>?,
      description: json['description'] as String?,
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
    return AlertDashboardModel(
      totalAlerts: (json['total_alerts'] as num?)?.toInt() ?? 0,
      activeAlerts: (json['active_alerts'] as num?)?.toInt() ?? 0,
      criticalAlerts: (json['critical_alerts'] as num?)?.toInt() ?? 0,
      highAlerts: (json['high_alerts'] as num?)?.toInt() ?? 0,
      mediumAlerts: (json['medium_alerts'] as num?)?.toInt() ?? 0,
      lowAlerts: (json['low_alerts'] as num?)?.toInt() ?? 0,
      recentAlerts:
          (json['recent_alerts'] as List<dynamic>?)
              ?.map((e) => AlertModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      alertsByType: Map<String, int>.from(json['alerts_by_type'] as Map? ?? {}),
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
