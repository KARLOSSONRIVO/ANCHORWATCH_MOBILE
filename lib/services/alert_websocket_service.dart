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
  bool _connected = false;
  StreamController<Alert>? _alertController;
  StreamController<AlertDashboard>? _dashboardController;
  StreamController<bool>? _connectionController;

  Stream<Alert> get alertStream =>
      _alertController?.stream ?? const Stream.empty();
  Stream<AlertDashboard> get dashboardStream =>
      _dashboardController?.stream ?? const Stream.empty();
  Stream<bool> get connectionStream =>
      _connectionController?.stream ?? const Stream.empty();

  bool get isConnected => _connected;

  void connect({required String baseUrl}) {
    try {
      _alertController ??= StreamController<Alert>.broadcast();
      _dashboardController ??= StreamController<AlertDashboard>.broadcast();
      _connectionController ??= StreamController<bool>.broadcast();
      final wsUrl = baseUrl.replaceFirst('http', 'ws');

      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/ws/alerts/'));
      _connected = true;

      _connectionController?.add(true);

      _channel!.stream.listen(
        (data) {
          _handleWebSocketMessage(data);
        },
        onError: (error) {
          _connected = false;
          _channel = null;
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
        onDone: () {
          _connected = false;
          _channel = null;
          _connectionController?.add(false);
          _reconnect(baseUrl);
        },
      );
    } catch (e) {
      _connected = false;
      _channel = null;
      _connectionController?.add(false);
    }
  }

  void _handleWebSocketMessage(dynamic data) {
    try {
      final jsonData = jsonDecode(data as String) as Map<String, dynamic>;
      final messageType = jsonData['type'];

      if (messageType == 'alert') {
        final payload =
            jsonData['alert_data'] as Map<String, dynamic>? ??
            jsonData['data'] as Map<String, dynamic>?;
        if (payload == null) {
          return;
        }

        final alertModel = AlertModel.fromJson(payload);
        final alert = alertModel.toEntity();
        _alertController?.add(alert);

        unawaited(_emailService.sendAlertEmail(alert));
      } else if (messageType == 'dashboard' ||
          messageType == 'dashboard_update') {}
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
    sendMessage({
      'type': 'subscribe_alerts',
      'alert_types': [alertType],
    });
  }

  void unsubscribe(String _) {
    sendMessage({'type': 'subscribe_alerts', 'alert_types': <String>[]});
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _connected = false;
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
