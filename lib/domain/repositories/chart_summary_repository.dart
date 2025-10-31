import '../entities/chart_summary.dart';
abstract class ChartSummaryRepository {
  Future<ChartSummary> getChartSummary({
    required String chartType,
    String? timeFrame,
    List<Map<String, dynamic>>? chartData,
  });
}

