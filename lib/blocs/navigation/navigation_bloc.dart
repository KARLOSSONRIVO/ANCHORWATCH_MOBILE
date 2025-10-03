import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

/// BLoC to manage navigation state across the app
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationPageSelected(currentIndex: 0, pageName: 'Dashboard')) {
    on<NavigationPageChanged>(_onNavigationPageChanged);
    on<NavigationReset>(_onNavigationReset);
  }

  void _onNavigationPageChanged(
    NavigationPageChanged event,
    Emitter<NavigationState> emit,
  ) {
    final pageName = NavigationPageSelected.getPageName(event.pageIndex);
    emit(NavigationPageSelected(
      currentIndex: event.pageIndex,
      pageName: pageName,
    ));
  }

  void _onNavigationReset(
    NavigationReset event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationPageSelected(currentIndex: 0, pageName: 'Dashboard'));
  }
}