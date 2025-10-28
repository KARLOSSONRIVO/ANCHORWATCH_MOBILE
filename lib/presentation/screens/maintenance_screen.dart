import 'package:flutter/material.dart';
import '../../domain/entities/maintenance_status.dart';
import '../themes/app_theme.dart';

class MaintenanceScreen extends StatelessWidget {
  final MaintenanceStatus status;

  const MaintenanceScreen({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Maintenance Icon
                Icon(
                  Icons.construction,
                  size: 120,
                  color: Colors.orange.shade700,
                ),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'System Maintenance',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getTextPrimaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // Message
                Text(
                  status.message.isNotEmpty
                      ? status.message
                      : 'System is currently under maintenance. Please try again later.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getTextSecondaryColor(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Additional Info Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.getCardBackgroundColor(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (status.maintenanceType != null) ...[
                        _buildInfoRow(
                          context,
                          Icons.info_outline,
                          'Type',
                          _formatMaintenanceType(status.maintenanceType!),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      if (status.estimatedCompletion != null) ...[
                        _buildInfoRow(
                          context,
                          Icons.schedule,
                          'Est. Completion',
                          _formatDateTime(status.estimatedCompletion!),
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      if (status.systemVersion != null) ...[
                        _buildInfoRow(
                          context,
                          Icons.system_update,
                          'Version',
                          status.systemVersion!,
                        ),
                        const SizedBox(height: 12),
                      ],
                      
                      if (status.supportContact != null && 
                          status.supportContact!.isNotEmpty) ...[
                        _buildInfoRow(
                          context,
                          Icons.contact_support,
                          'Support',
                          status.supportContact!,
                        ),
                      ],
                      
                      // If no additional info, show generic message
                      if (status.maintenanceType == null &&
                          status.estimatedCompletion == null &&
                          status.systemVersion == null &&
                          (status.supportContact == null || 
                           status.supportContact!.isEmpty))
                        Text(
                          'We appreciate your patience while we improve our system.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.getTextSecondaryColor(context),
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Refresh indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 16,
                      color: AppTheme.getTextSecondaryColor(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Checking status automatically...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.orange.shade700,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.getTextSecondaryColor(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextPrimaryColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatMaintenanceType(String type) {
    switch (type.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled Maintenance';
      case 'emergency':
        return 'Emergency Maintenance';
      case 'upgrade':
        return 'System Upgrade';
      default:
        return type.substring(0, 1).toUpperCase() + type.substring(1);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.isNegative) {
      return 'Soon';
    }
    
    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      return '$days day${days > 1 ? 's' : ''}'
          '${hours > 0 ? ', $hours hour${hours > 1 ? 's' : ''}' : ''}';
    }
  }
}
