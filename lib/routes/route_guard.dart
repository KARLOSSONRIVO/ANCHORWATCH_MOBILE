import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import 'app_router.dart';
import 'app_routes.dart';

/// Route guard that handles authentication-based navigation
class RouteGuard extends StatelessWidget {
  const RouteGuard({
    super.key,
    required this.child,
  });
  
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        final currentRoute = ModalRoute.of(context)?.settings.name;
        
        // Handle authentication state changes
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            // If user is authenticated but on login screen, navigate to home
            if (currentRoute == AppRoutes.login || currentRoute == AppRoutes.splash) {
              AppRouter.navigateToHome(context);
            }
            break;
            
          case AuthenticationStatus.unauthenticated:
            // If user is unauthenticated and on a protected route, navigate to login
            if (AppRouter.isProtectedRoute(currentRoute)) {
              AppRouter.navigateToLogin(context);
            }
            break;
            
          case AuthenticationStatus.unknown:
            // Handle loading states if needed
            break;
        }
      },
      child: child,
    );
  }
}

/// Navigation wrapper that provides easy access to navigation methods
class NavigationHelper {
  /// Show snackbar message
  static void showMessage(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  /// Show loading dialog
  static void showLoading(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
    );
  }
  
  /// Hide loading dialog
  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  
  /// Confirm logout action
  static Future<bool> confirmLogout(BuildContext context) async {
    final result = await showDialog<bool>(
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
    
    return result ?? false;
  }
}