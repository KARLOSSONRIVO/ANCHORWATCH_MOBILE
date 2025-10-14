import 'package:flutter_test/flutter_test.dart';
import 'package:anchorwatch/services/email_service.dart';
import 'package:anchorwatch/domain/entities/alert.dart';

void main() {
  test('buildEmailBodyForTest includes message, description, data and received timestamp', () {
    final now = DateTime.parse('2020-01-01T12:00:00Z');
    final alert = Alert(
      id: '1',
      type: 'test',
      title: 'Test',
      message: 'This is a message',
      createdAt: now,
      severity: 'high',
      status: 'active',
      description: 'Detailed description',
      data: {'key': 'value'},
    );

    final body = EmailService.buildEmailBodyForTest(alert);

    expect(body.contains('This is a message'), isTrue);
    expect(body.contains('Details:'), isTrue);
    expect(body.contains('Detailed description'), isTrue);
    expect(body.contains('Data:'), isTrue);
    expect(body.contains('key'), isTrue);
    expect(body.contains('value'), isTrue);
    expect(body.contains('Received: 2020-01-01T12:00:00.000Z'), isTrue);
  });

  test('buildMailtoUriForTest encodes subject and body and includes recipient', () {
    final now = DateTime.parse('2020-01-01T12:00:00Z');
    final alert = Alert(
      id: '2',
      type: 'test',
      title: 'Hello & Friends',
      message: 'Line1\nLine2',
      createdAt: now,
      severity: 'low',
      status: 'active',
    );

    final uri = EmailService.buildMailtoUriForTest(alert, 'user@example.com');

    expect(uri.scheme, equals('mailto'));
    expect(uri.toString().contains('user%40example.com') || uri.toString().contains('user@example.com'), isTrue);
    expect(uri.toString().contains('subject='), isTrue);
    expect(uri.toString().contains('Hello%20%26%20Friends'), isTrue);
    expect(uri.toString().contains('body='), isTrue);
    expect(uri.toString().contains('Line1'), isTrue);
  });
}
