import 'package:injectable/injectable.dart';
import '../../entities/dashboard_metrics.dart';
import '../../repositories/dashboard_repository.dart';

@injectable
class FetchDashboardMetricsUseCase {
  final DashboardRepository _repository;

  FetchDashboardMetricsUseCase(this._repository);

  Future<DashboardMetrics> call([String? range]) async {
    return await _repository.fetchDashboardMetrics(range);
  }
}