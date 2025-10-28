import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'maintenance_service.dart';
import 'authentication_service.dart';
import '../domain/entities/maintenance_status.dart';

/// Monitors maintenance mode and triggers logout when maintenance is enabled
@lazySingleton
class MaintenanceMonitor {
  final MaintenanceService _maintenanceService;
  final AuthenticationService _authenticationService;
  
  Timer? _monitorTimer;
  MaintenanceStatus? _lastStatus;
  
  // Check maintenance status every 10 seconds for faster response
  static const _checkInterval = Duration(seconds: 10);
  
  // Callback when maintenance mode changes
  Function(MaintenanceStatus)? onMaintenanceModeChanged;

  MaintenanceMonitor(
    this._maintenanceService,
    this._authenticationService,
  );

  /// Start monitoring maintenance mode
  void startMonitoring() {
    if (_monitorTimer != null && _monitorTimer!.isActive) {
      debugPrint('MaintenanceMonitor: Already monitoring');
      return;
    }

    debugPrint('MaintenanceMonitor: Starting maintenance mode monitoring');
    
    // Check immediately on start
    _checkMaintenanceStatus();
    
    // Then check periodically
    _monitorTimer = Timer.periodic(_checkInterval, (_) {
      _checkMaintenanceStatus();
    });
  }

  /// Stop monitoring maintenance mode
  void stopMonitoring() {
    debugPrint('MaintenanceMonitor: Stopping maintenance mode monitoring');
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  /// Manually check maintenance status
  Future<MaintenanceStatus> checkNow() async {
    return await _maintenanceService.checkMaintenanceStatus(forceRefresh: true);
  }

  Future<void> _checkMaintenanceStatus() async {
    try {
      // Always force refresh to get latest status
      final status = await _maintenanceService.checkMaintenanceStatus(forceRefresh: true);
      
      debugPrint('MaintenanceMonitor: Current status = ${status.mode} (maintenance: ${status.isMaintenanceMode})');
      
      // Check if status changed
      final statusChanged = _lastStatus?.mode != status.mode;
      
      if (statusChanged) {
        debugPrint('MaintenanceMonitor: Status changed from ${_lastStatus?.mode} to ${status.mode}');
      }
      
      // Always notify listeners to update UI
      onMaintenanceModeChanged?.call(status);
      
      // If system entered maintenance mode, logout user
      if (status.isMaintenanceMode && !(_lastStatus?.isMaintenanceMode ?? false)) {
        debugPrint('MaintenanceMonitor: System entered maintenance mode - logging out user');
        await _authenticationService.logout();
      }
      
      _lastStatus = status;
    } catch (e) {
      debugPrint('MaintenanceMonitor: Error checking maintenance status: $e');
    }
  }

  /// Get current maintenance status
  MaintenanceStatus? get currentStatus => _lastStatus;

  /// Check if currently in maintenance mode
  bool get isInMaintenanceMode => _lastStatus?.isMaintenanceMode ?? false;

  /// Dispose resources
  void dispose() {
    stopMonitoring();
  }
}
