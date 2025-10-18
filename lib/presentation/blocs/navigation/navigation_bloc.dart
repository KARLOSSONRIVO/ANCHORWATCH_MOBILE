import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';
@injectable
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationPageSelected(
    currentIndex: 0, 
    pageName: 'Dashboard',
    navigationStack: [],
    canGoBack: false,
  )) {
    on<NavigationPageChanged>(_onNavigationPageChanged);
    on<NavigationReset>(_onNavigationReset);
    on<NavigationStackPush>(_onNavigationStackPush);
    on<NavigationStackPop>(_onNavigationStackPop);
    on<NavigationStackReplace>(_onNavigationStackReplace);
  }

  void _onNavigationPageChanged(
    NavigationPageChanged event,
    Emitter<NavigationState> emit,
  ) {
    _closeDrawerIfOpen();
    
    final pageName = NavigationPageSelected.getPageName(event.pageIndex);
    final routeName = NavigationPageSelected.getRouteName(event.pageIndex);
    
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      final newEntry = NavigationStackEntry(
        pageIndex: event.pageIndex,
        routeName: routeName,
        timestamp: DateTime.now(),
      );
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      if (event.pageIndex == 0) {
        updatedStack.clear();
      } else {
        if (updatedStack.isNotEmpty && updatedStack.last.pageIndex == event.pageIndex) {
          return;
        }
        updatedStack.removeWhere((entry) => entry.pageIndex == event.pageIndex);
        updatedStack.add(newEntry);
        if (updatedStack.length > 10) {
          updatedStack.removeAt(0);
        }
      }
      
      emit(NavigationPageSelected(
        currentIndex: event.pageIndex,
        pageName: pageName,
        navigationStack: updatedStack,
        canGoBack: updatedStack.isNotEmpty,
      ));
    }
  }

  void _onNavigationStackPush(
    NavigationStackPush event,
    Emitter<NavigationState> emit,
  ) {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      final pageName = NavigationPageSelected.getPageName(event.pageIndex);
      final newEntry = NavigationStackEntry(
        pageIndex: event.pageIndex,
        routeName: event.routeName,
        timestamp: DateTime.now(),
      );
      
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      if (updatedStack.isNotEmpty && updatedStack.last.pageIndex == event.pageIndex) {
        return;
      }
      updatedStack.removeWhere((entry) => entry.pageIndex == event.pageIndex);
      updatedStack.add(newEntry);
      
      emit(currentState.copyWith(
        currentIndex: event.pageIndex,
        pageName: pageName,
        navigationStack: updatedStack,
        canGoBack: true,
      ));
    }
  }

  void _onNavigationStackPop(
    NavigationStackPop event,
    Emitter<NavigationState> emit,
  ) {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      
      if (currentState.navigationStack.isNotEmpty) {
        List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
        updatedStack.removeLast();
        int targetIndex = 0; // Default to dashboard
        String targetPageName = 'Dashboard';
        
        if (updatedStack.isNotEmpty) {
          final previousEntry = updatedStack.last;
          targetIndex = previousEntry.pageIndex;
          targetPageName = NavigationPageSelected.getPageName(targetIndex);
        }
        
        emit(currentState.copyWith(
          currentIndex: targetIndex,
          pageName: targetPageName,
          navigationStack: updatedStack,
          canGoBack: updatedStack.isNotEmpty,
        ));
      }
    }
  }

  void _onNavigationStackReplace(
    NavigationStackReplace event,
    Emitter<NavigationState> emit,
  ) {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      final pageName = NavigationPageSelected.getPageName(event.pageIndex);
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      
      if (updatedStack.isNotEmpty) {
        updatedStack.removeLast();
      }
      final newEntry = NavigationStackEntry(
        pageIndex: event.pageIndex,
        routeName: event.routeName,
        timestamp: DateTime.now(),
      );
      updatedStack.add(newEntry);
      
      emit(currentState.copyWith(
        currentIndex: event.pageIndex,
        pageName: pageName,
        navigationStack: updatedStack,
        canGoBack: updatedStack.isNotEmpty,
      ));
    }
  }

  void _onNavigationReset(
    NavigationReset event,
    Emitter<NavigationState> emit,
  ) {
    emit(const NavigationPageSelected(
      currentIndex: 0, 
      pageName: 'Dashboard',
      navigationStack: [],
      canGoBack: false,
    ));
  }
  bool get canGoBack {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      return currentState.canGoBack;
    }
    return false;
  }
  List<NavigationStackEntry> get navigationStack {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      return currentState.navigationStack;
    }
    return [];
  }
  void _closeDrawerIfOpen() {
  }
}
