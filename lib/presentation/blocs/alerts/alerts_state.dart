import 'package:equatable/equatable.dart';
import '../../../domain/entities/alert.dart';

/// Base state for AlertsBloc
abstract class AlertsState extends Equatable {
  const AlertsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AlertsInitial extends AlertsState {
  const AlertsInitial();
}

/// Loading state
class AlertsLoading extends AlertsState {
  const AlertsLoading();
}

/// Loaded state
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

/// Error state
class AlertsError extends AlertsState {
  final String message;

  const AlertsError(this.message);

  @override
  List<Object> get props => [message];
}

/// Alert acknowledged state
class AlertAcknowledged extends AlertsState {
  final String alertId;

  const AlertAcknowledged(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Alert resolved state
class AlertResolved extends AlertsState {
  final String alertId;

  const AlertResolved(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Dashboard loaded state
class AlertsDashboardLoaded extends AlertsState {
  final AlertDashboard dashboard;

  const AlertsDashboardLoaded(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}

/// Alert detection triggered state
class AlertDetectionTriggered extends AlertsState {
  const AlertDetectionTriggered();
}

/// Alert system test result state
class AlertSystemTestCompleted extends AlertsState {
  final Map<String, dynamic> testResults;

  const AlertSystemTestCompleted(this.testResults);

  @override
  List<Object> get props => [testResults];
}
