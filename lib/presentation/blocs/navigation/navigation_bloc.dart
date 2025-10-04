import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

/// BLoC to manage navigation state across the app with intelligent stack management
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
    // Close any open drawer when navigation changes
    _closeDrawerIfOpen();
    
    final pageName = NavigationPageSelected.getPageName(event.pageIndex);
    final routeName = NavigationPageSelected.getRouteName(event.pageIndex);
    
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      
      // Create new stack entry
      final newEntry = NavigationStackEntry(
        pageIndex: event.pageIndex,
        routeName: routeName,
        timestamp: DateTime.now(),
      );
      
      // Smart stack management logic
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      
      // If navigating to dashboard, clear the stack
      if (event.pageIndex == 0) {
        updatedStack.clear();
      } else {
        // Check if the last entry is the same as the current navigation
        if (updatedStack.isNotEmpty && updatedStack.last.pageIndex == event.pageIndex) {
          // Don't add duplicate consecutive entries (prevents spamming)
          return;
        }
        
        // Remove any previous occurrences of this page from the stack
        // This prevents going back to the same page multiple times
        updatedStack.removeWhere((entry) => entry.pageIndex == event.pageIndex);
        
        // Add new entry to stack
        updatedStack.add(newEntry);
        
        // Limit stack size to prevent memory issues (optional)
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
      
      // Create new stack entry
      final newEntry = NavigationStackEntry(
        pageIndex: event.pageIndex,
        routeName: event.routeName,
        timestamp: DateTime.now(),
      );
      
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      
      // Check for duplicate consecutive entries
      if (updatedStack.isNotEmpty && updatedStack.last.pageIndex == event.pageIndex) {
        // Don't add duplicate consecutive entries
        return;
      }
      
      // Remove any previous occurrences of this page from the stack
      // This prevents going back to the same page multiple times
      updatedStack.removeWhere((entry) => entry.pageIndex == event.pageIndex);
      
      // Add new entry to stack
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
        
        // Determine where to go back to
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
      
      // Replace the current stack entry with the new one
      List<NavigationStackEntry> updatedStack = List.from(currentState.navigationStack);
      
      if (updatedStack.isNotEmpty) {
        // Remove the last entry and add the new one
        updatedStack.removeLast();
      }
      
      // Add new entry
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

  /// Check if we can go back in the navigation stack
  bool get canGoBack {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      return currentState.canGoBack;
    }
    return false;
  }

  /// Get current navigation stack
  List<NavigationStackEntry> get navigationStack {
    if (state is NavigationPageSelected) {
      final currentState = state as NavigationPageSelected;
      return currentState.navigationStack;
    }
    return [];
  }

  /// Close drawer if it's open - called during navigation changes
  void _closeDrawerIfOpen() {
    // We'll handle this in the navigation service instead to avoid circular imports
    // This is just a placeholder for now
  }
}