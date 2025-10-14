import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:injectable/injectable.dart';
import '../domain/entities/alert.dart';
import '../data/models/alert_model.dart';
import 'email_service.dart';

@singleton
class AlertWebSocketService {
  final EmailService _emailService;

  AlertWebSocketService(this._emailService);
  WebSocketChannel? _channel;
  StreamController<Alert>? _alertController;
  StreamController<AlertDashboard>? _dashboardController;
  StreamController<bool>? _connectionController;

  Stream<Alert> get alertStream =>
      _alertController?.stream ?? const Stream.empty();
  Stream<AlertDashboard> get dashboardStream =>
      _dashboardController?.stream ?? const Stream.empty();
  Stream<bool> get connectionStream =>
      _connectionController?.stream ?? const Stream.empty();

  bool get isConnected => _channel != null;

  void connect({required String baseUrl}) {
    try {
      _alertController ??= StreamController<Alert>.broadcast();
      _dashboardController ??= StreamController<AlertDashboard>.broadcast();
      _connectionController ??= StreamController<bool>.broadcast();

      // Convert HTTP/HTTPS URL to WebSocket URL
      final wsUrl = baseUrl.replaceFirst('http', 'ws');

      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws/alerts/'));

      _connectionController?.add(true);

      _channel!.stream.listen(
        (data) {
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          print('WebSocket error: $error');
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
        onDone: () {
          print('WebSocket connection closed');
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
      );
    } catch (e) {
      print('Failed to connect to WebSocket: $e');
      _connectionController?.add(false);
    }
  }

  void _handleWebSocketMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data as String);

        if (jsonData['type'] == 'alert') {
        final alertModel = AlertModel.fromJson(jsonData['data']);
        final alert = alertModel.toEntity();
        _alertController?.add(alert);

        // Attempt to send the alert to the user's email in background.
        // This will try a backend send first and fall back to opening mail app if needed.
        try {
          // fire-and-forget; do not await to avoid blocking websocket handling
          _emailService.sendAlertEmail(alert).then((result) {
            if (result.success) {
              // Optionally log or handle success
              // keep lightweight to avoid spamming logs
              print('Alert email sent successfully');
            } else {
              print('Alert email send fallback/result: ${result.message}');
            }
          }).catchError((e) {
            print('EmailService.sendAlertEmail error: $e');
          });
        } catch (e) {
          // Swallow any errors to avoid disrupting the websocket flow
          print('EmailService.sendAlertEmail error: $e');
        }
      } else if (jsonData['type'] == 'dashboard') {
        // Handle dashboard updates if needed
        // final dashboard = AlertDashboardModel.fromJson(jsonData['data']).toEntity();
        // _dashboardController?.add(dashboard);
      }
    } catch (e) {
      print('Error parsing WebSocket message: $e');
    }
  }

  void _reconnect(String baseUrl) {
    Timer(const Duration(seconds: 5), () {
      if (!isConnected) {
        print('Attempting to reconnect to WebSocket...');
        connect(baseUrl: baseUrl);
      }
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    if (isConnected) {
      _channel?.sink.add(jsonEncode(message));
    }
  }

  void subscribe(String alertType) {
    sendMessage({'action': 'subscribe', 'alert_type': alertType});
  }

  void unsubscribe(String alertType) {
    sendMessage({'action': 'unsubscribe', 'alert_type': alertType});
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connectionController?.add(false);
  }

  void dispose() {
    disconnect();
    _alertController?.close();
    _dashboardController?.close();
    _connectionController?.close();
    _alertController = null;
    _dashboardController = null;
    _connectionController = null;
  }
}
