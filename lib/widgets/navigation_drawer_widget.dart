import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/navigation_service.dart';
import '../blocs/navigation/navigation_bloc.dart';
import '../blocs/navigation/navigation_state.dart';

/// Reusable navigation drawer widget matching the provided design
class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is NavigationPageSelected) {
          currentIndex = state.currentIndex;
        }

        return Drawer(
      backgroundColor: const Color(0xFF2D2D2D), // Dark grey background matching the image
      child: SafeArea(
        child: Column(
          children: [
            // Header with Logo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Row(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/LOGOnoBG.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  // AnchorWatch Text
                  const Text(
                    'AnchorWatch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider line
            Container(
              height: 1,
              color: const Color(0xFF404040),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            
            const SizedBox(height: 8),
            
            // Menu Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Main navigation items (matching bottom nav bar order)
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Home.png',
                    title: 'Dashboard',
                    currentIndex: currentIndex,
                    itemIndex: 0,
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.dashboard);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Compass.png',
                    title: 'Discover',
                    currentIndex: currentIndex,
                    itemIndex: 1,
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.discover);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/AnchorWise.png',
                    title: 'AnchorWise',
                    currentIndex: currentIndex,
                    itemIndex: 2,
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.anchorwise);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Notifications.png',
                    title: 'Alerts',
                    currentIndex: currentIndex,
                    itemIndex: 3,
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.alerts);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Profile.png',
                    title: 'Profile',
                    currentIndex: currentIndex,
                    itemIndex: 4,
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.profile);
                    },
                  ),
                  
                  // Separator
                  Container(
                    height: 1,
                    color: const Color(0xFF404040),
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  ),
                  
                  // Additional navigation items
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Phone.png',
                    title: 'Contact Support',
                    currentIndex: currentIndex,
                    itemIndex: -1, // Special navigation, never active
                    onTap: () {
                      NavigationService.handleSpecialNavigation(context, 'contact_support');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Faqs.png',
                    title: 'FAQS',
                    currentIndex: currentIndex,
                    itemIndex: -2, // Special navigation, never active
                    onTap: () {
                      NavigationService.handleSpecialNavigation(context, 'faqs');
                    },
                  ),
                ],
              ),
            ),
            
            // Logout Button at the bottom
            Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Use a simple synchronous call to avoid context issues
                    NavigationService.handleSpecialNavigation(context, 'logout');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD32F2F), // Red color matching the image
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.logout,
                    size: 18,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  /// Build individual menu item matching the design with active state indicator
  Widget _buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    required int currentIndex,
    required int itemIndex,
  }) {
    final bool isActive = currentIndex == itemIndex;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: isActive ? BoxDecoration(
            color: const Color(0xFF00BCD4).withOpacity(0.15),
            border: const Border(
              right: BorderSide(
                color: const Color(0xFF00BCD4),
                width: 3,
              ),
            ),
          ) : null,
          child: Row(
            children: [
              // Custom icon from assets
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: isActive ? const Color(0xFF00BCD4) : Colors.white,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              // Menu title
              Text(
                title,
                style: TextStyle(
                  color: isActive ? const Color(0xFF00BCD4): Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
