import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication/authentication.dart';
import '../blocs/password_reset/password_reset.dart';
import '../blocs/signup/signup.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/main_navigation_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/faq_screen.dart';
import '../screens/password_reset/reset_password_email_screen.dart';
import '../screens/password_reset/reset_password_otp_screen.dart';
import '../screens/password_reset/reset_password_confirm_screen.dart';
import '../screens/profile/change_password_screen.dart';
import '../screens/profile/change_username_screen.dart';
import '../screens/profile/change_email_screen.dart';
import '../screens/profile/confirm_change_email_screen.dart';
import '../../injection_container.dart';
import 'app_routes.dart';

class AppRouter {
  static PasswordResetBloc? _passwordResetBloc;
  static PasswordResetBloc _getPasswordResetBloc() {
    _passwordResetBloc ??= getIt<PasswordResetBloc>();
    return _passwordResetBloc!;
  }

  static void clearPasswordResetBloc() {
    _passwordResetBloc?.close();
    _passwordResetBloc = null;
  }

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
          builder: (_) => BlocProvider(
            create: (context) => getIt<SignUpBloc>(),
            child: const SignUpScreen(),
          ),
          settings: settings,
        );
      case AppRoutes.dashboard:
      case AppRoutes.discover:
      case AppRoutes.anchorwise:
      case AppRoutes.alerts:
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
          settings: settings,
        );

      case AppRoutes.contact:
        return MaterialPageRoute(
          builder: (_) => const ContactScreen(),
          settings: settings,
        );

      case AppRoutes.faq:
        return MaterialPageRoute(
          builder: (_) => const FaqScreen(),
          settings: settings,
        );

      case AppRoutes.resetPasswordEmail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _getPasswordResetBloc(),
            child: const ResetPasswordEmailScreen(),
          ),
          settings: settings,
        );

      case AppRoutes.resetPasswordOtp:
        final email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _getPasswordResetBloc(),
            child: ResetPasswordOtpScreen(email: email),
          ),
          settings: settings,
        );

      case AppRoutes.resetPasswordConfirm:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _getPasswordResetBloc(),
            child: const ResetPasswordConfirmScreen(),
          ),
          settings: settings,
        );

      case AppRoutes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePasswordScreen(),
          settings: settings,
        );

      case AppRoutes.changeUsername:
        return MaterialPageRoute(
          builder: (_) => const ChangeUsernameScreen(),
          settings: settings,
        );

      case AppRoutes.requestChangeEmail:
        return MaterialPageRoute(
          builder: (_) => const ChangeEmailScreen(),
          settings: settings,
        );

      case AppRoutes.confirmChangeEmail:
        final newEmail = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => ConfirmChangeEmailScreen(newEmail: newEmail),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => _UnknownRouteScreen(routeName: settings.name),
          settings: settings,
        );
    }
  }

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

  static bool isProtectedRoute(String? route) {
    return AppRoutes.protectedRoutes.contains(route);
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.onboarding, (route) => false);
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.dashboard, // Navigate to dashboard instead of home
      (route) => false,
    );
  }
}

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
            Icon(Icons.anchor, size: 120, color: Colors.white),
            const SizedBox(height: 24),
            Text(
              'AnchorWatch',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

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
            Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              '404 - Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Route "${routeName ?? 'unknown'}" does not exist.',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
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
