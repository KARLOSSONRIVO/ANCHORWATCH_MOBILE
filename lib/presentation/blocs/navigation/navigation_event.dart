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

/// Event to push a new navigation page to the stack
class NavigationStackPush extends NavigationEvent {
  final int pageIndex;
  final String routeName;

  const NavigationStackPush(this.pageIndex, this.routeName);

  @override
  List<Object> get props => [pageIndex, routeName];
}

/// Event to pop from navigation stack
class NavigationStackPop extends NavigationEvent {
  const NavigationStackPop();
}

/// Event to replace current navigation stack entry
class NavigationStackReplace extends NavigationEvent {
  final int pageIndex;
  final String routeName;

  const NavigationStackReplace(this.pageIndex, this.routeName);

  @override
  List<Object> get props => [pageIndex, routeName];
}