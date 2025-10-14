import 'package:injectable/injectable.dart';
import '../../domain/entities/chart_summary.dart';
import '../../domain/repositories/chart_summary_repository.dart';
import '../datasources/remote/chart_summary_remote_data_source.dart';

@Injectable(as: ChartSummaryRepository)
class ChartSummaryRepositoryImpl implements ChartSummaryRepository {
  final ChartSummaryRemoteDataSource _remoteDataSource;

  ChartSummaryRepositoryImpl(this._remoteDataSource);

  @override
  Future<ChartSummary> getChartSummary({
    required String chartType,
    String? timeFrame,
    List<Map<String, dynamic>>? chartData,
  }) async {
    try {
      final model = await _remoteDataSource.getChartSummary(
        chartType: chartType,
        timeFrame: timeFrame,
        chartData: chartData,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
