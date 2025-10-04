import 'package:flutter_bloc/flutter_bloc.dart';
import 'alerts_event.dart';
import 'alerts_state.dart';

/// BLoC for managing alerts state
class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc() : super(const AlertsState()) {
    on<AlertsLoadRequested>(_onAlertsLoadRequested);
    on<AlertAddRequested>(_onAlertAddRequested);
    on<AlertToggleRequested>(_onAlertToggleRequested);
    on<AlertDeleteRequested>(_onAlertDeleteRequested);
  }

  /// Load alerts
  void _onAlertsLoadRequested(
    AlertsLoadRequested event,
    Emitter<AlertsState> emit,
  ) async {
    emit(state.copyWith(status: AlertsStatus.loading));

    try {
      // Simulate API call to load alerts
      await Future.delayed(const Duration(seconds: 1));

      // Mock alerts data
      final alerts = [
        AlertModel(
          id: '1',
          type: AlertType.price,
          title: 'BTC Price Alert',
          description: 'Bitcoin reached \$50,000',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          price: 50000,
        ),
        AlertModel(
          id: '2',
          type: AlertType.volume,
          title: 'High Volume Alert',
          description: 'USDC volume spike detected',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        AlertModel(
          id: '3',
          type: AlertType.news,
          title: 'Market News',
          description: 'Fed announces interest rate decision',
          isActive: false,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        AlertModel(
          id: '4',
          type: AlertType.technical,
          title: 'Technical Alert',
          description: 'RSI oversold condition on ETH',
          isActive: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        ),
      ];

      emit(state.copyWith(
        status: AlertsStatus.loaded,
        alerts: alerts,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AlertsStatus.error,
        error: 'Failed to load alerts: $e',
      ));
    }
  }

  /// Add new alert
  void _onAlertAddRequested(
    AlertAddRequested event,
    Emitter<AlertsState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final newAlert = AlertModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: event.type,
        title: event.title,
        description: event.description,
        isActive: true,
        createdAt: DateTime.now(),
        price: event.price,
      );

      final updatedAlerts = [newAlert, ...state.alerts];

      emit(state.copyWith(
        alerts: updatedAlerts,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to add alert: $e',
      ));
    }
  }

  /// Toggle alert activation
  void _onAlertToggleRequested(
    AlertToggleRequested event,
    Emitter<AlertsState> emit,
  ) {
    final updatedAlerts = state.alerts.map((alert) {
      if (alert.id == event.alertId) {
        return alert.copyWith(isActive: !alert.isActive);
      }
      return alert;
    }).toList();

    emit(state.copyWith(alerts: updatedAlerts));
  }

  /// Delete alert
  void _onAlertDeleteRequested(
    AlertDeleteRequested event,
    Emitter<AlertsState> emit,
  ) {
    final updatedAlerts = state.alerts
        .where((alert) => alert.id != event.alertId)
        .toList();

    emit(state.copyWith(alerts: updatedAlerts));
  }
}