import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../models/alert_model.dart';
import '../../../services/dio_client.dart';

abstract class AlertRemoteDataSource {
  Future<List<AlertModel>> getAlertHistory({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  });

  Future<AlertDashboardModel> getAlertDashboard();
  Future<List<AlertRuleModel>> getAlertRules();
  Future<AlertRuleModel> createAlertRule(Map<String, dynamic> data);
  Future<AlertRuleModel> updateAlertRule(
    String ruleId,
    Map<String, dynamic> data,
  );
  Future<void> deleteAlertRule(String ruleId);
  Future<void> acknowledgeAlert(String alertId);
  Future<void> resolveAlert(String alertId);
  Future<void> triggerAlertDetection();
  Future<Map<String, dynamic>> testAlertSystem();
  Future<Map<String, dynamic>> getNotificationConfig();
  Future<Map<String, dynamic>> updateNotificationConfig(
    Map<String, dynamic> config,
  );
}

@LazySingleton(as: AlertRemoteDataSource)
class AlertRemoteDataSourceImpl implements AlertRemoteDataSource {
  final DioClient _dioClient;

  AlertRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<AlertModel>> getAlertHistory({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (severity != null) {
        queryParams['severity'] = severity;
      }

      if (status != null) {
        final normalizedStatus = status == 'active' ? 'triggered' : status;
        queryParams['status'] = normalizedStatus;
      }

      if (type != null) {
        queryParams['type'] = type;
      }

      final response = await _dioClient.get(
        '/api/alerts/history/',
        queryParameters: queryParams,
      );
      final respData = response.data;

      if (respData is! Map<String, dynamic>) {
        throw Exception('Unexpected response format');
      }

      if (respData['success'] != true) {
        throw Exception(respData['message'] ?? 'Failed to fetch alert history');
      }

      final payload = respData['data'];
      List<dynamic> alertsJson = <dynamic>[];

      if (payload is List<dynamic>) {
        alertsJson = payload;
      } else if (payload is Map<String, dynamic>) {
        if (payload['alerts'] is List<dynamic>) {
          alertsJson = payload['alerts'] as List<dynamic>;
        } else if (payload['data'] is List<dynamic>) {
          alertsJson = payload['data'] as List<dynamic>;
        }
      }

      return alertsJson
          .whereType<Map<String, dynamic>>()
          .map(AlertModel.fromJson)
          .toList();
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch alert history: $e');
    }
  }

  @override
  Future<AlertDashboardModel> getAlertDashboard() async {
    try {
      final response = await _dioClient.get('/api/alerts/dashboard/');

      if (response.data['success'] == true) {
        return AlertDashboardModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      }
      throw Exception(
        response.data['message'] ?? 'Failed to fetch alert dashboard',
      );
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch alert dashboard: $e');
    }
  }

  @override
  Future<List<AlertRuleModel>> getAlertRules() async {
    try {
      final response = await _dioClient.get('/api/alerts/rules/');

      if (response.data['success'] == true) {
        final data = response.data['data'];
        final List<dynamic> rulesJson;

        if (data is Map<String, dynamic> && data['rules'] is List<dynamic>) {
          rulesJson = data['rules'] as List<dynamic>;
        } else if (data is List<dynamic>) {
          rulesJson = data;
        } else {
          rulesJson = const [];
        }

        return rulesJson
            .whereType<Map<String, dynamic>>()
            .map(AlertRuleModel.fromJson)
            .toList();
      }
      throw Exception(
        response.data['message'] ?? 'Failed to fetch alert rules',
      );
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to fetch alert rules: $e');
    }
  }

  @override
  Future<AlertRuleModel> createAlertRule(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.post('/api/alerts/rules/', data: data);

      if (response.data['success'] == true) {
        return AlertRuleModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to create alert rule',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to create alert rule: $e');
    }
  }

  @override
  Future<AlertRuleModel> updateAlertRule(
    String ruleId,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dioClient.put(
        '/api/alerts/rules/$ruleId/',
        data: data,
      );

      if (response.data['success'] == true) {
        return AlertRuleModel.fromJson(
          response.data['data'] as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to update alert rule',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to update alert rule: $e');
    }
  }

  @override
  Future<void> deleteAlertRule(String ruleId) async {
    try {
      final response = await _dioClient.delete('/api/alerts/rules/$ruleId/');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to delete alert rule',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to delete alert rule: $e');
    }
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    try {
      final response = await _dioClient.post(
        '/api/alerts/acknowledge/$alertId/',
      );

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to acknowledge alert',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to acknowledge alert: $e');
    }
  }

  @override
  Future<void> resolveAlert(String alertId) async {
    try {
      final response = await _dioClient.post('/api/alerts/resolve/$alertId/');

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Failed to resolve alert');
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to resolve alert: $e');
    }
  }

  @override
  Future<void> triggerAlertDetection() async {
    try {
      final response = await _dioClient.post('/api/alerts/trigger/');

      if (response.data['success'] != true) {
        throw Exception(
          response.data['message'] ?? 'Failed to trigger alert detection',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to trigger alert detection: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> testAlertSystem() async {
    try {
      final response = await _dioClient.post('/api/alerts/test/');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to test alert system',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to test alert system: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getNotificationConfig() async {
    try {
      final response = await _dioClient.get(
        '/api/alerts/notifications/config/',
      );

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to get notification config',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to get notification config: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateNotificationConfig(
    Map<String, dynamic> config,
  ) async {
    try {
      final response = await _dioClient.post(
        '/api/alerts/notifications/config/',
        data: config,
      );

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>? ?? {};
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to update notification config',
        );
      }
    } catch (e) {
      if (e is DioException) {
        throw Exception('Network error: ${e.message}');
      }
      throw Exception('Failed to update notification config: $e');
    }
  }
}
