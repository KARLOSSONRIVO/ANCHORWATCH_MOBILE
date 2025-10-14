import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/entities/alert.dart';
import 'storage_service.dart';
import 'dio_client.dart';

/// Result for an email send attempt.
class EmailSendResult {
  final bool success;
  final String message;

  EmailSendResult(this.success, this.message);
}

@lazySingleton
class EmailService {
  final DioClient _dioClient;

  EmailService(this._dioClient);

  /// Try to send alert via backend API. If backend is not available or fails,
  /// fall back to opening the user's mail client with a prefilled mailto: link.
  Future<EmailSendResult> sendAlertEmail(Alert alert) async {
    try {
      final userEmail = StorageService.getString(StorageKeys.userEmail);

      if (userEmail == null || userEmail.isEmpty) {
        debugPrint('EmailService: no user email stored; opening mail app');
        await _openMailClient(alert, null);
        return EmailSendResult(false, 'No user email stored; opened mail client');
      }

      // Attempt backend POST to send email. This assumes the backend exposes
      // an endpoint '/api/alerts/send_email/' that accepts { to, subject, body }.
      try {
        final response = await _dioClient.post('/api/alerts/send_email/', data: {
          'to': userEmail,
          'subject': '[Alert] ${alert.title}',
          'body': _buildEmailBody(alert),
        });

        if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
          debugPrint('EmailService: backend email send succeeded');
          return EmailSendResult(true, 'Backend send succeeded');
        }

        debugPrint('EmailService: backend responded with status ${response.statusCode}; falling back to mail client');
      } catch (e) {
        debugPrint('EmailService: backend send failed: $e');
      }

      // Fallback: open mail client with mailto
      await _openMailClient(alert, userEmail);
      return EmailSendResult(false, 'Fell back to mail client');
    } catch (e) {
      debugPrint('EmailService.sendAlertEmail unexpected error: $e');
      return EmailSendResult(false, 'Unexpected error: $e');
    }
  }

  String _buildEmailBody(Alert alert) {
    final buffer = StringBuffer();
    buffer.writeln(alert.message);
    if (alert.description != null && alert.description!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Details:');
      buffer.writeln(alert.description);
    }
    if (alert.data != null && alert.data!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Data:');
      buffer.writeln(alert.data.toString());
    }
    buffer.writeln();
    buffer.writeln('Received: ${alert.createdAt.toIso8601String()}');
    return buffer.toString();
  }

  @visibleForTesting
  static String buildEmailBodyForTest(Alert alert) {
    final buffer = StringBuffer();
    buffer.writeln(alert.message);
    if (alert.description != null && alert.description!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Details:');
      buffer.writeln(alert.description);
    }
    if (alert.data != null && alert.data!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Data:');
      buffer.writeln(alert.data.toString());
    }
    buffer.writeln();
    buffer.writeln('Received: ${alert.createdAt.toIso8601String()}');
    return buffer.toString();
  }

  @visibleForTesting
  static Uri buildMailtoUriForTest(Alert alert, String? to) {
    final subject = Uri.encodeComponent('[Alert] ${alert.title}');
    final body = Uri.encodeComponent(buildEmailBodyForTest(alert));
    final recipient = to != null && to.isNotEmpty ? to : '';
    return Uri.parse('mailto:$recipient?subject=$subject&body=$body');
  }

  Future<void> _openMailClient(Alert alert, String? to) async {
    final subject = Uri.encodeComponent('[Alert] ${alert.title}');
    final body = Uri.encodeComponent(_buildEmailBody(alert));
    final recipient = to != null && to.isNotEmpty ? to : '';
    final uri = Uri.parse('mailto:$recipient?subject=$subject&body=$body');

    debugPrint('EmailService: launching mailto uri');
    try {
      if (!await launchUrl(uri)) {
        debugPrint('EmailService: could not launch mail client for $uri');
      }
    } catch (e) {
      debugPrint('EmailService._openMailClient error: $e');
    }
  }
}
