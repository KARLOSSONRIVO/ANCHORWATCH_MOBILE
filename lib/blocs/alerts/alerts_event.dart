import 'package:equatable/equatable.dart';

/// Events for the AlertsBloc
abstract class AlertsEvent extends Equatable {
  const AlertsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load alerts
class AlertsLoadRequested extends AlertsEvent {
  const AlertsLoadRequested();
}

/// Event to add a new alert
class AlertAddRequested extends AlertsEvent {
  final AlertType type;
  final String title;
  final String description;
  final double? price;

  const AlertAddRequested({
    required this.type,
    required this.title,
    required this.description,
    this.price,
  });

  @override
  List<Object> get props => [type, title, description, price ?? 0];
}

/// Event to toggle alert activation
class AlertToggleRequested extends AlertsEvent {
  final String alertId;

  const AlertToggleRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Event to delete an alert
class AlertDeleteRequested extends AlertsEvent {
  final String alertId;

  const AlertDeleteRequested(this.alertId);

  @override
  List<Object> get props => [alertId];
}

/// Alert types
enum AlertType {
  price,
  volume,
  news,
  technical,
}