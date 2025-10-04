import 'package:equatable/equatable.dart';

/// Navigation stack entry to track navigation history
class NavigationStackEntry extends Equatable {
  final int pageIndex;
  final String routeName;
  final DateTime timestamp;

  const NavigationStackEntry({
    required this.pageIndex,
    required this.routeName,
    required this.timestamp,
  });

  @override
  List<Object> get props => [pageIndex, routeName, timestamp];
}

/// States for the NavigationBloc
abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

/// Initial state of navigation
class NavigationInitial extends NavigationState {
  const NavigationInitial();
}

/// State when a specific page is selected
class NavigationPageSelected extends NavigationState {
  final int currentIndex;
  final String pageName;
  final List<NavigationStackEntry> navigationStack;
  final bool canGoBack;

  const NavigationPageSelected({
    required this.currentIndex,
    required this.pageName,
    this.navigationStack = const [],
    this.canGoBack = false,
  });

  @override
  List<Object> get props => [currentIndex, pageName, navigationStack, canGoBack];

  /// Create a new state with updated navigation stack
  NavigationPageSelected copyWith({
    int? currentIndex,
    String? pageName,
    List<NavigationStackEntry>? navigationStack,
    bool? canGoBack,
  }) {
    return NavigationPageSelected(
      currentIndex: currentIndex ?? this.currentIndex,
      pageName: pageName ?? this.pageName,
      navigationStack: navigationStack ?? this.navigationStack,
      canGoBack: canGoBack ?? this.canGoBack,
    );
  }

  /// Get page name from index
  static String getPageName(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Discover';
      case 2:
        return 'AnchorWise';
      case 3:
        return 'Alerts';
      case 4:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  /// Get route name from index
  static String getRouteName(int index) {
    switch (index) {
      case 0:
        return '/dashboard';
      case 1:
        return '/discover';
      case 2:
        return '/anchorwise';
      case 3:
        return '/alerts';
      case 4:
        return '/profile';
      default:
        return '/dashboard';
    }
  }
}