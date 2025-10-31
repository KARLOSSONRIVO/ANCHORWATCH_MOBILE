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
      final wsUrl = baseUrl.replaceFirst('http', 'ws');

      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws/alerts/'));

      _connectionController?.add(true);

      _channel!.stream.listen(
        (data) {
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
        onDone: () {
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
      );
    } catch (e) {
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

        try {
          _emailService.sendAlertEmail(alert).then((result) {
          }).catchError((e) {
          });
        } catch (_) {}
      } else if (jsonData['type'] == 'dashboard') {
      }
    } catch (_) {}
  }

  void _reconnect(String baseUrl) {
    Timer(const Duration(seconds: 5), () {
      if (!isConnected) {
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

