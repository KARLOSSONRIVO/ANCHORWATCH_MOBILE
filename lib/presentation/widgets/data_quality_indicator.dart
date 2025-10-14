import 'package:flutter/material.dart';
import '../../data/models/data_quality_model.dart';

/// Widget to display data quality indicators
class DataQualityIndicator extends StatelessWidget {
  final DataQualityModel? dataQuality;
  final bool showDetails;
  final VoidCallback? onTap;

  const DataQualityIndicator({
    super.key,
    this.dataQuality,
    this.showDetails = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (dataQuality == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getQualityColor(dataQuality!.qualityStatus).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getQualityColor(dataQuality!.qualityStatus).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getQualityIcon(dataQuality!.qualityStatus),
              size: 16,
              color: _getQualityColor(dataQuality!.qualityStatus),
            ),
            const SizedBox(width: 4),
            Text(
              _getQualityText(dataQuality!.qualityStatus),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getQualityColor(dataQuality!.qualityStatus),
              ),
            ),
            if (dataQuality!.hasIssues || dataQuality!.hasWarnings) ...[
              const SizedBox(width: 4),
              Icon(
                dataQuality!.hasIssues ? Icons.error : Icons.warning,
                size: 12,
                color: dataQuality!.hasIssues ? Colors.red : Colors.orange,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getQualityColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF8BC34A);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFFF5722);
      case 'critical':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getQualityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Icons.check_circle;
      case 'good':
        return Icons.check_circle_outline;
      case 'fair':
        return Icons.warning;
      case 'poor':
        return Icons.error_outline;
      case 'critical':
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  String _getQualityText(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return 'Excellent';
      case 'good':
        return 'Good';
      case 'fair':
        return 'Fair';
      case 'poor':
        return 'Poor';
      case 'critical':
        return 'Critical';
      default:
        return 'Unknown';
    }
  }
}

/// Detailed data quality widget with full metrics
class DataQualityDetails extends StatelessWidget {
  final DataQualityModel dataQuality;

  const DataQualityDetails({
    super.key,
    required this.dataQuality,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  _getQualityIcon(dataQuality.qualityStatus),
                  color: _getQualityColor(dataQuality.qualityStatus),
                ),
                const SizedBox(width: 8),
                Text(
                  'Data Quality: ${dataQuality.qualityStatus.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getQualityColor(dataQuality.qualityStatus),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Quality Scores
            _buildScoreRow('Overall Score', dataQuality.overallScore),
            _buildScoreRow('Completeness', dataQuality.completenessScore),
            _buildScoreRow('Freshness', dataQuality.freshnessScore),
            _buildScoreRow('Consistency', dataQuality.consistencyScore),
            _buildScoreRow('Accuracy', dataQuality.accuracyScore),
            
            const SizedBox(height: 16),
            
            // Data Age
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Last updated: ${dataQuality.formattedDataAge}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            // Issues and Warnings
            if (dataQuality.issues.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildIssuesSection(context, 'Issues', dataQuality.issues, Colors.red),
            ],
            
            if (dataQuality.warnings.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildIssuesSection(context, 'Warnings', dataQuality.warnings, Colors.orange),
            ],
            
            // Recommendations
            if (dataQuality.recommendations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Recommendations',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...dataQuality.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, double score) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              value: score,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getScoreColor(score),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(score * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssuesSection(BuildContext context, String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.warning, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 2),
          child: Text(
            '• $item',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
          ),
        )),
      ],
    );
  }

  Color _getQualityColor(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return const Color(0xFF4CAF50);
      case 'good':
        return const Color(0xFF8BC34A);
      case 'fair':
        return const Color(0xFFFF9800);
      case 'poor':
        return const Color(0xFFFF5722);
      case 'critical':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getQualityIcon(String status) {
    switch (status.toLowerCase()) {
      case 'excellent':
        return Icons.check_circle;
      case 'good':
        return Icons.check_circle_outline;
      case 'fair':
        return Icons.warning;
      case 'poor':
        return Icons.error_outline;
      case 'critical':
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 0.9) return const Color(0xFF4CAF50);
    if (score >= 0.8) return const Color(0xFF8BC34A);
    if (score >= 0.7) return const Color(0xFFFF9800);
    if (score >= 0.5) return const Color(0xFFFF5722);
    return const Color(0xFFF44336);
  }
}
