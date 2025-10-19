import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/blocs.dart';
import 'presentation/routes/routes.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/themes/app_theme.dart';
import 'injection_container.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<OnboardingBloc>()..add(const OnboardingStatusRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<AuthenticationBloc>()
                ..add(const AuthenticationStatusRequested()),
        ),
        BlocProvider(create: (context) => getIt<NavigationBloc>()),
        BlocProvider(
          create: (context) =>
              getIt<ProfileBloc>()..add(const ProfileLoadRequested()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<AlertsBloc>()..add(const AlertsLoadRequested()),
        ),
        BlocProvider(create: (context) => getIt<AnchorWiseBloc>()),
        BlocProvider(create: (context) => getIt<ContactBloc>()),
        BlocProvider(create: (context) => getIt<FaqBloc>()),
      ],
      child: MaterialApp(
        title: 'AnchorWatch',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Automatically follows system theme
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, onboardingState) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, authState) {
                print('🏠 Main.dart - Auth status: ${authState.status}');

                if (onboardingState.status == OnboardingStatus.loading) {
                  return const _SplashScreen();
                }

                if (onboardingState.status == OnboardingStatus.notCompleted) {
                  return const OnboardingScreen();
                }

                switch (authState.status) {
                  case AuthenticationStatus.authenticated:
                    return const MainNavigationScreen();
                  case AuthenticationStatus.unauthenticated:
                    return const LoginScreen();
                  case AuthenticationStatus.loading:
                    return const LoginScreen(); // Stay on login during loading
                  case AuthenticationStatus.signUpSuccess:
                    return const LoginScreen(); // Redirect to login after successful signup
                  case AuthenticationStatus.unknown:
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

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.anchor, size: 120, color: Colors.white),
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
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
