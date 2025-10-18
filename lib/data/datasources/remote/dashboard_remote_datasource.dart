import 'package:injectable/injectable.dart';
import '../../../domain/entities/dashboard_metrics.dart';
import '../../../services/dio_client.dart';
import '../../endpoints/dashboard_endpoints.dart';
import '../../models/dashboard/stablecoin_model.dart';
import '../../models/dashboard/macro_trends_model.dart';

abstract interface class DashboardRemoteDataSource {
  Future<DashboardMetrics> getMetrics([String? range]);
}

@LazySingleton(as: DashboardRemoteDataSource)
class LiveDashboardRemoteDataSource implements DashboardRemoteDataSource {
  final DioClient _dioClient;

  LiveDashboardRemoteDataSource(this._dioClient);

  @override
  Future<DashboardMetrics> getMetrics([String? range]) async {
    try {
      final response = await _dioClient.get(
        DashboardEndpoints.stablecoinData,
        queryParameters: range != null ? {'aggregation_period': range} : {'aggregation_period': 'yearly'},
      );
      
      final stablecoinData = StablecoinChartDataModel.fromJson(response.data);
      final macroData = _extractMacroDataFromUnifiedResponse(response.data);
      
      return DashboardMetrics(
        stablecoinData: stablecoinData.toEntity(),
        macroTrendsData: macroData.toEntity(),
        lastUpdated: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to fetch dashboard metrics: $e');
    }
  }

  MacroTrendsModel _extractMacroDataFromUnifiedResponse(Map<String, dynamic> responseData) {
    final dataList = responseData['data'] as List<dynamic>;
    final inflationRates = <Map<String, dynamic>>[];
    
    for (final item in dataList) {
      final itemMap = item as Map<String, dynamic>;
      final dateStr = itemMap['date'] as String;
      final inflationRate = itemMap['inflation_rate'];
      
      if (inflationRate != null) {
        final year = DateTime.parse(dateStr).year;
        inflationRates.add({
          'year': year,
          'inflation_rate': inflationRate,
        });
      }
    }
    
    return MacroTrendsModel(
      annualInflationRates: inflationRates
          .map((item) => InflationRateModel.fromJson(item))
          .toList(),
    );
  }
}

