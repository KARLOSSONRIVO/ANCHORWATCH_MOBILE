import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'routes/routes.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => OnboardingBloc()
            ..add(const OnboardingStatusRequested()),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc()
            ..add(const AuthenticationStatusRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'AnchorWatch',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
          fontFamily: 'Inter',
          textTheme: const TextTheme().apply(
            fontFamily: 'Inter',
          ),
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, onboardingState) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, authState) {
                print('🏗️ Building app - Onboarding: ${onboardingState.status}, Auth: ${authState.status}');
                
                // Check onboarding first - only show splash on initial load
                if (onboardingState.status == OnboardingStatus.loading) {
                  return const _SplashScreen();
                }
                
                // If onboarding not completed, show onboarding
                if (onboardingState.status == OnboardingStatus.notCompleted) {
                  return const OnboardingScreen();
                }
                
                // Onboarding completed, check authentication
                switch (authState.status) {
                  case AuthenticationStatus.authenticated:
                    return const HomeScreen();
                  case AuthenticationStatus.unauthenticated:
                    return const LoginScreen();
                  case AuthenticationStatus.unknown:
                    // Only show splash on app startup, not during login
                    if (onboardingState.status == OnboardingStatus.loading) {
                      return const _SplashScreen();
                    } else {
                      return const LoginScreen(); // Stay on login during loading
                    }
                }
              },
            );
          },
        ),
      ),
    );
  }
}

/// Splash screen shown while checking authentication status
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