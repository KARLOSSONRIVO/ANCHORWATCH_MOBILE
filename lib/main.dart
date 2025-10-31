import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/blocs.dart';
import 'presentation/routes/routes.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/maintenance_screen.dart';
import 'presentation/themes/app_theme.dart';
import 'injection_container.dart';
import 'services/storage_service.dart';
import 'services/dio_client.dart';
import 'services/maintenance_service.dart';
import 'services/maintenance_monitor.dart';
import 'domain/entities/maintenance_status.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MaintenanceStatus? _maintenanceStatus;
  late final MaintenanceMonitor _maintenanceMonitor;
  late final MaintenanceService _maintenanceService;

  @override
  void initState() {
    super.initState();
    _maintenanceService = getIt<MaintenanceService>();
    _maintenanceMonitor = getIt<MaintenanceMonitor>();
    
    // Set up listener for maintenance mode changes
    _maintenanceMonitor.onMaintenanceModeChanged = (status) {
      setState(() {
        _maintenanceStatus = status;
      });
    };
    
    // Check maintenance status on app start
    _checkMaintenanceStatus();
    
    // Start monitoring maintenance mode
    _maintenanceMonitor.startMonitoring();
  }

  Future<void> _checkMaintenanceStatus() async {
    try {
      final status = await _maintenanceService.checkMaintenanceStatus(forceRefresh: true);
      if (mounted) {
        setState(() {
          _maintenanceStatus = status;
        });
      }
    } catch (e) {
      debugPrint('Error checking maintenance status: $e');
    }
  }

  @override
  void dispose() {
    _maintenanceMonitor.dispose();
    super.dispose();
  }

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
      child: Builder(
        builder: (context) {
          // Set global context for DioClient
          DioClient.setGlobalContext(context);

          return BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              // Handle navigation when authentication state changes
              if (state.status == AuthenticationStatus.unauthenticated) {
                // Force navigation to login screen
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                });
              } else if (state.status == AuthenticationStatus.sessionExpired) {
                // Clear any error messages when session expires
                context.read<AuthenticationBloc>().add(
                  const AuthenticationErrorCleared(),
                );
              }
            },
            child: MaterialApp(
              title: 'AnchorWatch',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system, // Automatically follows system theme
              navigatorObservers: [_MaintenanceNavigatorObserver(_maintenanceStatus)],
              onGenerateRoute: (settings) {
                // Block all routes if in maintenance mode
                if (_maintenanceStatus?.isMaintenanceMode == true) {
                  return MaterialPageRoute(
                    builder: (_) => MaintenanceScreen(status: _maintenanceStatus!),
                    settings: settings,
                  );
                }
                return AppRouter.generateRoute(settings);
              },
              home: _maintenanceStatus?.isMaintenanceMode == true
                  ? MaintenanceScreen(status: _maintenanceStatus!)
                  : BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, onboardingState) {
                  return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, authState) {
                      if (onboardingState.status == OnboardingStatus.loading) {
                        return const _SplashScreen();
                      }

                      if (onboardingState.status ==
                          OnboardingStatus.notCompleted) {
                        return const OnboardingScreen();
                      }

                      switch (authState.status) {
                        case AuthenticationStatus.authenticated:
                          return const RouteGuard(
                            child: MainNavigationScreen(),
                          );
                        case AuthenticationStatus.unauthenticated:
                          // Reset session expiry flag when showing login screen
                          DioClient.resetSessionExpiryFlag();
                          return const LoginScreen();
                        case AuthenticationStatus.loading:
                          return const LoginScreen(); // Stay on login during loading
                        case AuthenticationStatus.signUpSuccess:
                          return const LoginScreen(); // Redirect to login after successful signup
                        case AuthenticationStatus.sessionExpired:
                          // Show current screen but session expired dialog will appear
                          return const RouteGuard(
                            child: MainNavigationScreen(),
                          );
                        case AuthenticationStatus.unknown:
                          if (onboardingState.status ==
                              OnboardingStatus.loading) {
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
        },
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

class _MaintenanceNavigatorObserver extends NavigatorObserver {
  final MaintenanceStatus? maintenanceStatus;

  _MaintenanceNavigatorObserver(this.maintenanceStatus);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navigation: Pushed ${route.settings.name}');
    debugPrint('Maintenance Mode: ${maintenanceStatus?.isMaintenanceMode}');
  }
}
