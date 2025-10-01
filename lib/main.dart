import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/authentication/authentication.dart';
import 'routes/routes.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc()
        ..add(const AuthenticationStatusRequested()),
      child: MaterialApp(
        title: 'AnchorWatch',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                return const HomeScreen();
              case AuthenticationStatus.unauthenticated:
                return const LoginScreen();
              case AuthenticationStatus.unknown:
                return const _SplashScreen();
            }
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
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 16),
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