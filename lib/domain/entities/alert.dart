class Alert {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final String severity; // low, medium, high, critical
  final String status; // active, acknowledged, resolved
  final Map<String, dynamic>? data;
  final String? description;

  Alert({
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

  Alert copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    DateTime? createdAt,
    String? severity,
    String? status,
    Map<String, dynamic>? data,
    String? description,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      data: data ?? this.data,
      description: description ?? this.description,
    );
  }

  bool get isActive => status == 'active';
  bool get isAcknowledged => status == 'acknowledged';
  bool get isResolved => status == 'resolved';

  bool get isCritical => severity == 'critical';
  bool get isHigh => severity == 'high';
  bool get isMedium => severity == 'medium';
  bool get isLow => severity == 'low';
}

class AlertRule {
  final String id;
  final String type;
  final String name;
  final bool isEnabled;
  final Map<String, dynamic> conditions;
  final Map<String, dynamic> notificationSettings;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AlertRule({
    required this.id,
    required this.type,
    required this.name,
    required this.isEnabled,
    required this.conditions,
    required this.notificationSettings,
    required this.createdAt,
    this.updatedAt,
  });
}

class AlertDashboard {
  final int totalAlerts;
  final int activeAlerts;
  final int criticalAlerts;
  final int highAlerts;
  final int mediumAlerts;
  final int lowAlerts;
  final List<Alert> recentAlerts;
  final Map<String, int> alertsByType;

  AlertDashboard({
    required this.totalAlerts,
    required this.activeAlerts,
    required this.criticalAlerts,
    required this.highAlerts,
    required this.mediumAlerts,
    required this.lowAlerts,
    required this.recentAlerts,
    required this.alertsByType,
  });
}
