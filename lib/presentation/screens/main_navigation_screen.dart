import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_state.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_state.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../widgets/navigation_drawer_widget.dart';
import '../../services/navigation_service.dart';
import 'dashboard_screen.dart';
import 'discover_screen.dart';
import 'anchorwise_screen.dart';
import 'alerts_screen.dart';
import 'profile_screen.dart';

/// Main navigation screen that manages individual screen files using NavigationBloc with stack support
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // No callback setup needed - NavigationService handles drawer closing directly
  }

  @override
  void dispose() {
    // No cleanup needed
    super.dispose();
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Discover';
      case 2:
        return 'AnchorWise';
      case 3:
        return 'Alerts';
      case 4:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  List<Widget> _getAppBarActions(BuildContext context, int index) {
    switch (index) {
      case 2: // AnchorWise screen
        return [
          IconButton(
            onPressed: () {
              // TODO: Implement history dialog
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement clear dialog
            },
            icon: const Icon(Icons.clear_all),
          ),
        ];
      default: // All other screens
        return [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon!')),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authState) {
        print('🔍 MainNavigationScreen: Auth state changed to ${authState.status}');
        // If user is logged out, navigate back to login screen
        if (authState.status == AuthenticationStatus.unauthenticated) {
          print('🚪 MainNavigationScreen: Navigating to login due to logout');
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          // Close all drawers whenever navigation changes
          if (state is NavigationPageSelected) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigationService.forceCloseDrawer();
            });
          }
        },
        child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          int currentIndex = 0;
          bool canGoBack = false;
          
          if (state is NavigationPageSelected) {
            currentIndex = state.currentIndex;
            canGoBack = state.canGoBack;
          }

        return PopScope(
          canPop: !canGoBack, // Prevent system back button if we have navigation stack
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop && canGoBack) {
              // Handle back navigation through our stack
              NavigationService.goBack(context);
            }
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.blue.shade50,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(
                _getPageTitle(currentIndex),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: _getAppBarActions(context, currentIndex),
            ),
            drawer: const NavigationDrawerWidget(),
            body: IndexedStack(
              index: currentIndex,
              children: const [
                DashboardScreen(),
                DiscoverScreen(),
                AnchorWiseScreen(),
                AlertsScreen(),
                ProfileScreen(),
              ],
            ),
            bottomNavigationBar: BottomNavigationWidget(
              currentIndex: currentIndex,
              onTap: (index) {
                NavigationService.navigateToIndex(context, index);
              },
            ),
          ),
        );
        },
      ),
      )
    );
  }
}