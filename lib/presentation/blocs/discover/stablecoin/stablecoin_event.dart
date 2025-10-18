import 'package:equatable/equatable.dart';
abstract class StablecoinEvent extends Equatable {
  const StablecoinEvent();

  @override
  List<Object> get props => [];
}
class StablecoinInitializeRequested extends StablecoinEvent {
  const StablecoinInitializeRequested();
}
class StablecoinRefreshRequested extends StablecoinEvent {
  const StablecoinRefreshRequested();
}
class StablecoinAggregationPeriodChanged extends StablecoinEvent {
  final String period;

  const StablecoinAggregationPeriodChanged(this.period);

  @override
  List<Object> get props => [period];
}
