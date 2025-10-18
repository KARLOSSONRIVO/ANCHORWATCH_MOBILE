import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OrientationPreference {
  portrait,
  landscape,
  auto,
}

class DeviceService {
  static Future<void> init() async {}

  static bool isTablet(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return data.size.shortestSide >= 600;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  static Future<void> lightHaptic() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {}
  }

  static Future<void> mediumHaptic() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {}
  }

  static Future<void> heavyHaptic() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (_) {}
  }

  static Future<void> selectionHaptic() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (_) {}
  }

  static Future<void> vibrateForAlert() async {
    try {
      await HapticFeedback.vibrate();
    } catch (_) {}
  }

  static Future<void> hideSystemUI() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } catch (_) {}
  }

  static Future<void> showSystemUI() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (_) {}
  }

  static Future<void> setStatusBarColor({
    Color? color,
    Brightness? iconBrightness,
  }) async {
    try {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: color,
          statusBarIconBrightness: iconBrightness,
        ),
      );
    } catch (_) {}
  }

  static Future<void> lockPortrait() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (_) {}
  }

  static Future<void> lockLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (_) {}
  }

  static Future<void> allowAllOrientations() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (_) {}
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  static Future<void> bringToForeground() async {}

  static bool isInBackground() {
    return false;
  }

  static bool supportsHaptics() {
    return true;
  }

  static bool supportsVibration() {
    return true;
  }

  static bool isPowerSavingMode() {
    return false;
  }

  static Future<int?> getBatteryLevel() async {
    return null;
  }

  static Future<bool> hasInternetConnection() async {
    return true;
  }

  static Future<void> showPermissionSettings(BuildContext context, String permissionType) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionType Permission Required'),
        content: Text(
          'This app needs $permissionType permission to function properly. '
          'Please enable it in the app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}
