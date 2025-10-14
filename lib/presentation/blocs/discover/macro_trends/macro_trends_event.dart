import 'package:equatable/equatable.dart';

/// Events for the MacroTrends BLoC
abstract class MacroTrendsEvent extends Equatable {
  const MacroTrendsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load macro trends data
class MacroTrendsLoadRequested extends MacroTrendsEvent {
  const MacroTrendsLoadRequested();
}

/// Event to refresh macro trends data
class MacroTrendsRefreshRequested extends MacroTrendsEvent {
  const MacroTrendsRefreshRequested();
}

/// Event to change aggregation period
class MacroTrendsAggregationPeriodChanged extends MacroTrendsEvent {
  final String period;

  const MacroTrendsAggregationPeriodChanged(this.period);

  @override
  List<Object> get props => [period];
}