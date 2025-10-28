import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'dio_client.dart';
import '../data/endpoints/maintenance_endpoints.dart';
import '../data/models/maintenance_status_model.dart';
import '../domain/entities/maintenance_status.dart';

@lazySingleton
class MaintenanceService {
  final DioClient _dioClient;
  MaintenanceStatus? _lastStatus;
  DateTime? _lastCheck;
  
  // Reduce cache duration to 5 seconds for faster maintenance detection
  static const _cacheDuration = Duration(seconds: 5);

  MaintenanceService(this._dioClient);

  Future<MaintenanceStatus> checkMaintenanceStatus({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh && 
          _lastStatus != null && 
          _lastCheck != null &&
          DateTime.now().difference(_lastCheck!) < _cacheDuration) {
        debugPrint('MaintenanceService: Returning cached status');
        return _lastStatus!;
      }

      debugPrint('MaintenanceService: Fetching maintenance status from API');
      
      final response = await _dioClient.get(
        MaintenanceEndpoints.status,
      );

      if (response.data != null) {
        debugPrint('MaintenanceService: API Response: ${response.data}');
        
        final model = MaintenanceStatusModel.fromJson(response.data);
        final status = model.toEntity();
        
        _lastStatus = status;
        _lastCheck = DateTime.now();
        
        debugPrint('MaintenanceService: Parsed status - Mode: ${status.mode}, IsMaintenanceMode: ${status.isMaintenanceMode}');
        return status;
      }

      debugPrint('MaintenanceService: No data returned, defaulting to ACTIVE');
      return MaintenanceStatus(mode: 'ACTIVE', message: '');
    } catch (e) {
      debugPrint('MaintenanceService: Error checking status: $e');
      
      if (_lastStatus != null) {
        debugPrint('MaintenanceService: Error occurred, returning cached status');
        return _lastStatus!;
      }
      
      debugPrint('MaintenanceService: Error occurred, defaulting to ACTIVE');
      return MaintenanceStatus(mode: 'ACTIVE', message: '');
    }
  }

  void clearCache() {
    _lastStatus = null;
    _lastCheck = null;
    debugPrint('MaintenanceService: Cache cleared');
  }

  MaintenanceStatus? get cachedStatus => _lastStatus;
}
