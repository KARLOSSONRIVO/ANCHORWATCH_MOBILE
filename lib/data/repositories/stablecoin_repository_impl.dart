import 'package:injectable/injectable.dart';
import '../datasources/remote/stablecoin_remote_data_source.dart';
import '../../domain/entities/stablecoin_chart_data.dart';
import '../../domain/repositories/stablecoin_repository.dart';

@Injectable(as: StablecoinRepository)
class StablecoinRepositoryImpl implements StablecoinRepository {
  final StablecoinRemoteDataSource _remoteDataSource;

  StablecoinRepositoryImpl(this._remoteDataSource);

  @override
  Future<StablecoinChartData> getStablecoinChartData({
    required String aggregationPeriod,
  }) async {
    try {
      final model = await _remoteDataSource.getStablecoinChartData(
        aggregationPeriod: aggregationPeriod,
      );
      return StablecoinChartData(
        totalSupplyOverTime: model.totalSupplyOverTime
            .map((m) => SupplyDataPoint(
                  date: m.dateTime,
                  supplyClosing: m.supplyClosing,
                ))
            .toList(),
        mintBurnActivity: model.mintBurnActivity
            .map((m) => MintBurnActivity(
                  date: m.dateTime,
                  mintUsd: m.mintUsd,
                  burnUsd: m.burnUsd,
                ))
            .toList(),
        netChangeInSupply: model.netChangeInSupply
            .map((m) => NetChangeData(
                  date: m.dateTime,
                  netChangeUsd: m.netChangeUsd,
                ))
            .toList(),
        largestMintBurnEvents: model.largestMintBurnEvents
            .map((m) => LargestMintBurnEvent(
                  date: m.dateTime,
                  largestMintUsd: m.largestMintUsd,
                  largestBurnUsd: m.largestBurnUsd,
                  marketCap: m.marketCap,
                ))
            .toList(),
        rollingAverageSupplyChanges: model.rollingAverageSupplyChanges
            .map((m) => RollingAverageSupplyChange(
                  date: m.dateTime,
                  shortTermAvg: m.shortTermAvg,
                  longTermAvg: m.longTermAvg,
                ))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
