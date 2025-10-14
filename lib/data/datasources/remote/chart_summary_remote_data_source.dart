import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../models/chart_summary_model.dart';
import '../../endpoints/dashboard_endpoints.dart';
import '../../../services/dio_client.dart';

@injectable
class ChartSummaryRemoteDataSource {
  final DioClient _dioClient;

  ChartSummaryRemoteDataSource(this._dioClient);

  /// Get chart summary from backend
  Future<ChartSummaryModel> getChartSummary({
    required String chartType,
    String? timeFrame,
    List<Map<String, dynamic>>? chartData,
  }) async {
    try {
      final requestData = <String, dynamic>{
        'chart_type': chartType,
      };
      
      // Add timeframe if provided
      if (timeFrame != null) {
        requestData['timeframe'] = timeFrame;
      }
      
      // Add chart data if provided
      if (chartData != null) {
        requestData['chart_data'] = chartData;
      }
      
      final response = await _dioClient.post(
        DashboardEndpoints.chartSummary,
        data: requestData,
        options: Options(
          receiveTimeout: const Duration(
            minutes: 8,
          ), // 8 minutes for LLM generation (matches global timeout)
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;

        // Check if the response indicates success
        if (jsonData['success'] == true) {
          // Extract the nested data object and add timestamp from root level
          final nestedData = jsonData['data'] as Map<String, dynamic>;
          nestedData['timestamp'] =
              jsonData['timestamp']; // Add timestamp from root level

          final model = ChartSummaryModel.fromJson(nestedData);
          return model;
        } else {
          throw Exception(
            'Failed to get chart summary: ${jsonData['detail'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception('Failed to get chart summary: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
