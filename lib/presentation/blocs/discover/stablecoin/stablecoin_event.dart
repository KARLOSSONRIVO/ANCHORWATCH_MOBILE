import 'package:equatable/equatable.dart';

/// Events for the Stablecoin BLoC
abstract class StablecoinEvent extends Equatable {
  const StablecoinEvent();

  @override
  List<Object> get props => [];
}

/// Event to initialize stablecoin data
class StablecoinInitializeRequested extends StablecoinEvent {
  const StablecoinInitializeRequested();
}

/// Event to refresh stablecoin data
class StablecoinRefreshRequested extends StablecoinEvent {
  const StablecoinRefreshRequested();
}

/// Event to change aggregation period
class StablecoinAggregationPeriodChanged extends StablecoinEvent {
  final String period;

  const StablecoinAggregationPeriodChanged(this.period);

  @override
  List<Object> get props => [period];
}