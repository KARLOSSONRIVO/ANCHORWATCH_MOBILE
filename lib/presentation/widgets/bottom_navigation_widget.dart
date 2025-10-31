import 'package:flutter/material.dart';
import '../../services/navigation_service.dart';
import '../themes/app_theme.dart';
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
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(context),
        border: Border(
          top: BorderSide(
            color: AppTheme.getBorderColor(context),
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
          NavigationService.forceCloseDrawer();
          onTap(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(
                  iconPath,
                  color: isSelected 
                    ? AppTheme.primaryColor // Primary color for selected
                    : AppTheme.getTextSecondaryColor(context), // Theme-aware color for unselected
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 1),
              _buildStackIndicator(context, index, isSelected),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildStackIndicator(BuildContext context, int index, bool isSelected) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: isSelected 
          ? AppTheme.primaryColor
          : Colors.transparent,
        shape: BoxShape.circle,
      ),
    );
  }


}
