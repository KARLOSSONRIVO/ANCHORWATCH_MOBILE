import 'package:injectable/injectable.dart';
import '../../entities/chart_summary.dart';
import '../../repositories/chart_summary_repository.dart';

@injectable
class GetChartSummaryUseCase {
  final ChartSummaryRepository _repository;

  GetChartSummaryUseCase(this._repository);

  /// Execute getting chart summary
  Future<ChartSummary> execute({
    required String chartType,
    String? timeFrame,
  }) async {
    return await _repository.getChartSummary(
      chartType: chartType,
      timeFrame: timeFrame,
    );
  }
}
