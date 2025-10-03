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

/// Main navigation screen that manages individual screen files using NavigationBloc
class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is NavigationPageSelected) {
          currentIndex = state.currentIndex;
        }

        return Scaffold(
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
        );
      },
    );
  }
}