import 'package:injectable/injectable.dart';
import '../../entities/chart_summary.dart';
import '../../repositories/chart_summary_repository.dart';

@injectable
class GetChartSummaryUseCase {
  final ChartSummaryRepository _repository;

  GetChartSummaryUseCase(this._repository);
  Future<ChartSummary> execute({
    required String chartType,
    String? timeFrame,
    List<Map<String, dynamic>>? chartData,
  }) async {
    return await _repository.getChartSummary(
      chartType: chartType,
      timeFrame: timeFrame,
      chartData: chartData,
    );
  }
}

