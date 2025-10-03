import 'package:equatable/equatable.dart';

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

  const NavigationPageSelected({
    required this.currentIndex,
    required this.pageName,
  });

  @override
  List<Object> get props => [currentIndex, pageName];

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
}