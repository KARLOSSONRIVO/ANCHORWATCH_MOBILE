import 'package:injectable/injectable.dart';
import '../../entities/alert.dart';
import '../../repositories/alert_repository.dart';

@injectable
class GetAlertHistoryUseCase {
  final AlertRepository _repository;

  GetAlertHistoryUseCase(this._repository);

  Future<List<Alert>> call({
    int page = 1,
    int limit = 20,
    String? severity,
    String? status,
    String? type,
  }) async {
    return await _repository.getAlertHistory(
      page: page,
      limit: limit,
      severity: severity,
      status: status,
      type: type,
    );
  }
}
