import 'package:injectable/injectable.dart';
import '../entities/macro_trends.dart';
import '../repositories/macro_trends_repository.dart';

@injectable
class GetMacroTrendsUseCase {
  final MacroTrendsRepository _repository;

  GetMacroTrendsUseCase(this._repository);

  Future<MacroTrendsData> call({
    String aggregationPeriod = 'yearly',
  }) async {
    return await _repository.getMacroTrendsData(
      aggregationPeriod: aggregationPeriod,
    );
  }
}