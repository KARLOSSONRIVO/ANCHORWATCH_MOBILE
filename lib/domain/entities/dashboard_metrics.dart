import 'stablecoin_chart_data.dart';
import 'macro_trends.dart';

class DashboardMetrics {
  final StablecoinChartData stablecoinData;
  final MacroTrendsData macroTrendsData;
  final DateTime lastUpdated;

  DashboardMetrics({
    required this.stablecoinData,
    required this.macroTrendsData,
    required this.lastUpdated,
  });
}