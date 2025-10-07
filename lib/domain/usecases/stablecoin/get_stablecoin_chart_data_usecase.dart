import 'package:injectable/injectable.dart';
import '../../entities/stablecoin_chart_data.dart';
import '../../repositories/stablecoin_repository.dart';

@injectable
class GetStablecoinChartDataUseCase {
  final StablecoinRepository _repository;

  GetStablecoinChartDataUseCase(this._repository);

  Future<StablecoinChartData> execute({
    required String aggregationPeriod,
  }) async {
    return await _repository.getStablecoinChartData(
      aggregationPeriod: aggregationPeriod,
    );
  }
}