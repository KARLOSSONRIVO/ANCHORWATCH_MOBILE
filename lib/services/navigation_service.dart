import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/blocs/navigation/navigation_bloc.dart';
import '../presentation/blocs/navigation/navigation_event.dart';
import '../presentation/blocs/navigation/navigation_state.dart';
import '../presentation/blocs/authentication/authentication.dart';
import '../presentation/widgets/custom_snackbar.dart';
import '../presentation/routes/app_routes.dart';

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

class NavigationService {
  static final GlobalKey<ScaffoldState> mainScaffoldKey =
      GlobalKey<ScaffoldState>();
  static void navigateToTab(BuildContext context, NavigationIndex destination) {
    _closeCurrentDrawer(context);
    context.read<NavigationBloc>().add(
      NavigationPageChanged(destination.tabIndex),
    );
  }

  static void _closeCurrentDrawer(BuildContext context) {
    try {
      if (mainScaffoldKey.currentState != null &&
          mainScaffoldKey.currentState!.isDrawerOpen) {
        mainScaffoldKey.currentState!.closeDrawer();
        return;
      }
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.of(context).pop();
      }
    } catch (_) {}
  }

  static void forceCloseDrawer() {
    try {
      if (mainScaffoldKey.currentState != null &&
          mainScaffoldKey.currentState!.isDrawerOpen) {
        mainScaffoldKey.currentState!.closeDrawer();
      }
    } catch (_) {}
  }

  static void navigateToTabWithPush(
    BuildContext context,
    NavigationIndex destination,
  ) {
    _closeCurrentDrawer(context);

    final routeName = _getRouteNameForIndex(destination.tabIndex);
    context.read<NavigationBloc>().add(
      NavigationStackPush(destination.tabIndex, routeName),
    );
  }

  static void goBack(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    if (navigationBloc.canGoBack) {
      context.read<NavigationBloc>().add(const NavigationStackPop());
    }
  }

  static void replaceCurrentNavigation(
    BuildContext context,
    NavigationIndex destination,
  ) {
    _closeCurrentDrawer(context);

    final routeName = _getRouteNameForIndex(destination.tabIndex);
    context.read<NavigationBloc>().add(
      NavigationStackReplace(destination.tabIndex, routeName),
    );
  }

  static String _getRouteNameForIndex(int index) {
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

  static void navigateToIndex(BuildContext context, int index) {
    final destination = NavigationIndex.fromIndex(index);
    navigateToTab(context, destination);
  }

  static void handleMainNavigation(
    BuildContext context,
    NavigationIndex destination,
  ) {
    switch (destination) {
      case NavigationIndex.dashboard:
        navigateToTab(context, NavigationIndex.dashboard);
        break;
      case NavigationIndex.discover:
        navigateToTab(context, NavigationIndex.discover);
        break;
      case NavigationIndex.anchorwise:
        navigateToTab(context, NavigationIndex.anchorwise);
        break;
      case NavigationIndex.alerts:
        navigateToTab(context, NavigationIndex.alerts);
        break;
      case NavigationIndex.profile:
        navigateToTab(context, NavigationIndex.profile);
        break;
    }
  }

  static Future<void> handleSpecialNavigation(
    BuildContext context,
    String action,
  ) async {
    switch (action) {
      case 'contact_support':
        _closeCurrentDrawer(context);
        Navigator.of(context).pushNamed(AppRoutes.contact);
        break;
      case 'faqs':
        _closeCurrentDrawer(context);
        Navigator.of(context).pushNamed(AppRoutes.faq);
        break;
      case 'logout':
        await _handleLogout(context);
        break;
      default:
        SnackBarHelper.showWarning(context, 'Unknown action: $action');
    }
  }

  static Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Confirm Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 14, fontFamily: 'Inter'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      final authBloc = context.read<AuthenticationBloc>();
      final navigationBloc = context.read<NavigationBloc>();

      _closeCurrentDrawer(context);

      navigationBloc.add(const NavigationReset());

      authBloc.add(const AuthenticationLogoutRequested());
    }
  }

  static int getCurrentIndex(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    final state = navigationBloc.state;
    if (state is NavigationPageSelected) {
      return state.currentIndex;
    }
    return 0; // Default to dashboard
  }

  static bool canGoBack(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    return navigationBloc.canGoBack;
  }

  static List<NavigationStackEntry> getNavigationStack(BuildContext context) {
    final navigationBloc = context.read<NavigationBloc>();
    return navigationBloc.navigationStack;
  }

  static void resetToHome(BuildContext context) {
    context.read<NavigationBloc>().add(const NavigationReset());
  }

  static void navigateToContact(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.contact);
  }

  static void navigateToFaq(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.faq);
  }
}
