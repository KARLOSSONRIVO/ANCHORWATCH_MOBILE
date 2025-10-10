import 'package:injectable/injectable.dart';
import '../../domain/entities/macro_trends.dart';
import '../../domain/repositories/macro_trends_repository.dart';
import '../datasources/remote/macro_trends_remote_data_source.dart';

@Injectable(as: MacroTrendsRepository)
class MacroTrendsRepositoryImpl implements MacroTrendsRepository {
  final MacroTrendsRemoteDataSource _remoteDataSource;

  MacroTrendsRepositoryImpl(this._remoteDataSource);

  @override
  Future<MacroTrendsData> getMacroTrendsData({
    required String aggregationPeriod,
  }) async {
    try {
      final model = await _remoteDataSource.getMacroTrendsData(
        aggregationPeriod: aggregationPeriod,
      );
      return model.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}