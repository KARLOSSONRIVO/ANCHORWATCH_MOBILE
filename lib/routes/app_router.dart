import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/main_navigation_screen.dart';
import 'app_routes.dart';

/// Main app router that handles navigation and route generation
class AppRouter {
  /// Generate routes based on settings and authentication state
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const _SplashScreen(),
          settings: settings,
        );
        
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
        
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
        
      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
          settings: settings,
        );
        
      // All main navigation routes point to the same screen
      case AppRoutes.dashboard:
      case AppRoutes.discover:
      case AppRoutes.anchorwise:
      case AppRoutes.alerts:
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );
        
      default:
        return MaterialPageRoute(
          builder: (_) => _UnknownRouteScreen(routeName: settings.name),
          settings: settings,
        );
    }
  }
  
  /// Navigate to route based on authentication status
  static String getInitialRoute(AuthenticationStatus status) {
    switch (status) {
      case AuthenticationStatus.authenticated:
        return AppRoutes.dashboard; // Start at dashboard instead of home
      case AuthenticationStatus.unauthenticated:
        return AppRoutes.login;
      case AuthenticationStatus.loading:
        return AppRoutes.login; // Stay on login during loading
      case AuthenticationStatus.signUpSuccess:
        return AppRoutes.login; // Redirect to login after successful signup
      case AuthenticationStatus.unknown:
        return AppRoutes.splash;
    }
  }
  
  /// Check if route requires authentication
  static bool isProtectedRoute(String? route) {
    return AppRoutes.protectedRoutes.contains(route);
  }
  
  /// Navigation helpers
  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.onboarding,
      (route) => false,
    );
  }
  
  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }
  
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.dashboard, // Navigate to dashboard instead of home
      (route) => false,
    );
  }
}

/// Splash screen widget (moved from main.dart for better organization)
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.anchor,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'AnchorWatch',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            Text(
              'Initializing...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Screen shown for unknown/unhandled routes
class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({required this.routeName});
  
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Route "${routeName ?? 'unknown'}" does not exist.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                final authState = context.read<AuthenticationBloc>().state;
                if (authState.status == AuthenticationStatus.authenticated) {
                  AppRouter.navigateToHome(context);
                } else {
                  AppRouter.navigateToLogin(context);
                }
              },
              icon: const Icon(Icons.home),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}