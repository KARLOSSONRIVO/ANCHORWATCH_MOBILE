import '../entities/stablecoin_chart_data.dart';

abstract class StablecoinRepository {
  Future<StablecoinChartData> getStablecoinChartData({
    required String aggregationPeriod, // 'yearly' or 'monthly'
  });
}