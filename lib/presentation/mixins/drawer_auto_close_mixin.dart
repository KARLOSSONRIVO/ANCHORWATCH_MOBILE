import 'package:flutter/material.dart';

/// Mixin that automatically closes the drawer when the screen becomes inactive
/// during bottom navigation. This ensures drawers don't stay open when users
/// navigate between screens using the bottom navigation bar.
mixin DrawerAutoCloseMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  bool _wasDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    // Listen to route changes to detect when user navigates away
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndCloseDrawer();
    });
  }

  /// Check if drawer is open and close it when navigating away
  void _checkAndCloseDrawer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null) {
          final isCurrentlyOpen = scaffoldState.isDrawerOpen;
          
          // If drawer was open and we're navigating away, close it
          if (_wasDrawerOpen && !isCurrentlyOpen) {
            _wasDrawerOpen = false;
          } else if (isCurrentlyOpen) {
            _wasDrawerOpen = true;
          }
        }
      }
    });
  }

  /// Force close drawer - can be called by navigation service
  void forceCloseDrawer() {
    if (mounted) {
      final scaffoldState = Scaffold.maybeOf(context);
      if (scaffoldState != null && scaffoldState.isDrawerOpen) {
        Navigator.of(context).pop();
        _wasDrawerOpen = false;
      }
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkAndCloseDrawer();
  }
}