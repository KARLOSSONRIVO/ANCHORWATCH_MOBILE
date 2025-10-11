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
  }) async {
    try {
      final response = await _dioClient.post(
        DashboardEndpoints.chartSummary,
        data: {
          'chart_type': chartType,
        },
        options: Options(
          receiveTimeout: const Duration(minutes: 2), // 2 minutes for LLM generation
          sendTimeout: const Duration(seconds: 30),
        ),
      );
      
      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        
        // Check if the response indicates success
        if (jsonData['success'] == true) {
          final model = ChartSummaryModel.fromJson(jsonData);
          return model;
        } else {
          throw Exception('Failed to get chart summary: ${jsonData['detail'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to get chart summary: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
