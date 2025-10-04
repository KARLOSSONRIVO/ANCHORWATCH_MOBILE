import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_event.dart';
import '../blocs/navigation/navigation_state.dart';
import '../blocs/authentication/authentication.dart';
import '../widgets/custom_snackbar.dart';
import '../routes/app_routes.dart';

/// Global keys for each screen's scaffold to manage drawer state
class DrawerKeys {
  static final GlobalKey<ScaffoldState> dashboardKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> discoverKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> anchorwiseKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> alertsKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> profileKey = GlobalKey<ScaffoldState>();
  
  /// Get all drawer keys
  static List<GlobalKey<ScaffoldState>> get allKeys => [
        dashboardKey,
        discoverKey,
        anchorwiseKey,
        alertsKey,
        profileKey,
      ];
}

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
    // Close all open drawers before navigation
    _closeAllDrawers();
    
    // Use NavigationBloc to handle the navigation
    context.read<NavigationBloc>().add(
      NavigationPageChanged(destination.tabIndex),
    );
  }
  
  /// Close all open drawers across all screens
  static void _closeAllDrawers() {
    for (final key in DrawerKeys.allKeys) {
      try {
        final scaffoldState = key.currentState;
        if (scaffoldState != null && scaffoldState.isDrawerOpen) {
          scaffoldState.closeDrawer();
        }
      } catch (e) {
        // Silently handle any state-related errors
        print('Debug: Could not close drawer for key: $e');
      }
    }
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
    switch (action) {
      case 'contact_support':
        _closeAllDrawers();
        Navigator.of(context).pushNamed(AppRoutes.contact);
        break;
      case 'faqs':
        _closeAllDrawers();
        Navigator.of(context).pushNamed(AppRoutes.faq);
        break;
      case 'logout':
        await _handleLogout(context);
        break;
      default:
        SnackBarHelper.showWarning(context, 'Unknown action: $action');
    }
  }

  /// Handle logout directly in NavigationService to avoid context issues
  static Future<void> _handleLogout(BuildContext context) async {
    // First, get all required references while context is valid
    final authBloc = context.read<AuthenticationBloc>();
    
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      // Close all drawers
      _closeAllDrawers();
      
      // Trigger logout directly
      authBloc.add(const AuthenticationLogoutRequested());
      
      // Show success message using custom snackbar
      SnackBarHelper.showSuccess(
        context,
        'Logged out successfully',
        duration: const Duration(seconds: 2),
      );
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

  /// Navigate to Contact screen
  /// Use this method to programmatically navigate to the Contact screen with BLoC integration
  static void navigateToContact(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.contact);
  }

  /// Navigate to FAQ screen
  /// Use this method to programmatically navigate to the FAQ screen with BLoC integration
  static void navigateToFaq(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.faq);
  }
}