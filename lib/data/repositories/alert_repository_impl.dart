import 'package:injectable/injectable.dart';
import '../datasources/remote/alert_remote_data_source.dart';
import '../../domain/entities/alert.dart';
import '../../domain/repositories/alert_repository.dart';

@Injectable(as: AlertRepository)
class AlertRepositoryImpl implements AlertRepository {
  final AlertRemoteDataSource _remoteDataSource;

  AlertRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Alert>> getAlertHistory({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  }) async {
    try {
      final models = await _remoteDataSource.getAlertHistory(
        page: page,
        limit: limit,
        severity: severity,
        status: status,
        type: type,
      );

      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AlertDashboard> getAlertDashboard() async {
    try {
      final model = await _remoteDataSource.getAlertDashboard();
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<AlertRule>> getAlertRules() async {
    try {
      final models = await _remoteDataSource.getAlertRules();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AlertRule> createAlertRule({
    required String type,
    required String name,
    required Map<String, dynamic> conditions,
    required Map<String, dynamic> notificationSettings,
  }) async {
    try {
      final data = {
        'type': type,
        'name': name,
        'conditions': conditions,
        'notification_settings': notificationSettings,
      };

      final model = await _remoteDataSource.createAlertRule(data);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AlertRule> updateAlertRule({
    required String ruleId,
    String? name,
    bool? isEnabled,
    Map<String, dynamic>? conditions,
    Map<String, dynamic>? notificationSettings,
  }) async {
    try {
      final data = <String, dynamic>{};

      if (name != null) data['name'] = name;
      if (isEnabled != null) data['is_enabled'] = isEnabled;
      if (conditions != null) data['conditions'] = conditions;
      if (notificationSettings != null) {
        data['notification_settings'] = notificationSettings;
      }

      final model = await _remoteDataSource.updateAlertRule(ruleId, data);
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAlertRule(String ruleId) async {
    try {
      await _remoteDataSource.deleteAlertRule(ruleId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    try {
      await _remoteDataSource.acknowledgeAlert(alertId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> resolveAlert(String alertId) async {
    try {
      await _remoteDataSource.resolveAlert(alertId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> triggerAlertDetection() async {
    try {
      await _remoteDataSource.triggerAlertDetection();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> testAlertSystem() async {
    try {
      return await _remoteDataSource.testAlertSystem();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getNotificationConfig() async {
    try {
      return await _remoteDataSource.getNotificationConfig();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateNotificationConfig(
    Map<String, dynamic> config,
  ) async {
    try {
      return await _remoteDataSource.updateNotificationConfig(config);
    } catch (e) {
      rethrow;
    }
  }
}
