import 'package:injectable/injectable.dart';
import '../../models/stablecoin_model.dart';
import '../../endpoints/dashboard_endpoints.dart';
import '../../../services/dio_client.dart';

@injectable
class StablecoinRemoteDataSource {
  final DioClient _dioClient;

  StablecoinRemoteDataSource(this._dioClient);

  Future<StablecoinChartDataModel> getStablecoinChartData({
    required String aggregationPeriod,
  }) async {
    try {
      final response = await _dioClient.get(
        DashboardEndpoints.stablecoinChartData,
        queryParameters: {
          'aggregation_period': aggregationPeriod,
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        
        // Extract the actual data from the success response structure
        final chartData = jsonData['data'] as Map<String, dynamic>;
        
        final model = StablecoinChartDataModel.fromJson(chartData);
        return model;
      } else {
        throw Exception('Failed to load stablecoin chart data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}