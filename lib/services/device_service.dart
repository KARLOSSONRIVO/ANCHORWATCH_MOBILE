import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Device orientation preferences
enum OrientationPreference {
  portrait,
  landscape,
  auto,
}

/// Service for handling device-specific functionality
class DeviceService {
  /// Initialize device service
  static Future<void> init() async {
    debugPrint('DeviceService: Initializing');
  }

  // Device Information
  /// Check if device is a tablet
  static bool isTablet(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    return data.size.shortestSide >= 600;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get screen size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Get device pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // Haptic Feedback
  /// Provide light haptic feedback
  static Future<void> lightHaptic() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('DeviceService.lightHaptic error: $e');
    }
  }

  /// Provide medium haptic feedback
  static Future<void> mediumHaptic() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('DeviceService.mediumHaptic error: $e');
    }
  }

  /// Provide heavy haptic feedback
  static Future<void> heavyHaptic() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('DeviceService.heavyHaptic error: $e');
    }
  }

  /// Provide selection haptic feedback
  static Future<void> selectionHaptic() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('DeviceService.selectionHaptic error: $e');
    }
  }

  // Vibration (for alerts)
  /// Vibrate device for alerts
  static Future<void> vibrateForAlert() async {
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      debugPrint('DeviceService.vibrateForAlert error: $e');
    }
  }

  // System UI
  /// Hide system UI (status bar and navigation bar)
  static Future<void> hideSystemUI() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } catch (e) {
      debugPrint('DeviceService.hideSystemUI error: $e');
    }
  }

  /// Show system UI
  static Future<void> showSystemUI() async {
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } catch (e) {
      debugPrint('DeviceService.showSystemUI error: $e');
    }
  }

  /// Set status bar color
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
    } catch (e) {
      debugPrint('DeviceService.setStatusBarColor error: $e');
    }
  }

  // Screen Orientation
  /// Lock screen to portrait
  static Future<void> lockPortrait() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } catch (e) {
      debugPrint('DeviceService.lockPortrait error: $e');
    }
  }

  /// Lock screen to landscape
  static Future<void> lockLandscape() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('DeviceService.lockLandscape error: $e');
    }
  }

  /// Allow all orientations
  static Future<void> allowAllOrientations() async {
    try {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('DeviceService.allowAllOrientations error: $e');
    }
  }

  // Keyboard
  /// Dismiss keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Check if keyboard is visible
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  // App Lifecycle
  /// Bring app to foreground (if possible)
  static Future<void> bringToForeground() async {
    debugPrint('DeviceService: Bringing app to foreground');
    // This would typically use platform channels
  }

  /// Check if app is in background
  static bool isInBackground() {
    // This would typically check app lifecycle state
    return false;
  }

  // Device Capabilities
  /// Check if device supports haptic feedback
  static bool supportsHaptics() {
    // This would check device capabilities
    return true; // Most modern devices support haptics
  }

  /// Check if device supports vibration
  static bool supportsVibration() {
    // This would check device capabilities
    return true; // Most devices support vibration
  }

  // Battery and Performance
  /// Check if device is in power saving mode
  static bool isPowerSavingMode() {
    // This would typically use platform channels to check battery status
    return false;
  }

  /// Check battery level (would need battery_plus package)
  static Future<int?> getBatteryLevel() async {
    debugPrint('DeviceService: Getting battery level');
    // This would use battery_plus package
    return null; // Placeholder
  }

  // Network
  /// Check if device has internet connection
  static Future<bool> hasInternetConnection() async {
    debugPrint('DeviceService: Checking internet connection');
    // This would use connectivity_plus package
    return true; // Placeholder
  }

  // Permissions Helper
  /// Show permission settings dialog
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
              // Open app settings (would use app_settings package)
              debugPrint('DeviceService: Opening app settings');
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }
}