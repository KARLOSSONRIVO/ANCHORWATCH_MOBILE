import 'package:flutter/material.dart';
import '../routes/route_guard.dart';
import 'custom_snackbar.dart';

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
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'Home selected');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Compass.png',
                    title: 'Discover',
                    onTap: () {
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'Discover feature coming soon!');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/AnchorWise.png',
                    title: 'AnchorWise',
                    onTap: () {
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'AnchorWise coming soon!');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Notifications.png',
                    title: 'Alerts',
                    onTap: () {
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'Alerts system coming soon!');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Profile.png',
                    title: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
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
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'Contact support coming soon!');
                    },
                  ),
                  _buildMenuItem(
                    context,
                    iconPath: 'assets/images/Navigation_Icons/Faqs.png',
                    title: 'FAQS',
                    onTap: () {
                      Navigator.pop(context);
                      SnackBarHelper.showInfo(context, 'FAQs coming soon!');
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
                    Navigator.pop(context);
                    await NavigationHelper.handleLogout(context);
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
