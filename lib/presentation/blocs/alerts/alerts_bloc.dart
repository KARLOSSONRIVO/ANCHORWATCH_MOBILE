import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/alerts/get_alert_history_usecase.dart';
import '../../../domain/usecases/alerts/acknowledge_alert_usecase.dart';
import '../../../domain/usecases/alerts/resolve_alert_usecase.dart';
import '../../../domain/repositories/alert_repository.dart';
import 'alerts_event.dart';
import 'alerts_state.dart';

/// BLoC for managing alerts state
@injectable
class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  final GetAlertHistoryUseCase _getAlertHistoryUseCase;
  final AcknowledgeAlertUseCase _acknowledgeAlertUseCase;
  final ResolveAlertUseCase _resolveAlertUseCase;
  final AlertRepository _alertRepository;

  AlertsBloc(
    this._getAlertHistoryUseCase,
    this._acknowledgeAlertUseCase,
    this._resolveAlertUseCase,
    this._alertRepository,
  ) : super(const AlertsInitial()) {
    on<AlertsLoadRequested>(_onAlertsLoadRequested);
    on<AlertsRefreshRequested>(_onAlertsRefreshRequested);
    on<AlertsLoadMoreRequested>(_onAlertsLoadMoreRequested);
    on<AlertsDashboardLoadRequested>(_onAlertsDashboardLoadRequested);
    on<AlertAcknowledgeRequested>(_onAlertAcknowledgeRequested);
    on<AlertResolveRequested>(_onAlertResolveRequested);
    on<AlertsFilterChanged>(_onAlertsFilterChanged);
    on<AlertDetectionTriggerRequested>(_onAlertDetectionTriggerRequested);
    on<AlertSystemTestRequested>(_onAlertSystemTestRequested);
  }

  /// Load alerts with optional filters
  void _onAlertsLoadRequested(
    AlertsLoadRequested event,
    Emitter<AlertsState> emit,
  ) async {
    emit(const AlertsLoading());

    try {
      final alerts = await _getAlertHistoryUseCase.call(
        page: event.page,
        limit: event.limit,
        severity: event.severity,
        status: event.status,
        type: event.type,
      );

      emit(
        AlertsLoaded(
          alerts: alerts,
          hasReachedMax: alerts.length < event.limit,
          currentPage: event.page,
          currentSeverityFilter: event.severity,
          currentStatusFilter: event.status,
          currentTypeFilter: event.type,
        ),
      );
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Refresh alerts
  void _onAlertsRefreshRequested(
    AlertsRefreshRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      // If currently loaded, get current filters
      String? severityFilter;
      String? statusFilter;
      String? typeFilter;

      if (state is AlertsLoaded) {
        final loadedState = state as AlertsLoaded;
        severityFilter = loadedState.currentSeverityFilter;
        statusFilter = loadedState.currentStatusFilter;
        typeFilter = loadedState.currentTypeFilter;
      }

      final alerts = await _getAlertHistoryUseCase.call(
        page: 1,
        limit: 20,
        severity: severityFilter,
        status: statusFilter,
        type: typeFilter,
      );

      emit(
        AlertsLoaded(
          alerts: alerts,
          hasReachedMax: alerts.length < 20,
          currentPage: 1,
          currentSeverityFilter: severityFilter,
          currentStatusFilter: statusFilter,
          currentTypeFilter: typeFilter,
        ),
      );
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Load more alerts for pagination
  void _onAlertsLoadMoreRequested(
    AlertsLoadMoreRequested event,
    Emitter<AlertsState> emit,
  ) async {
    if (state is AlertsLoaded) {
      final currentState = state as AlertsLoaded;

      if (currentState.hasReachedMax) return;

      try {
        final newAlerts = await _getAlertHistoryUseCase.call(
          page: currentState.currentPage + 1,
          limit: 20,
          severity: currentState.currentSeverityFilter,
          status: currentState.currentStatusFilter,
          type: currentState.currentTypeFilter,
        );

        emit(
          currentState.copyWith(
            alerts: List.from(currentState.alerts)..addAll(newAlerts),
            hasReachedMax: newAlerts.length < 20,
            currentPage: currentState.currentPage + 1,
          ),
        );
      } catch (error) {
        emit(AlertsError(error.toString()));
      }
    }
  }

  /// Load alert dashboard
  void _onAlertsDashboardLoadRequested(
    AlertsDashboardLoadRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      final dashboard = await _alertRepository.getAlertDashboard();
      emit(AlertsDashboardLoaded(dashboard));
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Acknowledge an alert
  void _onAlertAcknowledgeRequested(
    AlertAcknowledgeRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      await _acknowledgeAlertUseCase.call(event.alertId);
      emit(AlertAcknowledged(event.alertId));

      // Refresh alerts to show updated status
      add(const AlertsRefreshRequested());
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Resolve an alert
  void _onAlertResolveRequested(
    AlertResolveRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      await _resolveAlertUseCase.call(event.alertId);
      emit(AlertResolved(event.alertId));

      // Refresh alerts to show updated status
      add(const AlertsRefreshRequested());
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Filter alerts
  void _onAlertsFilterChanged(
    AlertsFilterChanged event,
    Emitter<AlertsState> emit,
  ) async {
    emit(const AlertsLoading());

    try {
      final alerts = await _getAlertHistoryUseCase.call(
        page: 1,
        limit: 20,
        severity: event.severity,
        status: event.status,
        type: event.type,
      );

      emit(
        AlertsLoaded(
          alerts: alerts,
          hasReachedMax: alerts.length < 20,
          currentPage: 1,
          currentSeverityFilter: event.severity,
          currentStatusFilter: event.status,
          currentTypeFilter: event.type,
        ),
      );
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Trigger alert detection (admin)
  void _onAlertDetectionTriggerRequested(
    AlertDetectionTriggerRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      await _alertRepository.triggerAlertDetection();
      emit(const AlertDetectionTriggered());
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }

  /// Test alert system (admin)
  void _onAlertSystemTestRequested(
    AlertSystemTestRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      final testResults = await _alertRepository.testAlertSystem();
      emit(AlertSystemTestCompleted(testResults));
    } catch (error) {
      emit(AlertsError(error.toString()));
    }
  }
}
