import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardInitialLoadEvent extends DashboardEvent {
  const DashboardInitialLoadEvent();
}

class DashboardRefreshEvent extends DashboardEvent {
  const DashboardRefreshEvent();
}

class DashboardTimePeriodChangedEvent extends DashboardEvent {
  final String timePeriod;
  
  const DashboardTimePeriodChangedEvent(this.timePeriod);
  
  @override
  List<Object?> get props => [timePeriod];
}