import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';
import '../domain/entities/alert.dart';
import 'storage_service.dart';
import 'dio_client.dart';
class EmailSendResult {
  final bool success;
  final String message;

  EmailSendResult(this.success, this.message);
}

@lazySingleton
class EmailService {
  final DioClient _dioClient;

  EmailService(this._dioClient);
  Future<EmailSendResult> sendAlertEmail(Alert alert) async {
    try {
      final userEmail = StorageService.getString(StorageKeys.userEmail);

      if (userEmail == null || userEmail.isEmpty) {        await _openMailClient(alert, null);
        return EmailSendResult(false, 'No user email stored; opened mail client');
      }
      try {
        final response = await _dioClient.post('/api/alerts/send_email/', data: {
          'to': userEmail,
          'subject': '[Alert] ${alert.title}',
        'body': _buildEmailBody(alert),
      });

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {          return EmailSendResult(true, 'Backend send succeeded');
      }      } catch (_) {}
    await _openMailClient(alert, userEmail);
    return EmailSendResult(false, 'Fell back to mail client');
  } catch (e) {      return EmailSendResult(false, 'Unexpected error: $e');
  }
}  String _buildEmailBody(Alert alert) {
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
  final uri = Uri.parse('mailto:$recipient?subject=$subject&body=$body');    try {
    if (!await launchUrl(uri)) {      }
  } catch (_) {}
}
}
