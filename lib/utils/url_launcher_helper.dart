import 'package:url_launcher/url_launcher.dart';
class UrlLauncherHelper {
  UrlLauncherHelper._();
  static Future<bool> launchExternal(String urlString) async {
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }

      return false;
    } catch (e) {
      return false;
    }
  }
  static Future<bool> launchInApp(String urlString) async {
    try {
      final url = Uri.parse(urlString);

      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.inAppWebView);
      }

      return false;
    } catch (e) {
      return false;
    }
  }
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
      return false;
    }
  }
  static Future<bool> launchPhone(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      return await launchUrl(phoneUri);
    } catch (e) {
      return false;
    }
  }
  static Future<bool> launchSms(String phoneNumber, {String? body}) async {
    try {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {if (body != null) 'body': body},
      );

      return await launchUrl(smsUri);
    } catch (e) {
      return false;
    }
  }
  static Future<bool> canLaunch(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      return await canLaunchUrl(url);
    } catch (e) {
      return false;
    }
  }
}


