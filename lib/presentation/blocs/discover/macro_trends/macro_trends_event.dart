import 'package:equatable/equatable.dart';
abstract class MacroTrendsEvent extends Equatable {
  const MacroTrendsEvent();

  @override
  List<Object> get props => [];
}
class MacroTrendsLoadRequested extends MacroTrendsEvent {
  const MacroTrendsLoadRequested();
}
class MacroTrendsRefreshRequested extends MacroTrendsEvent {
  const MacroTrendsRefreshRequested();
}
class MacroTrendsAggregationPeriodChanged extends MacroTrendsEvent {
  final String period;

  const MacroTrendsAggregationPeriodChanged(this.period);

  @override
  List<Object> get props => [period];
}
