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
    final safeJson = Map<String, dynamic>.from(json);
    final id = _coalesceString(safeJson, ['id', '_id', 'alert_id']);
    final ruleId = _coalesceString(safeJson, ['rule_id']);
    final type = _coalesceString(safeJson, ['type', 'alert_type']);
    final title = _coalesceString(safeJson, [
      'title',
      'rule_name',
      'message',
      'alert_type',
    ], defaultValue: 'Alert notification');
    final message = _coalesceString(safeJson, ['message'], defaultValue: title);
    final createdAt = _coalesceString(safeJson, [
      'created_at',
      'triggered_at',
      'timestamp',
    ], defaultValue: DateTime.now().toIso8601String());
    final severity = _normalizeSeverity(
      _coalesceString(safeJson, ['severity'], defaultValue: 'low'),
    );
    final status = _normalizeStatus(
      _coalesceString(safeJson, ['status'], defaultValue: 'active'),
    );
    final description = _optionalString(safeJson, [
      'description',
      'rule_description',
      'details',
    ]);
    final data = _coalesceMap(safeJson['data']);

    return AlertModel(
      id: id.isNotEmpty ? id : (ruleId.isNotEmpty ? ruleId : type),
      type: type,
      title: title,
      message: message,
      createdAt: createdAt,
      severity: severity,
      status: status,
      data: data,
      description: description,
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

  static String _coalesceString(
    Map<String, dynamic> json,
    List<String> keys, {
    String defaultValue = '',
  }) {
    for (final key in keys) {
      if (!json.containsKey(key)) {
        continue;
      }
      final value = json[key];
      if (value == null) {
        continue;
      }
      if (value is DateTime) {
        return value.toIso8601String();
      }
      final stringValue = value.toString().trim();
      if (stringValue.isNotEmpty) {
        return stringValue;
      }
    }
    return defaultValue;
  }

  static String? _optionalString(Map<String, dynamic> json, List<String> keys) {
    final value = _coalesceString(json, keys);
    return value.isEmpty ? null : value;
  }

  static Map<String, dynamic>? _coalesceMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    return null;
  }

  static String _normalizeStatus(String status) {
    final value = status.toLowerCase();
    if (value == 'triggered') {
      return 'active';
    }
    return value;
  }

  static String _normalizeSeverity(String severity) {
    return severity.toLowerCase();
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
    if (json.containsKey('alerts')) {
      final alertsSection = (json['alerts'] as Map<String, dynamic>?) ?? {};
      final statistics =
          (alertsSection['statistics'] as Map<String, dynamic>?) ?? {};
      final bySeverity =
          (statistics['by_severity'] as Map<String, dynamic>?) ?? {};
      final byStatus = (statistics['by_status'] as Map<String, dynamic>?) ?? {};
      final byType = (statistics['by_type'] as Map<String, dynamic>?) ?? {};
      final recent = (alertsSection['recent'] as List<dynamic>?) ?? [];

      int _asInt(dynamic value) => (value is num) ? value.toInt() : 0;

      return AlertDashboardModel(
        totalAlerts: _asInt(statistics['total_alerts']) != 0
            ? _asInt(statistics['total_alerts'])
            : recent.length,
        activeAlerts:
            _asInt(byStatus['active']) + _asInt(byStatus['triggered']),
        criticalAlerts: _asInt(bySeverity['critical']),
        highAlerts: _asInt(bySeverity['high']),
        mediumAlerts: _asInt(bySeverity['medium']),
        lowAlerts: _asInt(bySeverity['low']),
        recentAlerts: recent
            .whereType<Map<String, dynamic>>()
            .map(AlertModel.fromJson)
            .toList(),
        alertsByType: byType.map((key, value) => MapEntry(key, _asInt(value))),
      );
    }

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
