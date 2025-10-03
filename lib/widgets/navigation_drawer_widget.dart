import 'package:flutter/material.dart';
import '../services/navigation_service.dart';

/// Reusable navigation drawer widget matching the provided design
class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.dashboard);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Compass.png',
                    title: 'Discover',
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.discover);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/AnchorWise.png',
                    title: 'AnchorWise',
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.anchorwise);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Notifications.png',
                    title: 'Alerts',
                    onTap: () {
                      NavigationService.handleMainNavigation(context, NavigationIndex.alerts);
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Profile.png',
                    title: 'Profile',
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
                    onTap: () {
                      NavigationService.handleSpecialNavigation(context, 'contact_support');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Faqs.png',
                    title: 'FAQS',
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
                  onPressed: () async {
                    await NavigationService.handleSpecialNavigation(context, 'logout');
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
  }

  /// Build individual menu item matching the design
  Widget _buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              // Custom icon from assets
              Image.asset(
                iconPath,
                width: 28,
                height: 28,
                color: Colors.white, // Tint the icons white to match the design
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              // Menu title
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
