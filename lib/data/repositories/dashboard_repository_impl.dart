import 'package:injectable/injectable.dart';
import '../../domain/entities/dashboard_metrics.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  
  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardMetrics> fetchDashboardMetrics([String? range]) async {
    return await _remoteDataSource.getMetrics(range);
  }
}