import 'package:flutter/material.dart';

/// Bottom navigation bar widget with 5 main navigation items
class BottomNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2D2D2D), // Dark background matching the design
        border: Border(
          top: BorderSide(
            color: Color(0xFF404040),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                iconPath: 'assets/images/Navigation_Icons/Home.png',
                index: 0,
                label: 'Home',
              ),
              _buildNavItem(
                context,
                iconPath: 'assets/images/Navigation_Icons/Compass.png',
                index: 1,
                label: 'Discover',
              ),
              _buildNavItem(
                context,
                iconPath: 'assets/images/Navigation_Icons/AnchorWise.png',
                index: 2,
                label: 'AnchorWise',
              ),
              _buildNavItem(
                context,
                iconPath: 'assets/images/Navigation_Icons/Notifications.png',
                index: 3,
                label: 'Alerts',
              ),
              _buildNavItem(
                context,
                iconPath: 'assets/images/Navigation_Icons/Profile.png',
                index: 4,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String iconPath,
    required int index,
    required String label,
  }) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Close drawer if open before navigation
          _closeDrawerIfOpen(context);
          onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Center(
            child: SizedBox(
              width: 32,
              height: 32,
              child: Image.asset(
                iconPath,
                color: isSelected 
                  ? const Color(0xFF00BCD4) // Teal color for selected
                  : Colors.white.withValues(alpha: 0.7), // White with opacity for unselected
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to close drawer if it's open
  void _closeDrawerIfOpen(BuildContext context) {
    try {
      // Find the scaffold in the current widget tree
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Silently handle any context-related errors
      print('Debug: Could not close drawer - $e');
    }
  }
}