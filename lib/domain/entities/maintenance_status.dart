class MaintenanceStatus {
  final String mode;
  final String message;
  final DateTime? enabledAt;
  final String? enabledBy;
  final DateTime? estimatedCompletion;
  final String? maintenanceType;
  final String? systemVersion;
  final String? supportContact;

  MaintenanceStatus({
    required this.mode,
    required this.message,
    this.enabledAt,
    this.enabledBy,
    this.estimatedCompletion,
    this.maintenanceType,
    this.systemVersion,
    this.supportContact,
  });

  bool get isMaintenanceMode => mode == 'MAINTENANCE';
  bool get isActive => mode == 'ACTIVE';
}
