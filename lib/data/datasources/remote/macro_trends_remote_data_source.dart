import 'package:injectable/injectable.dart';
import '../../models/macro_trends_model.dart';
import '../../endpoints/dashboard_endpoints.dart';
import '../../../services/dio_client.dart';

@injectable
class MacroTrendsRemoteDataSource {
  final DioClient _dioClient;

  MacroTrendsRemoteDataSource(this._dioClient);

  Future<MacroTrendsModel> getMacroTrendsData({
    required String aggregationPeriod,
  }) async {
    try {
      final response = await _dioClient.get(
        DashboardEndpoints.macroTrendsPage,
        queryParameters: {
          'aggregation_period': aggregationPeriod,
        },
      );
      
      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final chartData = jsonData['data'] as Map<String, dynamic>;
        
        final model = MacroTrendsModel.fromJson(chartData);
        return model;
      } else {
        throw Exception('Failed to load macro trends data: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
