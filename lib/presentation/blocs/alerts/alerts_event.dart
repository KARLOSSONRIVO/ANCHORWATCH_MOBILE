import 'package:equatable/equatable.dart';
abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object?> get props => [];
}
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
class AlertsRefreshRequested extends AlertsEvent {
  const AlertsRefreshRequested();
}
class AlertsLoadMoreRequested extends AlertsEvent {
  const AlertsLoadMoreRequested();
}
class AlertsDashboardLoadRequested extends AlertsEvent {
  const AlertsDashboardLoadRequested();
}
class AlertAcknowledgeRequested extends AlertsEvent {
  final String alertId;

  const AlertAcknowledgeRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}
class AlertResolveRequested extends AlertsEvent {
  final String alertId;

  const AlertResolveRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}
class AlertsFilterChanged extends AlertsEvent {
  final String? severity;
  final String? status;
  final String? type;

  const AlertsFilterChanged({this.severity, this.status, this.type});

  @override
  List<Object?> get props => [severity, status, type];
}
class AlertDetectionTriggerRequested extends AlertsEvent {
  const AlertDetectionTriggerRequested();
}
class AlertSystemTestRequested extends AlertsEvent {
  const AlertSystemTestRequested();
}

