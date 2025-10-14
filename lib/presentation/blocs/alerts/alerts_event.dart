import 'package:equatable/equatable.dart';

/// Events for the AlertsBloc
abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load alert history
class AlertsLoadRequested extends AlertsEvent {
  final int page;
  final int limit;
  final String? severity;
  final String? status;
  final String? type;

  const AlertsLoadRequested({
    this.page = 1,
    this.limit = 20,
    this.severity,
    this.status,
    this.type,
  });

  @override
  List<Object?> get props => [page, limit, severity, status, type];
}

/// Event to refresh alerts
class AlertsRefreshRequested extends AlertsEvent {
  const AlertsRefreshRequested();
}

/// Event to load more alerts (pagination)
class AlertsLoadMoreRequested extends AlertsEvent {
  const AlertsLoadMoreRequested();
}

/// Event to load alert dashboard
class AlertsDashboardLoadRequested extends AlertsEvent {
  const AlertsDashboardLoadRequested();
}

/// Event to acknowledge an alert
class AlertAcknowledgeRequested extends AlertsEvent {
  final String alertId;

  const AlertAcknowledgeRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Event to resolve an alert
class AlertResolveRequested extends AlertsEvent {
  final String alertId;

  const AlertResolveRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Event to filter alerts
class AlertsFilterChanged extends AlertsEvent {
  final String? severity;
  final String? status;
  final String? type;

  const AlertsFilterChanged({this.severity, this.status, this.type});

  @override
  List<Object?> get props => [severity, status, type];
}

/// Event to trigger alert detection (admin)
class AlertDetectionTriggerRequested extends AlertsEvent {
  const AlertDetectionTriggerRequested();
}

/// Event to test alert system (admin)
class AlertSystemTestRequested extends AlertsEvent {
  const AlertSystemTestRequested();
}
