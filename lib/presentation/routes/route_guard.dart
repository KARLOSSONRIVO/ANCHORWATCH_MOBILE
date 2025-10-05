import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/onboarding/onboarding.dart';
import '../widgets/widgets.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            
            // Handle onboarding completion
            if (state.status == OnboardingStatus.completed) {
              // If onboarding completed and we're on onboarding screen, navigate to login
              if (currentRoute == AppRoutes.onboarding) {
                AppRouter.navigateToLogin(context);
              }
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
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
                
              case AuthenticationStatus.loading:
                // Handle loading states - stay on current screen
                break;
                
              case AuthenticationStatus.signUpSuccess:
                // After successful signup, navigate to login
                if (currentRoute != AppRoutes.login) {
                  AppRouter.navigateToLogin(context);
                }
                break;
                
              case AuthenticationStatus.unknown:
                // Handle unknown states if needed
                break;
            }
          },
        ),
      ],
      child: child,
    );
  }
}

/// Navigation wrapper that provides easy access to navigation methods
class NavigationHelper {
  /// Show snackbar message using custom snackbar
  static void showMessage(BuildContext context, String message, {bool isError = false}) {
    SnackBarHelper.show(context, message, isError: isError);
  }

  /// Show success message
  static void showSuccess(BuildContext context, String message) {
    SnackBarHelper.showSuccess(context, message);
  }

  /// Show error message
  static void showError(BuildContext context, String message) {
    SnackBarHelper.showError(context, message);
  }

  /// Show warning message
  static void showWarning(BuildContext context, String message) {
    SnackBarHelper.showWarning(context, message);
  }

  /// Show info message
  static void showInfo(BuildContext context, String message) {
    SnackBarHelper.showInfo(context, message);
  }

  /// DEPRECATED: Handle complete logout process with confirmation, loading screen and success message
  /// This method is no longer used - logout is now handled directly in NavigationService
  @deprecated
  static Future<void> handleLogout(BuildContext context) async {
    throw UnimplementedError('This method is deprecated. Use NavigationService._handleLogout instead.');
  }

  /// Show logout loading dialog with specific styling
  static void showLogoutLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Logging out...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait while we securely log you out.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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