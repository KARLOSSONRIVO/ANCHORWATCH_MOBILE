import 'package:flutter/material.dart';

/// Global app-level keys used for navigation and scaffold messaging.
class AppKeys {
  AppKeys._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
}
