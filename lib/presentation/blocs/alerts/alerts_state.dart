import 'package:equatable/equatable.dart';
import 'alerts_event.dart';

/// Alert data model
class AlertModel extends Equatable {
  const AlertModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.isActive,
    required this.createdAt,
    this.price,
    this.triggeredAt,
  });

  final String id;
  final AlertType type;
  final String title;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final double? price;
  final DateTime? triggeredAt;

  AlertModel copyWith({
    String? id,
    AlertType? type,
    String? title,
    String? description,
    bool? isActive,
    DateTime? createdAt,
    double? price,
    DateTime? triggeredAt,
  }) {
    return AlertModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      price: price ?? this.price,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }

  @override
  List<Object?> get props => [id, type, title, description, isActive, createdAt, price, triggeredAt];
}

/// Alerts status enum
enum AlertsStatus { loading, loaded, error }

/// Alerts state
class AlertsState extends Equatable {
  const AlertsState({
    this.status = AlertsStatus.loading,
    this.alerts = const [],
    this.error,
  });

  final AlertsStatus status;
  final List<AlertModel> alerts;
  final String? error;

  /// Creates a copy with new values
  AlertsState copyWith({
    AlertsStatus? status,
    List<AlertModel>? alerts,
    String? error,
  }) {
    return AlertsState(
      status: status ?? this.status,
      alerts: alerts ?? this.alerts,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, alerts, error];

  @override
  String toString() => 'AlertsState(status: $status, alerts: ${alerts.length}, error: $error)';
}