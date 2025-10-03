import 'package:equatable/equatable.dart';

/// Events for the NavigationBloc
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

/// Event to change the current page
class NavigationPageChanged extends NavigationEvent {
  final int pageIndex;

  const NavigationPageChanged(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}

/// Event to reset navigation to home
class NavigationReset extends NavigationEvent {
  const NavigationReset();
}