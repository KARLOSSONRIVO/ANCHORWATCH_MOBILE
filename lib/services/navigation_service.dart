import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';
import '../widgets/custom_snackbar.dart';
import '../routes/route_guard.dart';

/// Navigation indices enum for better type safety
enum NavigationIndex {
  dashboard(0, 'Dashboard'),
  discover(1, 'Discover'),
  anchorwise(2, 'AnchorWise'),
  alerts(3, 'Alerts'),
  profile(4, 'Profile');

  const NavigationIndex(this.tabIndex, this.displayName);
  final int tabIndex;
  final String displayName;

  static NavigationIndex fromIndex(int index) {
    return NavigationIndex.values.firstWhere(
      (nav) => nav.tabIndex == index,
      orElse: () => NavigationIndex.dashboard,
    );
  }
}

/// Unified navigation service that handles navigation for both bottom nav and drawer
/// This ensures consistent navigation behavior and prevents stacking issues
class NavigationService {
  /// Navigate to a specific tab/screen using the NavigationBloc
  /// This method should be used by both bottom navigation and drawer navigation
  static void navigateToTab(BuildContext context, NavigationIndex destination) {
    // Safely close drawer if open
    try {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Ignore scaffold errors when called from bottom nav context
    }
    
    // Use NavigationBloc to handle the navigation
    context.read<NavigationBloc>().add(
      NavigationPageChanged(destination.tabIndex),
    );
  }

  /// Navigate to a specific tab by index (for backward compatibility)
  static void navigateToIndex(BuildContext context, int index) {
    final destination = NavigationIndex.fromIndex(index);
    navigateToTab(context, destination);
  }

  /// Handle navigation for main app sections (dashboard, discover, etc.)
  static void handleMainNavigation(BuildContext context, NavigationIndex destination) {
    switch (destination) {
      case NavigationIndex.dashboard:
        navigateToTab(context, NavigationIndex.dashboard);
        break;
      case NavigationIndex.discover:
        navigateToTab(context, NavigationIndex.discover);
        // Show coming soon message
        SnackBarHelper.showInfo(context, 'Discover feature coming soon!');
        break;
      case NavigationIndex.anchorwise:
        navigateToTab(context, NavigationIndex.anchorwise);
        // Show coming soon message  
        SnackBarHelper.showInfo(context, 'AnchorWise coming soon!');
        break;
      case NavigationIndex.alerts:
        navigateToTab(context, NavigationIndex.alerts);
        // Show coming soon message
        SnackBarHelper.showInfo(context, 'Alerts system coming soon!');
        break;
      case NavigationIndex.profile:
        navigateToTab(context, NavigationIndex.profile);
        break;
    }
  }

  /// Handle special navigation actions (non-main navigation items)
  static Future<void> handleSpecialNavigation(BuildContext context, String action) async {
    // Safely close drawer if open
    try {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Ignore scaffold errors when called from non-drawer context
    }

    switch (action) {
      case 'contact_support':
        SnackBarHelper.showInfo(context, 'Contact support coming soon!');
        break;
      case 'faqs':
        SnackBarHelper.showInfo(context, 'FAQs coming soon!');
        break;
      case 'logout':
        await NavigationHelper.handleLogout(context);
        break;
      default:
        SnackBarHelper.showWarning(context, 'Unknown action: $action');
    }
  }

  /// Get the current navigation index from NavigationBloc state
  static int getCurrentIndex(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final state = navigationBloc.state;
    
    if (state is NavigationPageSelected) {
      return state.currentIndex;
    }
    return 0; // Default to dashboard
  }

  /// Reset navigation to dashboard
  static void resetToHome(BuildContext context) {
    context.read<NavigationBloc>().add(const NavigationReset());
  }
}