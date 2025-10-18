import 'package:equatable/equatable.dart';
import '../../../domain/entities/alert.dart';
abstract class AlertsState extends Equatable {
  const AlertsState();

  @override
  List<Object?> get props => [];
}
class AlertsInitial extends AlertsState {
  const AlertsInitial();
}
class AlertsLoading extends AlertsState {
  const AlertsLoading();
}
class AlertsLoaded extends AlertsState {
  final List<Alert> alerts;
  final bool hasReachedMax;
  final int currentPage;
  final String? currentSeverityFilter;
  final String? currentStatusFilter;
  final String? currentTypeFilter;

  const AlertsLoaded({
    required this.alerts,
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.currentSeverityFilter,
    this.currentStatusFilter,
    this.currentTypeFilter,
  });

  AlertsLoaded copyWith({
    List<Alert>? alerts,
    bool? hasReachedMax,
    int? currentPage,
    String? currentSeverityFilter,
    String? currentStatusFilter,
    String? currentTypeFilter,
  }) {
    return AlertsLoaded(
      alerts: alerts ?? this.alerts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      currentSeverityFilter:
          currentSeverityFilter ?? this.currentSeverityFilter,
      currentStatusFilter: currentStatusFilter ?? this.currentStatusFilter,
      currentTypeFilter: currentTypeFilter ?? this.currentTypeFilter,
    );
  }

  @override
  List<Object?> get props => [
    alerts,
    hasReachedMax,
    currentPage,
    currentSeverityFilter,
    currentStatusFilter,
    currentTypeFilter,
  ];
}
class AlertsError extends AlertsState {
  final String message;

  const AlertsError(this.message);

  @override
  List<Object> get props => [message];
}
class AlertAcknowledged extends AlertsState {
  final String alertId;

  const AlertAcknowledged(this.alertId);

  @override
  List<Object> get props => [alertId];
}
class AlertResolved extends AlertsState {
  final String alertId;

  const AlertResolved(this.alertId);

  @override
  List<Object> get props => [alertId];
}
class AlertsDashboardLoaded extends AlertsState {
  final AlertDashboard dashboard;

  const AlertsDashboardLoaded(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}
class AlertDetectionTriggered extends AlertsState {
  const AlertDetectionTriggered();
}
class AlertSystemTestCompleted extends AlertsState {
  final Map<String, dynamic> testResults;

  const AlertSystemTestCompleted(this.testResults);

  @override
  List<Object> get props => [testResults];
}

