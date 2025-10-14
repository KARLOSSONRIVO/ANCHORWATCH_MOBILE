import '../../domain/entities/chart_summary.dart';
import 'data_quality_model.dart';

/// Chart summary model for data serialization
class ChartSummaryModel extends ChartSummary {
  final DataQualityModel? dataQuality;
  final List<String> qualityWarnings;
  final List<String> qualityIssues;

  const ChartSummaryModel({
    required super.chartType,
    required super.summary,
    required super.source,
    required super.cacheHit,
    required super.timestamp,
    this.dataQuality,
    this.qualityWarnings = const [],
    this.qualityIssues = const [],
  });

  /// Create model from JSON
  factory ChartSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChartSummaryModel(
      chartType: json['chart_type'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      source: json['source'] as String? ?? '',
      cacheHit: json['cache_hit'] as bool? ?? false,
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      dataQuality: json['data_quality'] != null 
          ? DataQualityModel.fromJson(json['data_quality'] as Map<String, dynamic>)
          : null,
      qualityWarnings: (json['quality_warnings'] as List<dynamic>?)?.cast<String>() ?? [],
      qualityIssues: (json['quality_issues'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'chart_type': chartType,
      'summary': summary,
      'source': source,
      'cache_hit': cacheHit,
      'timestamp': timestamp.toIso8601String(),
      'data_quality': dataQuality?.toJson(),
      'quality_warnings': qualityWarnings,
      'quality_issues': qualityIssues,
    };
  }

  /// Convert to domain entity
  ChartSummary toEntity() {
    return ChartSummary(
      chartType: chartType,
      summary: summary,
      source: source,
      cacheHit: cacheHit,
      timestamp: timestamp,
    );
  }
}
