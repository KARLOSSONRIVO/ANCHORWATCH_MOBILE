import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_state.dart';
import '../widgets/bottom_navigation_widget.dart';
import '../services/navigation_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationBloc, NavigationState>(
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
            key: NavigationService.mainScaffoldKey,
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
    );
  }


}