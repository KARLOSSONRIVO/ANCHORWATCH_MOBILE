import '../../domain/entities/chart_summary.dart';

/// Chart summary model for data serialization
class ChartSummaryModel extends ChartSummary {
  const ChartSummaryModel({
    required super.chartType,
    required super.summary,
    required super.source,
    required super.cacheHit,
    required super.timestamp,
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
