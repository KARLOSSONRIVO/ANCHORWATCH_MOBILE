import 'package:equatable/equatable.dart';
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}
class NavigationPageChanged extends NavigationEvent {
  final int pageIndex;

  const NavigationPageChanged(this.pageIndex);

  @override
  List<Object> get props => [pageIndex];
}
class NavigationReset extends NavigationEvent {
  const NavigationReset();
}
class NavigationStackPush extends NavigationEvent {
  final int pageIndex;
  final String routeName;

  const NavigationStackPush(this.pageIndex, this.routeName);

  @override
  List<Object> get props => [pageIndex, routeName];
}
class NavigationStackPop extends NavigationEvent {
  const NavigationStackPop();
}
class NavigationStackReplace extends NavigationEvent {
  final int pageIndex;
  final String routeName;

  const NavigationStackReplace(this.pageIndex, this.routeName);

  @override
  List<Object> get props => [pageIndex, routeName];
}
