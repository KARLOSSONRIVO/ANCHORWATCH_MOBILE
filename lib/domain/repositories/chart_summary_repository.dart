import '../entities/chart_summary.dart';

/// Repository interface for chart summary operations
abstract class ChartSummaryRepository {
  /// Get chart summary for a specific chart type
  Future<ChartSummary> getChartSummary({
    required String chartType,
    String? timeFrame,
  });
}
