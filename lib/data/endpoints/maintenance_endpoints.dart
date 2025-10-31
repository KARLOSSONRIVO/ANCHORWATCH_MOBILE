/// Endpoints for maintenance mode API
class MaintenanceEndpoints {
  /// Get maintenance status
  static const String status = '/api/maintenance/status/';
  
  /// Control maintenance mode (admin only)
  static const String control = '/api/maintenance/control/';
}
