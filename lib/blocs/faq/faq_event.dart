import 'package:equatable/equatable.dart';

/// Events for the FaqBloc
abstract class FaqEvent extends Equatable {
  const FaqEvent();

  @override
  List<Object> get props => [];
}

/// Event to load FAQ information
class FaqLoadRequested extends FaqEvent {
  const FaqLoadRequested();
}

/// Event to refresh FAQ information
class FaqRefreshRequested extends FaqEvent {
  const FaqRefreshRequested();
}