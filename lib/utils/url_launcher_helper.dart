import 'package:url_launcher/url_launcher.dart';

/// Centralized URL launching utilities
///
/// This class provides reusable methods for launching URLs, emails, and phone numbers.
/// All methods return a boolean indicating success or failure.
class UrlLauncherHelper {
  // Private constructor to prevent instantiation
  UrlLauncherHelper._();

  /// Launch a URL in an external browser
  ///
  /// Returns true if successful, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = await UrlLauncherHelper.launchExternal('https://example.com');
  /// if (!success && context.mounted) {
  ///   SnackBarHelper.showError(context, 'Could not open the link');
  /// }
  /// ```
  static Future<bool> launchExternal(String urlString) async {
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }

      return false;
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error launching external URL: $e');
      return false;
    }
  }

  /// Launch a URL in an in-app web view
  ///
  /// Returns true if successful, false otherwise.
  static Future<bool> launchInApp(String urlString) async {
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.inAppWebView);
      }

      return false;
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error launching in-app URL: $e');
      return false;
    }
  }

  /// Launch an email client with pre-filled fields
  ///
  /// Returns true if successful, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = await UrlLauncherHelper.launchEmail(
  ///   'support@example.com',
  ///   subject: 'Help Request',
  ///   body: 'I need help with...',
  /// );
  /// ```
  static Future<bool> launchEmail(
    String email, {
    String? subject,
    String? body,
  }) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );

      return await launchUrl(emailUri);
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error launching email: $e');
      return false;
    }
  }

  /// Launch a phone dialer with pre-filled number
  ///
  /// Returns true if successful, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final success = await UrlLauncherHelper.launchPhone('+1234567890');
  /// ```
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      return await launchUrl(phoneUri);
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error launching phone: $e');
      return false;
    }
  }

  /// Launch an SMS app with pre-filled number and optional message
  ///
  /// Returns true if successful, false otherwise.
  static Future<bool> launchSms(String phoneNumber, {String? body}) async {
    try {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {if (body != null) 'body': body},
      );

      return await launchUrl(smsUri);
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error launching SMS: $e');
      return false;
    }
  }

  /// Check if a URL can be launched before attempting
  ///
  /// Useful for checking availability before showing UI elements.
  static Future<bool> canLaunch(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      return await canLaunchUrl(url);
    } catch (e) {
      print('❌ [UrlLauncherHelper] Error checking URL: $e');
      return false;
    }
  }
}
