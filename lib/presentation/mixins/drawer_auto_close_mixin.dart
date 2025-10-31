import 'package:flutter/material.dart';
mixin DrawerAutoCloseMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  bool _wasDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndCloseDrawer();
    });
  }
  void _checkAndCloseDrawer() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final scaffoldState = Scaffold.maybeOf(context);
        if (scaffoldState != null) {
          final isCurrentlyOpen = scaffoldState.isDrawerOpen;
          if (_wasDrawerOpen && !isCurrentlyOpen) {
            _wasDrawerOpen = false;
          } else if (isCurrentlyOpen) {
            _wasDrawerOpen = true;
          }
        }
      }
    });
  }
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
