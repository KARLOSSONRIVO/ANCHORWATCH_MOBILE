import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/onboarding/onboarding.dart';
import '../widgets/widgets.dart';
import 'app_router.dart';
import 'app_routes.dart';

class RouteGuard extends StatelessWidget {
  const RouteGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listener: (context, state) {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (state.status == OnboardingStatus.completed) {
              if (currentRoute == AppRoutes.onboarding) {
                AppRouter.navigateToLogin(context);
              }
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                if (currentRoute == AppRoutes.login ||
                    currentRoute == AppRoutes.splash) {
                  AppRouter.navigateToHome(context);
                }
                break;

              case AuthenticationStatus.unauthenticated:
                if (AppRouter.isProtectedRoute(currentRoute)) {
                  AppRouter.navigateToLogin(context);
                }
                break;

              case AuthenticationStatus.loading:
                break;

              case AuthenticationStatus.signUpSuccess:
                if (currentRoute != AppRoutes.login) {
                  AppRouter.navigateToLogin(context);
                }
                break;

              case AuthenticationStatus.unknown:
                break;
            }
          },
        ),
      ],
      child: child,
    );
  }
}

class NavigationHelper {
  static void showMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    SnackBarHelper.show(context, message, isError: isError);
  }

  static void showSuccess(BuildContext context, String message) {
    SnackBarHelper.showSuccess(context, message);
  }

  static void showError(BuildContext context, String message) {
    SnackBarHelper.showError(context, message);
  }

  static void showWarning(BuildContext context, String message) {
    SnackBarHelper.showWarning(context, message);
  }

  static void showInfo(BuildContext context, String message) {
    SnackBarHelper.showInfo(context, message);
  }

  static void showLogoutLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

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
