import '../../domain/entities/maintenance_status.dart';

class MaintenanceStatusModel {
  final String mode;
  final String message;
  final String? enabledAt;
  final String? enabledBy;
  final String? estimatedCompletion;
  final String? maintenanceType;
  final String? systemVersion;
  final String? supportContact;

  MaintenanceStatusModel({
    required this.mode,
    required this.message,
    this.enabledAt,
    this.enabledBy,
    this.estimatedCompletion,
    this.maintenanceType,
    this.systemVersion,
    this.supportContact,
  });

  factory MaintenanceStatusModel.fromJson(Map<String, dynamic> json) {
    // Check if response has nested maintenance_status object
    final data = json.containsKey('maintenance_status') 
        ? json['maintenance_status'] as Map<String, dynamic>
        : json;
    
    return MaintenanceStatusModel(
      mode: data['mode'] ?? data['maintenance_mode'] ?? 'ACTIVE',
      message: data['message'] ?? data['maintenance_message'] ?? '',
      enabledAt: data['enabled_at'] ?? data['maintenance_enabled_at'],
      enabledBy: data['enabled_by'] ?? data['maintenance_enabled_by'],
      estimatedCompletion: data['estimated_completion'],
      maintenanceType: data['maintenance_type'],
      systemVersion: data['system_version'],
      supportContact: data['support_contact'] ?? '',
    );
  }

  MaintenanceStatus toEntity() {
    return MaintenanceStatus(
      mode: mode,
      message: message,
      enabledAt: enabledAt != null ? DateTime.tryParse(enabledAt!) : null,
      enabledBy: enabledBy,
      estimatedCompletion: estimatedCompletion != null
          ? DateTime.tryParse(estimatedCompletion!)
          : null,
      maintenanceType: maintenanceType,
      systemVersion: systemVersion,
      supportContact: supportContact,
    );
  }
}
